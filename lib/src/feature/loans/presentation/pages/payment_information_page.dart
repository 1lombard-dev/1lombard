import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/main_feed/bloc/banner_cubit.dart';
import 'package:lombard/src/feature/main_feed/bloc/category_cubit.dart';

@RoutePage()
class PaymentInformationPage extends StatefulWidget implements AutoRouteWrapper {
  const PaymentInformationPage({super.key});

  @override
  _PaymentInformationPageState createState() => _PaymentInformationPageState();

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

class _PaymentInformationPageState extends State<PaymentInformationPage> {
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
            'Платеж',
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
                'Информация о платеже',
                style: AppTextStyles.fs20w600.copyWith(color: AppColors.red),
              ),
              const Gap(30),
              Row(
                children: [
                  const Text(
                    'Номер заказа: ',
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    '000-2401133',
                    style: AppTextStyles.fs16w600.copyWith(color: AppColors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Gap(15),
              Row(
                children: [
                  const Text(
                    'Вид платежа: ',
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    'Выкуп',
                    style: AppTextStyles.fs16w600.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              const Gap(15),
              Row(
                children: [
                  const Text(
                    'Номер залогового билета: ',
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    '000-2401133',
                    style: AppTextStyles.fs16w600.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              const Gap(15),
              Row(
                children: [
                  const Text(
                    'Сумма к оплате: ',
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    '44553 тг.',
                    style: AppTextStyles.fs16w600.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              const Gap(15),
              const Divider(
                color: Color(0xFF9E9D9D),
              ),
              const Gap(16),
              const Text(
                'Если все верно, нажмите кнопку "Оплатить" и Вы будете перенаправлены на страницу платежного сервиса',
                style: AppTextStyles.fs16w500,
              ),
              const Gap(19.5),
              const Divider(
                color: Color(0xFF9E9D9D),
              ),
              const Gap(39),
              CustomButton(
                onPressed: () {},
                style: CustomButtonStyles.mainButtonStyle(context, backgroundColor: AppColors.red),
                child: const Text(
                  'Оплатить',
                  style: AppTextStyles.fs18w600,
                ),
              ),
              const Gap(21),
            ],
          ),
        ),
      );
}
