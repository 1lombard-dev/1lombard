import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/loans/bloc/get_payment_cubit.dart';
import 'package:lombard/src/feature/loans/model/tickets_dto.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

@RoutePage()
class LoansDetailPage extends StatefulWidget implements AutoRouteWrapper {
  final TicketsDTO ticketsDTO;
  const LoansDetailPage({super.key, required this.ticketsDTO});

  @override
  _LoansDetailPageState createState() => _LoansDetailPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetPaymentCubit(repository: context.repository.loansRepository),
        ),
      ],
      child: this,
    );
  }
}

class _LoansDetailPageState extends State<LoansDetailPage> {
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.backgroundInput,
        appBar: AppBar(
          title: Text(
            'Займ ${widget.ticketsDTO.ticketnumber ?? 'ERROR'}',
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
                widget.ticketsDTO.ticketnumber ?? 'ERROR',
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
                            widget.ticketsDTO.status ?? 'ERROR',
                            style: AppTextStyles.fs16w500.copyWith(color: AppColors.green2),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          Text(
                            context.localized.openingDate,
                            style: AppTextStyles.fs16w500,
                          ),
                          Text(
                            widget.ticketsDTO.issuedate ?? 'ERROR',
                            style: AppTextStyles.fs18w600.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          Text(
                            context.localized.returnDate,
                            style: AppTextStyles.fs16w500,
                          ),
                          Text(
                            widget.ticketsDTO.returndate ?? 'ERROR',
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
                            widget.ticketsDTO.manager ?? 'ERROR',
                            style: AppTextStyles.fs18w600.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          Text(
                            context.localized.guarantee,
                            style: AppTextStyles.fs16w500,
                          ),
                          Text(
                            widget.ticketsDTO.garantdate ?? 'ERROR',
                            style: AppTextStyles.fs18w600.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          Text(
                            context.localized.paymentPeriod,
                            style: AppTextStyles.fs16w500,
                          ),
                          Text(
                            widget.ticketsDTO.paydays ?? 'ERROR',
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
                          widget.ticketsDTO.paydays ?? 'ERROR',
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
                  Text(
                    context.localized.deposit,
                    style: AppTextStyles.fs16w500,
                  ),
                  const Gap(50),
                  Text(
                    context.localized.photo,
                    style: AppTextStyles.fs18w600.copyWith(color: AppColors.black),
                  ),
                ],
              ),
              const Gap(22),
              if (widget.ticketsDTO.pledges != null)
                Column(
                  children: [
                    ...widget.ticketsDTO.pledges!.map(
                      (pledge) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${pledge.itemcount} x ${pledge.itemname}', // например: 1 x Кольцо
                            style: AppTextStyles.fs16w400.copyWith(color: AppColors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              const Gap(19.5),
              const Divider(
                color: Color(0xFF9E9D9D),
              ),
              const Gap(19),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.localized.totalBoBePaid,
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    '${widget.ticketsDTO.totalrefundamount}  ₸',
                    style: AppTextStyles.fs18w600,
                  ),
                ],
              ),
              const Gap(6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.localized.paidOut,
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    '${widget.ticketsDTO.totalpaidamount}  ₸',
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
                      onPressed: () {
                        context.router
                            .push(PaymentInformationRoute(ticketsDTO: widget.ticketsDTO, paymentType: 'Пролонгация'));
                      },
                      style: CustomButtonStyles.mainButtonStyle(
                        context,
                      ),
                      child: Text(
                        context.localized.prolongation,
                        style: AppTextStyles.fs16w600,
                      ),
                    ),
                  ),
                  const Gap(17),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        context.router
                            .push(PaymentInformationRoute(ticketsDTO: widget.ticketsDTO, paymentType: 'Выкуп'));
                      },
                      style: CustomButtonStyles.mainButtonStyle(
                        context,
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(),
                      ),
                      child: Text(
                        context.localized.theRansom,
                        style: AppTextStyles.fs16w600.copyWith(color: AppColors.black),
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
