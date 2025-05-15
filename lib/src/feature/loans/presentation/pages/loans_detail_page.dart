import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/main_feed/bloc/banner_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/category_cubit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

@RoutePage()
class LoansDetailPage extends StatefulWidget implements AutoRouteWrapper {
  const LoansDetailPage({super.key});

  @override
  _LoansDetailPageState createState() => _LoansDetailPageState();

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

class _LoansDetailPageState extends State<LoansDetailPage> {
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
          title: Text(
            'Займ 000-2401133',
            style: AppTextStyles.fs18w600.copyWith(fontWeight: FontWeight.bold),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: AppColors.dividerGrey,
              width: 0.5,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),
              Text(
                '000-2401133',
                style: AppTextStyles.fs14w600.copyWith(color: AppColors.red, fontWeight: FontWeight.bold),
              ),
              const Gap(13),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Статус: ',
                            style: AppTextStyles.fs16w500,
                          ),
                          Text(
                            'пролонгирован',
                            style: AppTextStyles.fs16w500.copyWith(color: AppColors.green2),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          const Text(
                            'Дата открытия:',
                            style: AppTextStyles.fs16w500,
                          ),
                          Text(
                            ' 09.07.2024',
                            style: AppTextStyles.fs18w600.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          const Text(
                            'Дата возврата:',
                            style: AppTextStyles.fs16w500,
                          ),
                          Text(
                            ' 02.10.2024',
                            style: AppTextStyles.fs18w600.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          const Text(
                            'Менеджер: ',
                            style: AppTextStyles.fs16w500,
                          ),
                          Text(
                            ' Ертанова Лаура',
                            style: AppTextStyles.fs18w600.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          const Text(
                            'Гарантия: ',
                            style: AppTextStyles.fs16w500,
                          ),
                          Text(
                            '30.11.2024',
                            style: AppTextStyles.fs18w600.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          const Text(
                            'Срок выплаты: ',
                            style: AppTextStyles.fs16w500,
                          ),
                          Text(
                            ' 30',
                            style: AppTextStyles.fs18w600.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 10.0,
                    percent: 0.5,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Осталось\nдней/часов",
                          style: AppTextStyles.fs14w500.copyWith(color: AppColors.black),
                        ),
                        Text(
                          '14',
                          style: AppTextStyles.fs30w600.copyWith(color: const Color(0xFFFF5C5C)),
                        ),
                        Text(
                          'дней',
                          style: AppTextStyles.fs14w500.copyWith(color: AppColors.black),
                        ),
                      ],
                    ),
                    progressColor: const Color(0xFFFF5C5C),
                  ),
                ],
              ),
              const Gap(23),
              const Divider(
                color: Color(0xFF9E9D9D),
              ),
              const Gap(16),
              Row(
                children: [
                  const Text(
                    'Залог',
                    style: AppTextStyles.fs16w500,
                  ),
                  const Gap(50),
                  Text(
                    'Фото',
                    style: AppTextStyles.fs18w600.copyWith(color: AppColors.black),
                  ),
                ],
              ),
              const Gap(22),
              const Text(
                '1 x Кольцо',
                style: AppTextStyles.fs16w500,
              ),
              const Gap(19.5),
              const Divider(
                color: Color(0xFF9E9D9D),
              ),
              const Gap(19),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Всего к выплате: ',
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    '41 302.58  ₸',
                    style: AppTextStyles.fs18w600,
                  ),
                ],
              ),
              const Gap(6),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выплачено:',
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    '41 302.58  ₸',
                    style: AppTextStyles.fs18w600,
                  ),
                ],
              ),
              const Gap(39),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {},
                      style: CustomButtonStyles.mainButtonStyle(context, backgroundColor: AppColors.red),
                      child: const Text(
                        'Пролонгация',
                        style: AppTextStyles.fs18w600,
                      ),
                    ),
                  ),
                  const Gap(17),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        context.router.push(const PaymentInformationRoute());
                      },
                      style: CustomButtonStyles.mainButtonStyle(
                        context,
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(),
                      ),
                      child: Text(
                        'Выкуп',
                        style: AppTextStyles.fs18w600.copyWith(color: AppColors.black),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(21),
            ],
          ),
        ),
      );
}
