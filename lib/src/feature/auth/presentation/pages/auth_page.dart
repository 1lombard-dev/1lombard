import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/scroll_wrapper.dart';
import 'package:lombard/src/core/presentation/widgets/textfields/custom_textfield.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/presentation/widgets/custom_appbar_widget.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/auth/bloc/auth_cubit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@RoutePage()
class AuthPage extends StatefulWidget implements AutoRouteWrapper {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(repository: context.repository.authRepository),
      child: this,
    );
  }
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final ValueNotifier<String?> _phoneError = ValueNotifier(null);

  MaskTextInputFormatter maskPhoneFormatter = MaskTextInputFormatter(
    mask: '+7(###) ###-##-##',
    filter: {"#": RegExp('[0-9]')},
  );

  final ValueNotifier<bool> _obscureText = ValueNotifier(true);
  final ValueNotifier<bool> _allowTapButton = ValueNotifier(false);

  bool isPhoneValid = false;
  bool isKZnumber = true;

  @override
  void dispose() {
    phoneController.dispose();
    _obscureText.dispose();
    _phoneError.dispose();
    _allowTapButton.dispose();
    super.dispose();
  }

  void checkAllowTapButton() {
    final isPhoneValid = phoneController.text.length == 17;

    _allowTapButton.value = isPhoneValid;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: AppColors.barrierColor,
      overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            loading: () {
              // Toaster.showLoadingTopShortToast(context, message: 'Құпиясөз жіберілді');
            },
            error: (message) {
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
              response.exists == false
                  ? _getSmsAlertDialog(
                      context,
                      phoneNumber: maskPhoneFormatter.getMaskedText(),
                      onTap: () {
                        context.router
                            .push(
                          LoginRoute(
                            phoneNum: maskPhoneFormatter.getUnmaskedText(),
                            isHaveAccount: response.exists ?? false,
                          ),
                        )
                            .whenComplete(() {
                          if (context.mounted) context.router.maybePop();
                        });
                      },
                    )
                  : context.router
                      .push(
                      LoginRoute(
                        phoneNum: maskPhoneFormatter.getUnmaskedText(),
                        isHaveAccount: response.exists ?? false,
                      ),
                    )
                      .whenComplete(() {
                      if (context.mounted) context.router.maybePop();
                    });
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
                                controller: phoneController,
                                inputFormatters: [maskPhoneFormatter],
                                hintText: '+7 (7--) --- -- --',
                                keyboardType: TextInputType.phone,
                                textStyle: AppTextStyles.fs16w400.copyWith(letterSpacing: 0.4),
                                onChanged: (value) {
                                  checkAllowTapButton();
                                  setState(() {});
                                },
                              ),
                              if (isKZnumber == false)
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    'Қазақстандық номер ғана тіркеле алады',
                                    style: AppTextStyles.fs14w500.copyWith(color: AppColors.red2, letterSpacing: 0.05),
                                  ),
                                ),
                              const Gap(24),
                              CustomButton(
                                allowTapButton: _allowTapButton,
                                onPressed: () {
                                  log('+7${maskPhoneFormatter.getUnmaskedText()}');
                                  if (isValidKazakhstanPhoneNumber('+7${maskPhoneFormatter.getUnmaskedText()}')) {
                                    BlocProvider.of<AuthCubit>(context)
                                        .authenticate(phone: '7${maskPhoneFormatter.getUnmaskedText()}');
                                  } else {
                                    isKZnumber = false;
                                    setState(() {});
                                  }
                                },
                                style: CustomButtonStyles.mainButtonStyle(context),
                                child: const Text(
                                  'Жалғастыру',
                                  style: AppTextStyles.fs16w600,
                                ),
                              ),
                              const Gap(12),
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
}

bool isValidKazakhstanPhoneNumber(String phoneNumber) {
  // Регулярное выражение для проверки казахстанских номеров
  final regex = RegExp(r'^\+7(700|701|702|705|706|707|708|771|747|775|776|777|778)\d{7}$');

  // Возвращает true, если номер соответствует формату
  return regex.hasMatch(phoneNumber);
}

void _getSmsAlertDialog(
  BuildContext context, {
  Function()? onTap,
  String? phoneNumber,
}) {
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      content: Column(
        children: [
          Text(
            '$phoneNumber',
            style: AppTextStyles.fs16w600,
          ),
          const Gap(2),
          Text(
            'Сіздің номеріңізге құпия сөз СМС арқылы жіберілді',
            style: AppTextStyles.fs12w400.copyWith(color: Colors.black),
          ),
        ],
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: onTap,
          child: Text(
            'Түсінікті',
            style: AppTextStyles.fs16w600.copyWith(color: AppColors.mainBlueColor),
          ),
        ),
      ],
    ),
  );
}
