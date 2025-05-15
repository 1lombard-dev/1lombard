import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/main_feed/bloc/banner_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/category_cubit.dart';

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

class _LoansPageState extends State<LoansPage> {
  final TextEditingController priceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BannerCubit>(context).getMainPageBanner();
    BlocProvider.of<CategoryCubit>(context).getCategory();
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
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
                      'Мои займы',
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
            bottom: const TabBar(
              labelColor: AppColors.red,
              unselectedLabelColor: Color(0xFF333333),
              labelStyle: AppTextStyles.fs16w600,
              unselectedLabelStyle: AppTextStyles.fs16w600,
              indicatorColor: AppColors.red, // 🔴 Set indicator color here
              tabs: [
                Tab(
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(child: Text('Активные')),
                  ),
                ),
                Tab(
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(child: Text('Выкупленные')),
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Tab 1: Активные
              ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: 10, // Example item count
                separatorBuilder: (context, index) => const Gap(12),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          context.router.push(const LoansDetailRoute());
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '000-2401133',
                                style:
                                    AppTextStyles.fs14w600.copyWith(color: AppColors.red, fontWeight: FontWeight.bold),
                              ),
                              const Gap(13),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Дата открытия:',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    '09.07.2024',
                                    style: AppTextStyles.fs14w600,
                                  ),
                                ],
                              ),
                              const Gap(10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Дата возврата:',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    '02.10.2024',
                                    style: AppTextStyles.fs14w600,
                                  ),
                                ],
                              ),
                              const Gap(10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Менеджер:',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    ' Ертанова Лаура',
                                    style: AppTextStyles.fs14w600,
                                  ),
                                ],
                              ),
                              const Gap(10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Гарантия: ',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    '30.11.2024',
                                    style: AppTextStyles.fs14w600,
                                  ),
                                ],
                              ),
                              const Gap(10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Срок выплаты:',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    ' 30',
                                    style: AppTextStyles.fs14w600,
                                  ),
                                ],
                              ),
                              const Gap(15),
                              const Divider(),
                              const Gap(10),
                              const Text(
                                'Залог',
                                style: AppTextStyles.fs16w400,
                              ),
                              const Gap(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '1 x Кольцо',
                                    style: AppTextStyles.fs16w400.copyWith(color: AppColors.black),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Статус: ',
                                        style: AppTextStyles.fs14w600,
                                      ),
                                      Text(
                                        'пролонгирован',
                                        style: AppTextStyles.fs14w600.copyWith(color: AppColors.green2),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(25),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Выплачено:\n3 642.59  ₸',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    'Всего к выплате: \n41 302.58  ₸',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                ],
                              ),
                              const Gap(23),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () {},
                                      style:
                                          CustomButtonStyles.mainButtonStyle(context, backgroundColor: AppColors.red),
                                      child: const Text(
                                        'Пролонгация',
                                        style: AppTextStyles.fs18w600,
                                      ),
                                    ),
                                  ),
                                  const Gap(17),
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () {},
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
                      ),
                    ),
                  );
                },
              ),

              // Tab 2: Выкупленные
              ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: 10, // Example item count
                separatorBuilder: (context, index) => const Gap(12),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          context.router.push(const LoansDetailRoute());
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '000-2401133',
                                style:
                                    AppTextStyles.fs14w600.copyWith(color: AppColors.red, fontWeight: FontWeight.bold),
                              ),
                              const Gap(13),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Дата открытия:',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    '09.07.2024',
                                    style: AppTextStyles.fs14w600,
                                  ),
                                ],
                              ),
                              const Gap(10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Дата возврата:',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    '02.10.2024',
                                    style: AppTextStyles.fs14w600,
                                  ),
                                ],
                              ),
                              const Gap(10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Менеджер:',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    ' Ертанова Лаура',
                                    style: AppTextStyles.fs14w600,
                                  ),
                                ],
                              ),
                              const Gap(10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Гарантия: ',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    '30.11.2024',
                                    style: AppTextStyles.fs14w600,
                                  ),
                                ],
                              ),
                              const Gap(10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Срок выплаты:',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    ' 30',
                                    style: AppTextStyles.fs14w600,
                                  ),
                                ],
                              ),
                              const Gap(15),
                              const Divider(),
                              const Gap(10),
                              const Text(
                                'Залог',
                                style: AppTextStyles.fs16w400,
                              ),
                              const Gap(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '1 x Кольцо',
                                    style: AppTextStyles.fs16w400.copyWith(color: AppColors.black),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Статус: ',
                                        style: AppTextStyles.fs14w600,
                                      ),
                                      Text(
                                        'пролонгирован',
                                        style: AppTextStyles.fs14w600.copyWith(color: AppColors.green2),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Gap(25),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Выплачено:\n3 642.59  ₸',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                  Text(
                                    'Всего к выплате: \n41 302.58  ₸',
                                    style: AppTextStyles.fs16w400,
                                  ),
                                ],
                              ),
                              const Gap(23),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () {},
                                      style:
                                          CustomButtonStyles.mainButtonStyle(context, backgroundColor: AppColors.red),
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
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
}
