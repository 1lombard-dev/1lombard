import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/scroll_wrapper.dart';
import 'package:lombard/src/core/presentation/widgets/textfields/custom_textfield.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/app/presentation/widgets/custom_appbar_widget.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/auth/bloc/auth_cubit.dart';
import 'package:lombard/src/feature/auth/bloc/login_cubit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@RoutePage()
class LoginPage extends StatefulWidget implements AutoRouteWrapper {
  final String phoneNum;
  final bool isHaveAccount;
  const LoginPage({super.key, required this.phoneNum, required this.isHaveAccount});

  @override
  _LoginPageState createState() => _LoginPageState();
  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(repository: context.repository.authRepository),
          child: this,
        ),
        BlocProvider(
          create: (context) => AuthCubit(repository: context.repository.authRepository),
          child: this,
        ),
      ],
      child: this,
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<String?> _phoneError = ValueNotifier(null);
  final ValueNotifier<String?> _passwordError = ValueNotifier(null);

  MaskTextInputFormatter maskPhoneFormatter = MaskTextInputFormatter(
    mask: '+7(###) ###-##-##',
    filter: {"#": RegExp('[0-9]')},
  );

  final ValueNotifier<bool> _obscureText = ValueNotifier(true);
  final ValueNotifier<bool> _allowTapButton = ValueNotifier(false);

  bool sendAgain = true;
  int start = 59;

  @override
  void initState() {
    if (widget.isHaveAccount == false) {
      sendAgain = true;
      startTimer();
    } else {
      sendAgain = false;
    }

    maskPhoneFormatter = MaskTextInputFormatter(
      mask: '+7(###) ###-##-##',
      filter: {"#": RegExp('[0-9]')},
      initialText: widget.phoneNum,
    );
    phoneController.text = MaskTextInputFormatter(
      mask: '+7(###) ###-##-##',
      filter: {"#": RegExp('[0-9]')},
      initialText: widget.phoneNum,
    ).getMaskedText();
    super.initState();
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    _obscureText.dispose();
    _passwordError.dispose();
    _phoneError.dispose();
    _allowTapButton.dispose();
    super.dispose();
  }

  void checkAllowTapButton() {
    final isPhoneValid = passwordController.text != '';

    _allowTapButton.value = isPhoneValid;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: AppColors.barrierColor,
      overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          state.maybeWhen(
            loading: () => context.loaderOverlay.show(),
            error: (message, sendedOldValue, authErrorResponse) {
              context.loaderOverlay.hide();
              Toaster.showErrorTopShortToast(context, message);
              Future<void>.delayed(
                const Duration(milliseconds: 300),
              ).whenComplete(
                () => _formKey.currentState!.validate(),
              );
            },
            loaded: (response) {
              context.loaderOverlay.hide();
              BlocProvider.of<AppBloc>(context).add(const AppEvent.logining());
              context.router.replaceAll([const LauncherRoute()]);
              Toaster.showTopShortToast(context, message: 'Сәтті кірдіңіз!');
            },
            orElse: () => context.loaderOverlay.hide(),
          );
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: const CustomAppBar(),
              body: SafeArea(
                child: Form(
                  key: _formKey,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ScrollWrapper(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Gap(37.5),
                              // SvgPicture.asset(
                              //   Assets.images.logoName.path,
                              // ),
                              const Gap(30.5),
                              Container(
                                height: 0.5,
                                width: double.infinity,
                                color: AppColors.muteBlue,
                              ),
                              const Gap(30.5),
                              const Text(
                                'Кабинетке кіру/тіркелу',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 26,
                                  height: 1.3,
                                ),
                              ),
                              const Gap(20),
                              Text(
                                'Телефон номер',
                                style: AppTextStyles.fs14w400.copyWith(height: 1.6),
                              ),
                              const Gap(12),
                              CustomTextField(
                                readOnly: true,
                                controller: phoneController,
                                inputFormatters: [maskPhoneFormatter],
                                hintText: '+7 (7--) --- -- --',
                                keyboardType: TextInputType.phone,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                textStyle: AppTextStyles.fs16w400.copyWith(letterSpacing: 0.4),
                                // onChanged: (value) {
                                //   checkAllowTapButton();
                                // },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12, top: 10),
                                child: Text(
                                  'Құпиясөз',
                                  style: AppTextStyles.fs14w400.copyWith(height: 1.6),
                                ),
                              ),
                              CustomTextField(
                                controller: passwordController,
                                hintText: 'Құпиясөзді енгізіңіз',
                                keyboardType: TextInputType.text,
                                textStyle: AppTextStyles.fs16w400.copyWith(letterSpacing: 0.4),
                                onChanged: (value) {
                                  checkAllowTapButton();
                                },
                              ),
                              const Gap(24),
                              CustomButton(
                                allowTapButton: _allowTapButton,
                                onPressed: () {
                                  log('7${maskPhoneFormatter.getUnmaskedText()}');
                                  log(passwordController.text);
                                  log('${Platform.isAndroid}');
                                  BlocProvider.of<LoginCubit>(context).login(
                                    phone: '7${maskPhoneFormatter.getUnmaskedText()}',
                                    password: passwordController.text,
                                    deviceType: Platform.isAndroid ? 'Android' : 'IOS',
                                  );
                                },
                                style: CustomButtonStyles.mainButtonStyle(context),
                                child: const Text(
                                  'Кіру',
                                  style: AppTextStyles.fs16w600,
                                ),
                              ),
                              if (sendAgain)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 14, right: 14, top: 23),
                                    child: Text(
                                      'Сіздің номеріңізге құпиясөз жіберілді',
                                      style: AppTextStyles.fs18w600,
                                    ),
                                  ),
                                ),
                              const Gap(12),
                              // ValueListenableBuilder(
                              //   valueListenable: timerSeconds,
                              //   builder: (context, v, c) {
                              //     if (timerSeconds.value == 0) {
                              //       return Center(
                              //         child: Text.rich(
                              //           TextSpan(
                              //             text: 'Не получили код? ',
                              //             style: AppTextStyles.fs14w500.copyWith(fontWeight: FontWeight.w400),
                              //             children: [
                              //               TextSpan(
                              //                 text: 'Получить еще раз',
                              //                 recognizer: TapGestureRecognizer()
                              //                   ..onTap = () {
                              //                     // BlocProvider.of<PasswordRecoveryCubit>(context).forgotPasswordSmsSend(
                              //                     //   phone: widget.email,
                              //                     // );
                              //                   },
                              //                 style: AppTextStyles.fs14w500.copyWith(
                              //                   color: AppColors.mainColor,
                              //                   fontWeight: FontWeight.w500,
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       );
                              //     }
                              //     return Text.rich(
                              //       TextSpan(
                              //         text: ' ${timerSeconds.value.formattedTime()} сек',
                              //         style: AppTextStyles.fs14w500.copyWith(color: AppColors.mainColor),
                              //       ),
                              //     );
                              //   },
                              // ),
                              if (sendAgain)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 32.5),
                                    child: Text(
                                      'SMS-ті 00:$start секундттан кейін қайта жібере аласыз',
                                      style: AppTextStyles.fs14w400.copyWith(letterSpacing: 0.1),
                                      textAlign: TextAlign.center,
                                    ),
                                    // child: Text.rich(
                                    //   TextSpan(
                                    //     text: ' ${timerSeconds.value.formattedTime()} сек',
                                    //     style: AppTextStyles.fs14w500.copyWith(color: AppColors.mainColor),
                                    //   ),
                                    // ),
                                  ),
                                )
                              else
                                BlocListener<AuthCubit, AuthState>(
                                  listener: (context, state) {
                                    state.maybeWhen(
                                      loading: () => context.loaderOverlay.show(),
                                      orElse: () {
                                        context.loaderOverlay.hide();
                                      },
                                      error: (message) {
                                        context.loaderOverlay.hide();
                                        Toaster.showErrorTopShortToast(context, message);
                                      },
                                      loaded: (message) {
                                        context.loaderOverlay.hide();
                                        setState(() {
                                          sendAgain = true;
                                          start = 59;
                                        });
                                        startTimer();
                                        Toaster.showTopShortToast(context, message: message.message ?? '');
                                      },
                                    );
                                  },
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<AuthCubit>(context).sendForgetPassword(phone: widget.phoneNum);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 45),
                                        child: Text(
                                          'SMS арқылы құпия сөзді еске салу',
                                          style: AppTextStyles.fs18w600.copyWith(color: AppColors.mainBlueColor),
                                          textAlign: TextAlign.center,
                                        ),
                                        // child: Text.rich(
                                        //   TextSpan(
                                        //     text: ' ${timerSeconds.value.formattedTime()} сек',
                                        //     style: AppTextStyles.fs14w500.copyWith(color: AppColors.mainColor),
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14, right: 14, bottom: 34),
                            child: Text(
                              '«Ustaz tilegi» орталығының аттестацияға дайындық приложениесі',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.fs16w500.copyWith(
                                color: AppColors.grayText,
                                fontStyle: FontStyle.italic,
                                // fontFamily: 'Inter',
                                letterSpacing: -0.32,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void startTimer() {
    const onsec = Duration(seconds: 1);
    // ignore: prefer_final_locals, unused_local_variable
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          sendAgain = false;
        });
      } else if (mounted) {
        super.setState(() {
          start--;
          sendAgain = true;
        });
      }
    });
  }
}
