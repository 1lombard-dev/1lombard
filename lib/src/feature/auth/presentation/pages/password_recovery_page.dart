import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/scroll_wrapper.dart';
import 'package:lombard/src/core/presentation/widgets/textfields/custom_validator_textfield.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/core/utils/input/validator_util.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/auth/bloc/password_recovery_cubit.dart';
import 'package:lombard/src/feature/auth/enum/enter_sms_code_type.dart';

@RoutePage()
class PasswordRecoveryPage extends StatefulWidget implements AutoRouteWrapper {
  const PasswordRecoveryPage({super.key});

  @override
  _PasswordRecoveryPageState createState() => _PasswordRecoveryPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordRecoveryCubit(repository: context.repository.authRepository),
      child: this,
    );
  }
}

class _PasswordRecoveryPageState extends State<PasswordRecoveryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final ValueNotifier<String?> _emailError = ValueNotifier(null);
  final MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(mask: '+7(###) ###-##-##');
  final ValueNotifier<bool> _allowTapButton = ValueNotifier(false);

  @override
  void dispose() {
    emailController.dispose();
    _emailError.dispose();
    _allowTapButton.dispose();

    super.dispose();
  }

  bool isValidEmail(String value) {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void checkAllowTapButton() {
    _allowTapButton.value = isValidEmail(emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: AppColors.barrierColor,
      overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
      child: BlocConsumer<PasswordRecoveryCubit, PasswordRecoveryState>(
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              context.loaderOverlay.hide();
              Toaster.showErrorTopShortToast(context, message);
            },
            loading: () {
              context.loaderOverlay.show();
            },
            loaded: () {
              context.loaderOverlay.hide();
              context.pushRoute(
                EnterSmsCodeRoute(
                  email: emailController.text,
                  flowType: EnterSmsCodeType.forgotPassword,
                  smsDelay: 60,
                ),
              );
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
            //     label: SvgPicture.asset(
            //       Assets.icons.backArrow.path,
            //       height: 25,
            //     ),
            //   ),
            // ),
            body: SafeArea(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ScrollWrapper(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(20),
                        const Text(
                          'Забыли пароль?',
                          style: AppTextStyles.fs30w600,
                        ),
                        const Gap(30),
                        const Text(
                          'Email',
                          style: AppTextStyles.fs14w400,
                        ),
                        const Gap(12),
                        CustomValidatorTextfield(
                          controller: emailController,
                          valueListenable: _emailError,
                          hintText: 'Введите почту',
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            checkAllowTapButton();
                          },
                          validator: (String? value) {
                            return _emailError.value = ValidatorUtil.emailValidator(
                              emailController.text,
                            );
                          },
                        ),
                        const Gap(38),
                        CustomButton(
                          allowTapButton: _allowTapButton,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<PasswordRecoveryCubit>(context).forgotPasswordSmsSend(
                                phone: emailController.text,
                              );
                            }
                          },
                          style: null,
                          text: 'Далее',
                          child: null,
                        ),
                      ],
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
