import 'package:animations/animations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/app/presentation/widgets/base_tabs.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';

class BaseStudent extends StatefulWidget {
  const BaseStudent({super.key});

  @override
  _BaseStudentState createState() => _BaseStudentState();
}

class _BaseStudentState extends State<BaseStudent> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 5,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: AppColors.barrierColor,
      overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
      child: AutoTabsScaffold(
        routes: const [
          BaseMainFeedTab(),
          BaseCalculationTab(),
          BaseLoansTab(),
          BaseMapTab(),
          BaseProfileTab(),
        ],
        appBarBuilder: (context, tabsRouter) => switch (tabsRouter.activeIndex) {
          // 1 => AppBar(
          //     title: Text(
          //       'Каталог',
          //       style: AppTextStyles.fs16w700.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // 2 => AppBar(
          //     title: Text(
          //       'Избранное',
          //       style: AppTextStyles.fs16w700.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // 3 => AppBar(
          //     title: Text(
          //       'Корзина',
          //       style: AppTextStyles.fs16w700.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // 4 => AppBar(
          //     title: Text(
          //       'Мой профиль',
          //       style: AppTextStyles.body16SemiboldH25.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          _ => PreferredSize(
              preferredSize: Size.fromHeight(MediaQuery.paddingOf(context).top),
              child: SizedBox(
                height: MediaQuery.paddingOf(context).top,
              ),
            ),
        },
        transitionBuilder: (context, child, animation) {
          return PageTransitionSwitcher(
            duration: const Duration(seconds: 2),
            reverse: true,
            transitionBuilder: (
              Widget child,
              Animation<double> animation1,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                fillColor: Colors.transparent,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: child,
          );
        },
        bottomNavigationBuilder: (context, tabsRouter) => BaseStudentBottomNavbar(
          tabController: _tabController,
          tabsRouter: tabsRouter,
        ),
      ),
    );
  }
}

class BaseStudentBottomNavbar extends StatefulWidget {
  const BaseStudentBottomNavbar({
    super.key,
    required this.tabsRouter,
    required this.tabController,
  });
  final TabsRouter tabsRouter;
  final TabController tabController;

  @override
  State<BaseStudentBottomNavbar> createState() => _BaseStudentBottomNavbarState();
}

class _BaseStudentBottomNavbarState extends State<BaseStudentBottomNavbar> {
  int lastTab = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 4,
        bottom: 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.dividerGrey, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            blurRadius: 80,
          ),
        ],
      ),
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, appState) {
          return TabBar(
            // tabAlignment: TabAlignment.fill,
            // textScaler: const TextScaler.linear(0.7),
            controller: widget.tabController,
            labelColor: AppColors.text,
            labelStyle: AppTextStyles.fs12w500.copyWith(letterSpacing: -0.32),
            unselectedLabelStyle: AppTextStyles.fs12w500.copyWith(letterSpacing: -0.32),
            unselectedLabelColor: AppColors.text,
            // automaticIndicatorColorAdjustment: false,
            enableFeedback: false,
            dividerHeight: 0,
            // indicatorSize: TabBarIndicatorSize.tab,
            indicator: const BoxDecoration(),
            onTap: (value) {
              HapticFeedback.mediumImpact();
              appState.maybeWhen(
                // notAuthorized: () {
                //   if (value == 2) {
                //     context.router.push(const AuthRoute());
                //     log('---${widget.tabController.index}');
                //     log('---v$value');
                //   } else {
                //     if (widget.tabsRouter.activeIndex == value) {
                //       widget.tabsRouter.maybePopTop();
                //       lastTab = value;
                //       log('--${widget.tabController.index}');
                //       log('--v$value');
                //     } else {
                //       widget.tabsRouter.setActiveIndex(value);
                //       lastTab = value;
                //       log('-${widget.tabController.index}');
                //       log('-v$value');
                //     }
                //   }

                //   // if (widget.tabsRouter.activeIndex == value) {
                //   //   log('maybePOP');
                //   //   widget.tabsRouter.maybePopTop();
                //   //   lastTab = value;
                //   // } else {
                //   //   log('setActive');
                //   //   widget.tabsRouter.setActiveIndex(value);
                //   //   lastTab = value;
                //   // }
                // },
                orElse: () {
                  if (widget.tabsRouter.activeIndex == value) {
                    widget.tabsRouter.maybePopTop();
                    lastTab = value;
                  } else {
                    widget.tabsRouter.setActiveIndex(value);
                    lastTab = value;
                  }
                },
              );
            },
            tabs: [
              CustomTabWidget(
                icon: Assets.images.homePageIcon.path,
                activeIcon: Assets.images.homePageActiveIcon.path,
                title: 'Главная',
                currentIndex: widget.tabController.index,
                tabIndex: 0,
              ),
              CustomTabWidget(
                icon: Assets.images.calculationPageIcon.path,
                activeIcon: Assets.images.calculationPageActiveIcon.path,
                title: 'Рассчет',
                currentIndex: widget.tabController.index,
                tabIndex: 1,
              ),
              CustomTabWidget(
                icon: Assets.images.loansPageIcon.path,
                activeIcon: Assets.images.loansPageActiveIcon.path,
                title: 'Займы',
                currentIndex: widget.tabController.index,
                tabIndex: 2,
              ),
              CustomTabWidget(
                icon: Assets.images.mapPageIcon.path,
                activeIcon: Assets.images.mapePageActiveIcon.path,
                title: 'Карта',
                currentIndex: widget.tabController.index,
                tabIndex: 3,
              ),
              CustomTabWidget(
                icon: Assets.images.profilePageIcon.path,
                activeIcon: Assets.images.profilePageActiveIcon.path,
                title: 'Кабинет',
                currentIndex: widget.tabController.index,
                tabIndex: 4,
              ),
            ],
          );
        },
      ),
    );
  }
}
