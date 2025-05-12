import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pinput/pinput.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/scroll_wrapper.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/core/utils/extensions/integer_extension.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/auth/bloc/enter_sms_code_cubit.dart';
import 'package:lombard/src/feature/auth/bloc/password_recovery_cubit.dart';
import 'package:lombard/src/feature/auth/enum/enter_sms_code_type.dart';
import 'package:lombard/src/feature/auth/models/request/user_payload.dart';

@RoutePage()
class EnterSmsCodePage extends StatefulWidget implements AutoRouteWrapper {
  const EnterSmsCodePage({
    super.key,
    required this.email,
    required this.flowType,
    required this.smsDelay,
    this.userPayload,
  });
  final String email;
  final EnterSmsCodeType flowType;
  final int smsDelay;
  final UserPayload? userPayload; // for resend register sms code

  @override
  _EnterSmsCodePageState createState() => _EnterSmsCodePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EnterSmsCodeCubit(
            repository: context.repository.authRepository,
          ),
        ),
        BlocProvider(
          create: (context) => PasswordRecoveryCubit(
            repository: context.repository.authRepository,
          ),
        ),
      ],
      child: this,
    );
  }
}

class _EnterSmsCodePageState extends State<EnterSmsCodePage> {
  final Duration oneSec = const Duration(seconds: 1); // Set to 1 second for countdown
  final MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(mask: '+#(###) ###-##-##');
  final ValueNotifier<bool> _allowTapButton = ValueNotifier(false);
  final TextEditingController pinputController = TextEditingController();
  late final ValueNotifier<int> timerSeconds;
  late Timer timer;
  final ValueNotifier<bool> forceErrorState = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    timerSeconds = ValueNotifier(widget.smsDelay);
    pinputController.addListener(checkAllowTapButton);
    startTimer();
  }

  final defaultPinTheme = PinTheme(
    width: double.infinity,
    // height: 55,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      color: AppColors.backgroundInputGrey,
      border: Border.all(color: AppColors.line2),
    ),
    textStyle: const TextStyle(
      color: AppColors.text,
      fontWeight: FontWeight.w600,
      fontSize: 28,
      height: 39.2 / 28,
    ),
  );

  final errorPinTheme = PinTheme(
    width: double.infinity,
    // height: 55,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      color: AppColors.muteRed,
      border: Border.all(color: AppColors.red),
    ),
    textStyle: const TextStyle(
      color: AppColors.text,
      fontWeight: FontWeight.w600,
      fontSize: 28,
      height: 39.2 / 28,
    ),
  );
  void startTimer() {
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!context.mounted) {
          timer.cancel();
          return;
        }

        // Decrement `timerSeconds` every second until it reaches 0
        if (timerSeconds.value == 0) {
          timer.cancel();
        } else {
          setState(() {
            timerSeconds.value--;
          });
        }
      },
    );
  }

  void checkAllowTapButton() {
    // Check if pinputController has enough characters to enable button
    forceErrorState.value = false;
    _allowTapButton.value = pinputController.text.length == 4;
  }

  @override
  void dispose() {
    _allowTapButton.dispose();
    timer.cancel();
    timerSeconds.dispose();
    pinputController.removeListener(checkAllowTapButton);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: AppColors.barrierColor,
      overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
      child: BlocConsumer<EnterSmsCodeCubit, EnterSmsCodeState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              context.loaderOverlay.hide();
              Toaster.showErrorTopShortToast(context, message);
              forceErrorState.value = true;
            },
            loading: () {
              context.loaderOverlay.show();
            },
            forgotPasswordState: () {
              context.loaderOverlay.hide();

              context.router.push(
                NewPasswordRoute(email: widget.email),
              );
            },
            registerLoaded: (user) {
              context.loaderOverlay.hide();

              BlocProvider.of<AppBloc>(context).add(const AppEvent.logining());

              context.router.replaceAll([const LauncherRoute()]);
            },
            resendForgotPasswordSmsState: (smsDelay) {
              context.loaderOverlay.hide();

              timerSeconds.value = smsDelay;
              startTimer();
            },
            resendRegisterSmsState: (smsDelay) {
              context.loaderOverlay.hide();

              timerSeconds.value = smsDelay;
              startTimer();
            },
            orElse: () {
              context.loaderOverlay.hide();
            },
          );
        },
        builder: (context, state) {
          return Scaffold(
            // appBar: AppBar(
            //   leading: TextButton.icon(
            //     onPressed: () {
            //       context.router.maybePop();
            //     },
            //     label: SvgPicture.asset(Assets.icons.backArrow.path),
            //   ),
            // ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ScrollWrapper(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(30),
                      const Text(
                        'Введите код из почты',
                        textAlign: TextAlign.start,
                        style: AppTextStyles.fs30w600,
                      ),
                      const Gap(12),
                      Text(
                        'Мы отправили код для подтверждения на ваш электронный адрес: ${widget.email}',
                        textAlign: TextAlign.start,
                        style: AppTextStyles.fs14w400.copyWith(color: const Color(0x80000000)),
                      ),
                      const Gap(26),
                      Center(
                        child: ValueListenableBuilder(
                          valueListenable: forceErrorState,
                          builder: (context, v, c) {
                            return Pinput(
                              autofocus: true,
                              controller: pinputController,
                              forceErrorState: forceErrorState.value,
                              separatorBuilder: (index) => const SizedBox(width: 16),
                              onChanged: (value) {
                                checkAllowTapButton();
                              },
                              closeKeyboardWhenCompleted: false,
                              preFilledWidget: const Text(
                                '0',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 28,
                                  color: AppColors.greyText,
                                  height: 39.2 / 28,
                                ),
                              ),
                              // androidSmsAutofillMethod: ,
                              defaultPinTheme: defaultPinTheme,
                              // submittedPinTheme: defaultPinTheme,
                              // focusedPinTheme: defaultPinTheme,
                              // followingPinTheme: defaultPinTheme,
                              errorPinTheme: errorPinTheme,
                            );
                          },
                        ),
                      ),
                      const Gap(26),
                      BlocListener<PasswordRecoveryCubit, PasswordRecoveryState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            orElse: () {},
                            loaded: () {
                              timer.cancel();
                              // Reset `timerSeconds` with the new delay
                              timerSeconds.value = widget.smsDelay;
                              startTimer();
                            },
                          );
                        },
                        child: Center(
                          child: ValueListenableBuilder(
                            valueListenable: timerSeconds,
                            builder: (context, v, c) {
                              if (timerSeconds.value == 0) {
                                return Center(
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'Не получили код? ',
                                      style: AppTextStyles.fs14w500.copyWith(fontWeight: FontWeight.w400),
                                      children: [
                                        TextSpan(
                                          text: 'Получить еще раз',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              BlocProvider.of<PasswordRecoveryCubit>(context).forgotPasswordSmsSend(
                                                phone: widget.email,
                                              );
                                            },
                                          style: AppTextStyles.fs14w500.copyWith(
                                            color: AppColors.mainColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Text.rich(
                                TextSpan(
                                  text: ' ${timerSeconds.value.formattedTime()} сек',
                                  style: AppTextStyles.fs14w500.copyWith(color: AppColors.mainColor),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Gap(38),
                      CustomButton(
                        allowTapButton: _allowTapButton,
                        onPressed: () {
                          // ignore: unnecessary_statements
                          pinputController.text.length == 4;
                          {
                            BlocProvider.of<EnterSmsCodeCubit>(context).forgotPasswordSmsCheck(
                              phone: widget.email,
                              code: pinputController.text,
                            );
                          }
                        },
                        style: null,
                        text: 'Отправить',
                        child: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
