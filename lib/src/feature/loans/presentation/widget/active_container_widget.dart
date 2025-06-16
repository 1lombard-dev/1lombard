import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/loans/model/tickets_dto.dart';

class ActiveContainerWidget extends StatelessWidget {
  final TicketsDTO ticketsDTO;
  const ActiveContainerWidget({
    super.key,
    required this.ticketsDTO,
  });

  @override
  Widget build(BuildContext context) {
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
            context.router.push(LoansDetailRoute(ticketsDTO: ticketsDTO));
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticketsDTO.ticketnumber ?? 'ERROR',
                  style: AppTextStyles.fs14w600.copyWith(color: AppColors.red, fontWeight: FontWeight.bold),
                ),
                const Gap(13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.localized.openingDate,
                      style: AppTextStyles.fs16w400,
                    ),
                    Text(
                      ticketsDTO.issuedate ?? 'ERROR',
                      style: AppTextStyles.fs14w600,
                    ),
                  ],
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.localized.returnDate,
                      style: AppTextStyles.fs16w400,
                    ),
                    Text(
                      ticketsDTO.returndate ?? 'ERROR',
                      style: AppTextStyles.fs14w600,
                    ),
                  ],
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Менеджер:',
                      style: AppTextStyles.fs16w400,
                    ),
                    Text(
                      ticketsDTO.manager ?? 'ERROR',
                      style: AppTextStyles.fs14w600,
                    ),
                  ],
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.localized.guarantee,
                      style: AppTextStyles.fs16w400,
                    ),
                    Text(
                      ticketsDTO.garantdate ?? 'ERROR',
                      style: AppTextStyles.fs14w600,
                    ),
                  ],
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.localized.paymentPeriod,
                      style: AppTextStyles.fs16w400,
                    ),
                    Text(
                      ticketsDTO.paydays ?? 'ERROR',
                      style: AppTextStyles.fs14w600,
                    ),
                  ],
                ),
                const Gap(15),
                const Divider(),
                const Gap(10),
                Text(
                  context.localized.deposit,
                  style: AppTextStyles.fs16w400,
                ),
                const Gap(10),
                if (ticketsDTO.pledges != null)
                  Column(
                    children: [
                      ...ticketsDTO.pledges!.map(
                        (pledge) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${pledge.itemcount} x ${pledge.itemname}', // например: 1 x Кольцо
                              style: AppTextStyles.fs16w400.copyWith(color: AppColors.black),
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Статус: ',
                                  style: AppTextStyles.fs16w600,
                                ),
                                Text(
                                  ticketsDTO.status ?? 'ERROR',
                                  style: AppTextStyles.fs16w600.copyWith(color: AppColors.green2),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const Gap(25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Выплачено:\n${ticketsDTO.totalpaidamount} ₸',
                      style: AppTextStyles.fs16w400,
                    ),
                    Text(
                      'Всего к выплате: \n${ticketsDTO.totalrefundamount} ₸',
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
                        onPressed: () {
                          context.router
                              .push(PaymentInformationRoute(ticketsDTO: ticketsDTO, paymentType: 'Пролонгация'));
                        },
                        style: CustomButtonStyles.mainButtonStyle(context),
                        child: Text(
                          context.localized.prolongation,
                          style: AppTextStyles.fs18w600,
                        ),
                      ),
                    ),
                    const Gap(17),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          context.router.push(PaymentInformationRoute(ticketsDTO: ticketsDTO, paymentType: 'Выкуп'));
                        },
                        style: CustomButtonStyles.mainButtonStyle(
                          context,
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(),
                        ),
                        child: Text(
                          context.localized.theRansom,
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
  }
}
