import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/main_feed/bloc/banner_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/category_cubit.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@RoutePage()
class MapPage extends StatefulWidget implements AutoRouteWrapper {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BannerCubit(repository: context.repository.mainRepository),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(repository: context.repository.mainRepository),
        ),
      ],
      child: this,
    );
  }
}

class _MapPageState extends State<MapPage> {
  final TextEditingController priceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BannerCubit>(context).getMainPageBanner();
    BlocProvider.of<CategoryCubit>(context).getCategory();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.backgroundInput,
        appBar: AppBar(
          title: Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Карта',
                    style: AppTextStyles.fs18w600.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    Assets.images.logoHeader.path,
                    height: 34,
                  ),
                ],
              ),
            ),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: AppColors.dividerGrey,
              width: 0.5,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 320,
                width: double.infinity,
                child: YandexMap(
                  onMapCreated: (controller) {
                    // Do something with the controller
                  },
                ),
              ),
              const Gap(18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Отделения',
                      style: AppTextStyles.fs20w600.copyWith(color: AppColors.red),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Все отделения ->',
                        style: AppTextStyles.fs14w600.copyWith(color: AppColors.grayText),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(25),
              Column(
                children: List.generate(10, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0, left: 16, right: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            context.router.push(const AllBranchesRoute());
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ул. Назарбаева 137',
                                  style: AppTextStyles.fs14w500.copyWith(
                                    color: AppColors.black,
                                  ),
                                ),
                                const Gap(10),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('300м', style: AppTextStyles.fs16w400),
                                    Text('+7 777 999 77 99', style: AppTextStyles.fs14w600),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('300м', style: AppTextStyles.fs16w400),
                                        Text('9:00 - 18:00', style: AppTextStyles.fs14w600),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {},
                                          child: Image.asset(
                                            Assets.images.phone.path,
                                            width: 32,
                                            height: 32,
                                          ),
                                        ),
                                        const Gap(14),
                                        InkWell(
                                          onTap: () {},
                                          child: Image.asset(
                                            Assets.images.a2gis.path,
                                            width: 32,
                                            height: 32,
                                          ),
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
                      ),
                    ),
                  );
                }),
              ),
              const Gap(45),
            ],
          ),
        ),
      );
}
