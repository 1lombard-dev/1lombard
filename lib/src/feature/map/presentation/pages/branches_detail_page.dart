import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/textfields/custom_textfield.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/core/utils/layout/url_util.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:lombard/src/feature/map/bloc/city_cubit.dart';

@RoutePage()
class BranchesDetailPage extends StatefulWidget implements AutoRouteWrapper {
  final String title;
  const BranchesDetailPage({super.key, required this.title});

  @override
  _BranchesDetailPageState createState() => _BranchesDetailPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CityCubit(repository: context.repository.mapRepository),
        ),
      ],
      child: this,
    );
  }
}

class _BranchesDetailPageState extends State<BranchesDetailPage> {
  final TextEditingController searchController = TextEditingController();
  List<LayersDTO> originalList = [];
  List<LayersDTO> filteredList = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    BlocProvider.of<CityCubit>(context).getCityDetail(name: widget.title);
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredList = originalList.where((e) {
        final branchName = (e.branchname ?? '').toLowerCase();
        final address = (e.address ?? '').toLowerCase();
        return branchName.contains(query) || address.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.backgroundInput,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: AppTextStyles.fs18w600.copyWith(fontWeight: FontWeight.bold),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: AppColors.dividerGrey,
              width: 0.5,
            ),
          ),
        ),
        body: BlocListener<CityCubit, CityState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (data) {
                setState(() {
                  originalList = data;
                  filteredList = data;
                });
              },
              orElse: () {},
            );
          },
          child: BlocBuilder<CityCubit, CityState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => const CustomLoadingOverlayWidget(),
                loaded: (_) => _buildContent(),
              );
            },
          ),
        ),
      );

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomTextField(
              controller: searchController,
              suffixIcon: const Icon(Icons.search),
              hintText: context.localized.forExampleAddress,
            ),
          ),
          const Gap(30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              context.localized.branches,
              style: AppTextStyles.fs20w600.copyWith(color: AppColors.red),
            ),
          ),
          const Gap(25),
          ...filteredList.map((item) => _buildBranchItem(item)),
          const Gap(45),
        ],
      ),
    );
  }

  Widget _buildBranchItem(LayersDTO item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 16, right: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
          child: item.time == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.branchname ?? "ERROR NAME",
                          style: AppTextStyles.fs16w500.copyWith(color: AppColors.black),
                        ),
                        Text(item.phones ?? "ERROR phones", style: AppTextStyles.fs16w600),
                      ],
                    ),
                    const Gap(14),
                    Row(
                      mainAxisAlignment: item.time == null ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                      children: [
                        if (item.time != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.time!, style: AppTextStyles.fs16w600),
                            ],
                          ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                UrlUtil.launchPhoneUrl(context, phone: item.phones!);
                              },
                              child: Image.asset(Assets.images.phone.path, width: 32, height: 32),
                            ),
                            const Gap(14),
                            InkWell(
                              onTap: () async {
                                final coordsString = item.coords;
                                if (coordsString != null) {
                                  final coords = coordsString
                                      .replaceAll('[', '')
                                      .replaceAll(']', '')
                                      .split(',')
                                      .map((e) => e.trim())
                                      .toList();
                                  if (coords.length == 2) {
                                    final lat = coords[0];
                                    final lon = coords[1];
                                    final uri = Uri.parse('dgis://2gis.ru/routeSearch/rsType/car/to/$lon,$lat');
                                    UrlUtil.launch(context, url: uri.toString());
                                  }
                                }
                              },
                              child: Image.asset(Assets.images.a2gis.path, width: 32, height: 32),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(21),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.branchname ?? "ERROR NAME",
                          style: AppTextStyles.fs16w500.copyWith(color: AppColors.black),
                        ),
                        Text(item.phones ?? "ERROR phones", style: AppTextStyles.fs16w600),
                      ],
                    ),
                    const Divider(),
                    const Gap(4),
                    Row(
                      mainAxisAlignment: item.time == null ? MainAxisAlignment.end : MainAxisAlignment.spaceBetween,
                      children: [
                        if (item.time != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.time!, style: AppTextStyles.fs16w600),
                            ],
                          ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                UrlUtil.launchPhoneUrl(context, phone: item.phones!);
                              },
                              child: Image.asset(Assets.images.phone.path, width: 32, height: 32),
                            ),
                            const Gap(14),
                            InkWell(
                              onTap: () async {
                                final coordsString = item.coords;
                                if (coordsString != null) {
                                  final coords = coordsString
                                      .replaceAll('[', '')
                                      .replaceAll(']', '')
                                      .split(',')
                                      .map((e) => e.trim())
                                      .toList();
                                  if (coords.length == 2) {
                                    final lat = coords[0];
                                    final lon = coords[1];
                                    final uri = Uri.parse('dgis://2gis.ru/routeSearch/rsType/car/to/$lon,$lat');
                                    UrlUtil.launch(context, url: uri.toString());
                                  }
                                }
                              },
                              child: Image.asset(Assets.images.a2gis.path, width: 32, height: 32),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(21),
                  ],
                ),
        ),
      ),
    );
  }
}
