import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_widget.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/pull_to_refresh_widgets.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/main_feed/bloc/banner_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/category_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/get_faq_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/get_token_cubit.dart';
import 'package:lombard/src/feature/main_feed/presentation/widget/image_slider_widget.dart';
import 'package:lombard/src/feature/main_feed/presentation/widget/main_list_container_widget.dart';
import 'package:lombard/src/feature/main_feed/presentation/widget/main_row_container.dart';
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
        BlocProvider(
          create: (context) => GetFaqCubit(repository: context.repository.mainRepository),
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
    BlocProvider.of<GetTokenCubit>(context).getToken();
    BlocProvider.of<GetFaqCubit>(context).getFAQ();
    BlocProvider.of<BannerCubit>(context).getMainPageBanner();
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
                  Image.asset(
                    Assets.images.logoHeader.path,
                    height: 34,
                  ),
                  Container(
                    decoration: BoxDecoration(color: AppColors.eFGrey, borderRadius: BorderRadius.circular(11)),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                      child: InkWell(
                        onTap: () {
                          context.router.push(const NotificationRoute());
                        },
                        borderRadius: BorderRadius.circular(11),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Image.asset(
                            Assets.images.notification.path,
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                    ),
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
        body: SafeArea(
          child: SmartRefresher(
            controller: _refreshController,
            header: const RefreshClassicHeader(),
            onRefresh: () {
              // BlocProvider.of<BannerCubit>(context).getMainPageBanner();
              // BlocProvider.of<CategoryCubit>(context).getCategory();
              _refreshController.refreshCompleted();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<BannerCubit, BannerState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () {
                          return const CustomLoadingWidget();
                        },
                        loaded: (bannerList) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: ImageSliderWidget(
                              banners: bannerList,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  Container(
                    decoration: const BoxDecoration(color: AppColors.white),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 11).copyWith(bottom: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Наша расценка на 09.09.24',
                            style: AppTextStyles.fs16w500.copyWith(color: AppColors.black),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(17),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(5, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10.0, left: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.circular(5),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                          child: Column(
                                            children: [
                                              Text(
                                                'AU 999',
                                                style: AppTextStyles.fs14w500.copyWith(
                                                  color: AppColors.black,
                                                ),
                                              ),
                                              const Gap(5),
                                              Container(
                                                decoration: const BoxDecoration(
                                                  color: AppColors.red,
                                                ),
                                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                                                child: Text(
                                                  '37250 ₸',
                                                  style: AppTextStyles.fs14w600
                                                      .copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15).copyWith(bottom: 30),
                    child: Container(
                      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.only(left: 21, top: 16, bottom: 11, right: 21),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainRowContainer(
                            image: Assets.images.standart.path,
                            title: 'Стандарт',
                            onTap: () {},
                          ),
                          MainRowContainer(
                            image: Assets.images.refinance.path,
                            title: 'Рефинансирование',
                            onTap: () {},
                          ),
                          MainRowContainer(
                            image: Assets.images.map.path,
                            title: 'Карта',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  BlocBuilder<GetFaqCubit, GetFaqState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () {
                          return const CustomLoadingOverlayWidget();
                        },
                        loaded: (faq) {
                          return Column(
                            children: [
                              const Center(
                                child: Text(
                                  'Ответы на ваши вопросы ',
                                  style: AppTextStyles.fs16w700,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Gap(20),

                              // Обернули в SizedBox с фиксированной высотой, чтобы ListView работал внутри Column
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: faq.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(bottom: index == faq.length - 1 ? 0 : 15),
                                    child: MainListContainerWidget(
                                      title: faq[index].title ?? 'ERROR',
                                      introtext: faq[index].introtext ?? 'ERROR',
                                    ),
                                  );
                                },
                              ),
                              const Gap(50),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
