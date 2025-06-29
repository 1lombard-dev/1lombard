import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/pull_to_refresh_widgets.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/main_feed/bloc/main_cubit.dart';
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
          create: (context) => MainCubit(
            repository: context.repository.mainRepository,
            calRepository: context.repository.calculacationRepository,
          ),
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
    BlocProvider.of<MainCubit>(context).getFAQ();
    BlocProvider.of<MainCubit>(context).getMainPageBanner();
    BlocProvider.of<MainCubit>(context).getGoldList();
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
        body: BlocBuilder<MainCubit, MainState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () {
                return const CustomLoadingOverlayWidget();
              },
              loaded: (bannerList, faq, goldDTO) {
                return SafeArea(
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
                          if (bannerList != [])
                            ImageSliderWidget(
                              banners: bannerList,
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
                                    'Наша расценка на ${DateFormat('dd.MM.yy').format(DateTime.now())}',
                                    style: AppTextStyles.fs16w500.copyWith(color: AppColors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Gap(17),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: goldDTO
                                          .where(
                                            (item) =>
                                                item.sample == '999.9' || item.sample == '750' || item.sample == '585',
                                          )
                                          .toList()
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        final index = entry.key;
                                        final item = entry.value;

                                        return Padding(
                                          padding: EdgeInsets.only(right: 16.0, left: index == 0 ? 16 : 0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Material(
                                              borderRadius: BorderRadius.circular(5),
                                              color: Colors.transparent,
                                              child: InkWell(
                                                onTap: () {
                                                  AutoTabsRouter.of(context).setActiveIndex(1);
                                                },
                                                borderRadius: BorderRadius.circular(5),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'AU ${item.sample}',
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
                                                          '${item.price} ₸',
                                                          style: AppTextStyles.fs14w600.copyWith(
                                                            color: AppColors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
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
                                    image: Assets.images.refinance.path,
                                    title: context.localized.news,
                                    onTap: () {
                                      context.router.push(const NewsRoute());
                                    },
                                  ),
                                  MainRowContainer(
                                    image: Assets.images.standart.path,
                                    title: 'Стандарт',
                                    onTap: () {
                                      // Переключение на таб с индексом 1 (например, BaseCalculationTab)
                                      AutoTabsRouter.of(context).setActiveIndex(1);
                                    },
                                  ),
                                  MainRowContainer(
                                    image: Assets.images.map.path,
                                    title: 'Карта',
                                    onTap: () {
                                      // Переключение на таб с индексом 3 (например, BaseMapTab)
                                      AutoTabsRouter.of(context).setActiveIndex(3);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  context.localized.answersToYourQuestions,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
}
