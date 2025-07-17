import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/auth/presentation/pages/auth_page.dart';
import 'package:lombard/src/feature/loans/bloc/get_active_tickets_cubit.dart';
import 'package:lombard/src/feature/loans/presentation/widget/active_container_widget.dart';
import 'package:lombard/src/feature/loans/presentation/widget/archive_container_widget.dart';

@RoutePage()
class LoansPage extends StatefulWidget implements AutoRouteWrapper {
  const LoansPage({super.key});

  @override
  _LoansPageState createState() => _LoansPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetActiveTicketsCubit(repository: context.repository.loansRepository),
        ),
      ],
      child: this,
    );
  }
}

class _LoansPageState extends State<LoansPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        return state.maybeWhen(
          inApp: () => const _LoanPage(),
          orElse: () => const AuthPage(),
        );
      },
    );
  }
}

class _LoanPage extends StatefulWidget {
  const _LoanPage();

  @override
  State<_LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<_LoanPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize TabController
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);

    // Initial fetch for active tickets
    BlocProvider.of<GetActiveTicketsCubit>(context).getActiveTickets();
  }

  void _handleTabChange() {
    // Only trigger on actual tab changes (not animation)
    if (_tabController.indexIsChanging) return;

    if (_tabController.index == 0) {
      // Tab 0: Активные
      BlocProvider.of<GetActiveTicketsCubit>(context).getActiveTickets();
      debugPrint('Switched to Active tab');
    } else if (_tabController.index == 1) {
      // Tab 1: Выкупленные
      BlocProvider.of<GetActiveTicketsCubit>(context).getArchiveTickets();
      debugPrint('Switched to Archive tab');
      // You can fetch archive data here if needed
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: Container(
              decoration: const BoxDecoration(color: AppColors.white),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.localized.myLoans,
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
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppColors.red,
              unselectedLabelColor: const Color(0xFF333333),
              labelStyle: AppTextStyles.fs16w600,
              unselectedLabelStyle: AppTextStyles.fs16w600,
              indicatorColor: AppColors.red,
              tabs: [
                Tab(child: Center(child: Text(context.localized.active))),
                Tab(child: Center(child: Text(context.localized.redeemed))),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // TAB 0: Активные билеты
              BlocBuilder<GetActiveTicketsCubit, GetActiveTicketsState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const CustomLoadingOverlayWidget(),
                    loaded: (tickets) {
                      return tickets.isEmpty || tickets[0].status == 'error'
                          ? Center(
                              child: Column(
                                children: [
                                  Image.asset(
                                    Assets.images.find.path,
                                  ),
                                  Text(
                                    context.localized.thereNoActiveTickets,
                                    style: AppTextStyles.fs24w700,
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: tickets.length,
                              separatorBuilder: (context, index) => const Gap(12),
                              itemBuilder: (context, index) {
                                return ActiveContainerWidget(
                                  ticketsDTO: tickets[index],
                                ); // Replace with ticket data if needed
                              },
                            );
                    },
                  );
                },
              ),

              // TAB 1: Выкупленные билеты
              BlocBuilder<GetActiveTicketsCubit, GetActiveTicketsState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const CustomLoadingOverlayWidget(),
                    loadedArchive: (tickets) {
                      return tickets.isEmpty || tickets[0].status == 'error'
                          ? Center(
                              child: Column(
                                children: [
                                  Image.asset(Assets.images.find.path),
                                  Text(
                                    context.localized.noPurchasedTickets,
                                    style: AppTextStyles.fs24w700,
                                  ),
                                ],
                              ),
                            )
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: tickets.length,
                              separatorBuilder: (context, index) => const Gap(12),
                              itemBuilder: (context, index) {
                                return ArchiveContainerWidget(
                                  ticketsDTO: tickets[index],
                                ); // Replace with archive data if needed
                              },
                            );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
}
