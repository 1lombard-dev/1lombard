import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/pull_to_refresh_widgets.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/calculation/bloc/notification_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@RoutePage()
class CalculationPage extends StatefulWidget implements AutoRouteWrapper {
  const CalculationPage({super.key});

  @override
  State<CalculationPage> createState() => _CalculationPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationCubit(repository: context.repository.notificationRepository),
          child: this,
        ),
      ],
      child: this,
    );
  }
}

class _CalculationPageState extends State<CalculationPage> {
  final RefreshController _refreshController = RefreshController();
  // List<String> title = [
  //   'Тестілеу ақпараттары',
  //   'Бонустар және баланс',
  //   'Тест жауаптары',
  //   'Хабарламалар',
  // ];

  // List<bool> count = [
  //   true,
  //   false,
  //   true,
  //   false,
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundInput,
      appBar: AppBar(
        title: const Text(
          'Рассчет',
          style: AppTextStyles.fs18w600,
        ),
        shape: const Border(
          bottom: BorderSide(
            color: AppColors.dividerGrey,
            width: 0.5,
          ),
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        header: const RefreshClassicHeader(),
        onRefresh: () {},
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return Container(
              // height: 80,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(top: BorderSide(color: AppColors.dividerGrey, width: 0.5)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 22,
                              width: 22,
                              decoration: const BoxDecoration(
                                color: AppColors.mainBlueColor,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '1',
                                  style: AppTextStyles.fs12w600.copyWith(color: AppColors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
