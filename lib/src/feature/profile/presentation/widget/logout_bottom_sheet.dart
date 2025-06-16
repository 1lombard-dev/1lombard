import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/profile/bloc/logout_cubit.dart';

class LogoutBottomSheet extends StatefulWidget {
  final BuildContext parentContext;
  const LogoutBottomSheet({
    super.key,
    required this.parentContext,
  });

  @override
  State<LogoutBottomSheet> createState() => _CustomAlertState();
}

class _CustomAlertState extends State<LogoutBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundInput,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: BlocListener<LogoutCubit, LogoutState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              Toaster.showErrorTopShortToast(context, message);
            },
            loaded: () {
              BlocProvider.of<AppBloc>(context).add(const AppEvent.exiting());
              widget.parentContext.router.replaceAll([
                const LauncherRoute(),
              ]);
            },
            orElse: () {},
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 14, top: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppColors.backgroundInput,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Gap(8),
              Text(
                context.localized.logOutApp,
                style: AppTextStyles.fs20w700,
                textAlign: TextAlign.center,
              ),
              const Gap(6),
              Text(
                context.localized.areYouSureYou,
                style: AppTextStyles.fs14w600.copyWith(color: AppColors.grayText),
                textAlign: TextAlign.center,
              ),
              const Gap(22),
              Semantics(
                excludeSemantics: true,
                explicitChildNodes: true,
                label: 'logout_button',
                child: CustomButton(
                  onPressed: () {
                    BlocProvider.of<LogoutCubit>(context).logout();
                  },
                  style: CustomButtonStyles.mainButtonStyle(context),
                  child: Text(
                    context.localized.exit,
                    style: AppTextStyles.fs16w600,
                  ),
                ),
              ),
              const Gap(12),
              Semantics(
                excludeSemantics: true,
                explicitChildNodes: true,
                label: 'close_button',
                child: CustomButton(
                  onPressed: () {
                    widget.parentContext.router.maybePop();
                  },
                  style: CustomButtonStyles.mainButtonStyle(context, backgroundColor: AppColors.grey),
                  child: Text(
                    context.localized.cancel,
                    style: AppTextStyles.fs16w600.copyWith(color: AppColors.grayText),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
