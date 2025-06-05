import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/textfields/custom_textfield.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/main_feed/model/main_page_dto.dart';
import 'package:lombard/src/feature/map/bloc/city_cubit.dart';

@RoutePage()
class AllBranchesPage extends StatefulWidget implements AutoRouteWrapper {
  const AllBranchesPage({super.key});

  @override
  _AllBranchesPageState createState() => _AllBranchesPageState();

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

class _AllBranchesPageState extends State<AllBranchesPage> {
  final TextEditingController searchController = TextEditingController();
  List<LayersDTO> allCities = [];
  List<LayersDTO> filteredCities = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CityCubit>(context).getCity();
  }

  void _filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCities = allCities;
      } else {
        final lowerQuery = query.toLowerCase();
        filteredCities = allCities.where((city) => city.cityname?.toLowerCase().contains(lowerQuery) ?? false).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.backgroundInput,
        appBar: AppBar(
          title: Text(
            'Все отделения',
            style: AppTextStyles.fs18w600.copyWith(fontWeight: FontWeight.bold),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: AppColors.dividerGrey,
              width: 0.5,
            ),
          ),
        ),
        body: BlocBuilder<CityCubit, CityState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => const CustomLoadingOverlayWidget(),
              loaded: (cityList) {
                // Сохраняем все города при первом билде
                if (allCities.isEmpty) {
                  allCities = cityList;
                  filteredCities = cityList;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(15),
                        CustomTextField(
                          controller: searchController,
                          suffixIcon: const Icon(Icons.search),
                          hintText: 'Например: город Алматы',
                          onChanged: _filterCities,
                        ),
                        const Gap(30),
                        Text(
                          'Выберите город',
                          style: AppTextStyles.fs20w600.copyWith(color: AppColors.red),
                        ),
                        const Gap(20),
                        ...filteredCities.map((city) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    context.router.push(BranchesDetailRoute(title: city.cityname!));
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            city.cityname ?? 'ERROR NAME',
                                            style: AppTextStyles.fs16w500.copyWith(color: Colors.black),
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios_outlined),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
}
