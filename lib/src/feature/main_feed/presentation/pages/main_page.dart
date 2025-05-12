import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/pull_to_refresh_widgets.dart';
import 'package:lombard/src/core/presentation/widgets/shimmer/shimmer_box.dart';
// import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/main_feed/bloc/banner_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/category_cubit.dart';
import 'package:lombard/src/feature/main_feed/presentation/widget/banner_bs.dart';
import 'package:lombard/src/feature/main_feed/presentation/widget/subject_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage()
class MainPage extends StatefulWidget implements AutoRouteWrapper {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();

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

class _MainPageState extends State<MainPage> {
  final RefreshController _refreshController = RefreshController();

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
            child: Row(
              children: [
                // Image.asset(
                //   Assets.images.appbarLogo.path,
                //   height: 36,
                // ),
              ],
            ),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: AppColors.dividerGrey,
              width: 0.5,
            ),
          ),
        ),
        body: SafeArea(
          child: SmartRefresher(
            controller: _refreshController,
            header: const RefreshClassicHeader(),
            onRefresh: () {
              BlocProvider.of<BannerCubit>(context).getMainPageBanner();
              BlocProvider.of<CategoryCubit>(context).getCategory();
              _refreshController.refreshCompleted();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocConsumer<BannerCubit, BannerState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () => const ShimmerBox(
                            height: 191.6,
                            width: double.infinity,
                          ),
                          loaded: (bannerList) => GestureDetector(
                            onTap: () {
                              BannerBS.show(context, bannerList);
                            },
                            // child: Image.asset(Assets.images.bannerMain.path),
                          ),
                        );
                      },
                    ),
                    const Gap(24),
                    const Text(
                      'Өз пәніңізді таңдаңыз',
                      style: AppTextStyles.fs20w700,
                    ),
                    const Gap(6),
                    BlocConsumer<CategoryCubit, CategoryState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () => ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10, top: 6),
                                    child: ShimmerBox(
                                      height: 22,
                                      width: 200,
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: 2,
                                    itemBuilder: (context, indexTwo) {
                                      return const Padding(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: ShimmerBox(
                                          height: 78,
                                          width: double.infinity,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          loaded: (categoryList) => Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: categoryList.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (categoryList[index].subjects!.isNotEmpty &&
                                          categoryList[index].subjects != null)
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10, top: 6),
                                          child: Text(
                                            '${categoryList[index].categoryName}',
                                            style: AppTextStyles.fs14w500,
                                          ),
                                        ),
                                      if (categoryList[index].subjects!.isNotEmpty &&
                                          categoryList[index].subjects != null)
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: categoryList[index].subjects?.length,
                                          itemBuilder: (context, indexTwo) {
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 8),
                                              child: SubjectItem(
                                                testQuantity:
                                                    '${categoryList[index].subjects?[indexTwo].questionsCount} тест',
                                                title: '${categoryList[index].subjects?[indexTwo].name}',
                                                onTap: () {
                                                  log('${context.appBloc.isAuthenticated}', name: 'isAuthenticated');
                                                  if (context.appBloc.isAuthenticated == false) {
                                                    context.router.push(const AuthRoute());
                                                  } else if (context.appBloc.isAuthenticated == true) {
                                                    context.router.push(
                                                      SubjectRoute(
                                                        subjectDTO: categoryList[index].subjects?[indexTwo],
                                                        categoryDTO: categoryList,
                                                        categoryIndex: index,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  );
                                },
                              ),
                              const Gap(14),
                              const Gap(12),
                              Center(
                                child: Text(
                                  'Басқа пәндер жақын арада қосылады',
                                  style: AppTextStyles.fs14w600.copyWith(height: 1.7, color: AppColors.green2),
                                ),
                              ),
                              const Gap(4),
                              Center(
                                child: Text(
                                  'Еліміздің үздік тренерлері тесттерді дайындау үстінде...',
                                  style: AppTextStyles.fs12w400.copyWith(height: 1.6, color: AppColors.darkBlueText),
                                ),
                              ),
                              const Gap(50),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
