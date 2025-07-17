import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/loans/bloc/get_payment_cubit.dart';
import 'package:lombard/src/feature/loans/model/tickets_dto.dart';

@RoutePage()
class PaymentInformationPage extends StatefulWidget implements AutoRouteWrapper {
  final TicketsDTO ticketsDTO;
  final String paymentType;
  const PaymentInformationPage({super.key, required this.ticketsDTO, required this.paymentType});

  @override
  _PaymentInformationPageState createState() => _PaymentInformationPageState();

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

class _PaymentInformationPageState extends State<PaymentInformationPage> {
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.backgroundInput,
        appBar: AppBar(
          title: Text(
            context.localized.payment,
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
                context.localized.paymentInformation,
                style: AppTextStyles.fs20w600.copyWith(color: AppColors.red),
              ),
              const Gap(30),
              Row(
                children: [
                  Text(
                    context.localized.orderNumber,
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    widget.ticketsDTO.ticketnumber ?? 'ERROR',
                    style: AppTextStyles.fs16w600.copyWith(color: AppColors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Gap(15),
              Row(
                children: [
                  Text(
                    context.localized.typeOfPayment,
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    widget.paymentType,
                    style: AppTextStyles.fs16w600.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              const Gap(15),
              Row(
                children: [
                  Text(
                    context.localized.securityTicketNumber,
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    widget.ticketsDTO.ticketnumber ?? 'ERROR',
                    style: AppTextStyles.fs16w600.copyWith(
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
              const Gap(15),
              Row(
                children: [
                  Text(
                    context.localized.amountToBePaid,
                    style: AppTextStyles.fs16w500,
                  ),
                  Text(
                    '${widget.ticketsDTO.totalrefundamount} тг.',
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
              Text(
                context.localized.ifEverythingIsCorrect,
                style: AppTextStyles.fs16w500,
              ),
              const Gap(19.5),
              const Divider(
                color: Color(0xFF9E9D9D),
              ),
              const Gap(39),
              BlocListener<GetPaymentCubit, GetPaymentState>(
                listener: (context, state) {
                  state.maybeWhen(
                    // ignore: void_checks
                    orElse: () {
                      return const CustomLoadingOverlayWidget();
                    },
                    // c070c49a-c3d6-4cee-a30e-9fe23eb5351f
                    loaded: (tickets) {
                      if (tickets.status == 'error') {
                        return Toaster.showErrorTopShortToast(
                          context,
                          context.localized.thisTypeOfOperation,
                        );
                      }

                      context.router
                          .push(DetailPaymentRoute(paymentUrl: tickets.paylink ?? 'ERROR', successPaymentUrl: ''));
                    },
                  );
                },
                child: CustomButton(
                  height: 60,
                  onPressed: () {
                    BlocProvider.of<GetPaymentCubit>(context).getPayment(
                      paymentType: widget.paymentType == 'Пролонгация' ? '1' : '2',
                      ticketnum: widget.ticketsDTO.ticketnumber ?? 'ERROR',
                      ticketdate: widget.ticketsDTO.issuedate ?? "ERROR",
                    );
                  },
                  style: CustomButtonStyles.mainButtonStyle(context),
                  child: Text(
                    context.localized.toPay,
                    style: AppTextStyles.fs18w600,
                  ),
                ),
              ),
              const Gap(21),
            ],
          ),
        ),
      );
}
