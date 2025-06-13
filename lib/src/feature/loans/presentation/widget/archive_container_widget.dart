import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/loans/model/tickets_dto.dart';

class ArchiveContainerWidget extends StatelessWidget {
  final TicketsDTO ticketsDTO;
  const ArchiveContainerWidget({
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
                    const Text(
                      'Дата открытия:',
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
                    const Text(
                      'Дата возврата:',
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
                    const Text(
                      'Гарантия: ',
                      style: AppTextStyles.fs16w400,
                    ),
                    Text(
                      ticketsDTO.garantdate ?? 'ERROR',
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
