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
                        children: [
                          if (bannerList != [])
                            ImageSliderWidget(
                              banners: bannerList,
                            ),
                          const Gap(21),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Наша расценка на ${DateFormat('dd.MM.yy').format(DateTime.now())}',
                                  style: AppTextStyles.fs16w500,
                                ),
                                const Gap(12),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: goldDTO
                                      .where((e) => ['999.9', '750', '585'].contains(e.sample))
                                      .map(
                                        (item) => Container(
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(12),
                                              onTap: () {
                                                AutoTabsRouter.of(context).setActiveIndex(1);
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(12),
                                                child: Column(
                                                  children: [
                                                    Text('AU ${item.sample}', style: AppTextStyles.fs14w500),
                                                    const Gap(6),
                                                    Text(
                                                      '${item.price} ₸',
                                                      style: AppTextStyles.fs14w600.copyWith(color: Colors.red),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20, vertical: 15).copyWith(bottom: 30, top: 35),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
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
