import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/scroll/scroll_wrapper.dart';
import 'package:lombard/src/core/presentation/widgets/textfields/custom_validator_textfield.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/auth/bloc/new_password_cubit.dart';

@RoutePage()
class NewPasswordPage extends StatefulWidget implements AutoRouteWrapper {
  const NewPasswordPage({
    super.key,
    required this.email,
  });
  final String email;

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => NewPasswordCubit(repository: context.repository.authRepository),
      child: this,
    );
  }
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordRepeatController = TextEditingController();
  final ValueNotifier<String?> _passwordError = ValueNotifier(null);
  final ValueNotifier<String?> _passwordRepeatError = ValueNotifier(null);
  final ValueNotifier<bool> _obscureText = ValueNotifier(true);
  final ValueNotifier<bool> _allowTapButton = ValueNotifier(false);

  @override
  void dispose() {
    passwordController.dispose();
    passwordRepeatController.dispose();
    _obscureText.dispose();
    _passwordError.dispose();
    _passwordRepeatError.dispose();
    _allowTapButton.dispose();
    super.dispose();
  }

  void checkAllowTapButton() {
    _allowTapButton.value = passwordController.text.isNotEmpty &&
        passwordRepeatController.text.isNotEmpty &&
        passwordController.text == passwordRepeatController.text;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: AppColors.barrierColor,
      overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: BlocConsumer<NewPasswordCubit, NewPasswordState>(
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
                BlocProvider.of<AppBloc>(context).add(const AppEvent.logining());
                context.router.replaceAll([const LauncherRoute()]);
                Toaster.showTopShortToast(context, message: 'Успешно');
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
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ScrollWrapper(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(20),
                          const Text.rich(
                            TextSpan(
                              text: 'Придумайте новый пароль',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                                height: 35.8 / 30,
                                color: AppColors.text,
                              ),
                            ),
                          ),
                          const Gap(30),
                          const Text(
                            'Пароль',
                            style: AppTextStyles.fs14w400,
                          ),
                          const Gap(12),
                          ValueListenableBuilder(
                            valueListenable: _obscureText,
                            builder: (context, v, c) {
                              return CustomValidatorTextfield(
                                obscureText: _obscureText,
                                controller: passwordController,
                                valueListenable: _passwordError,
                                hintText: 'Введите новый пароль',
                                onChanged: (value) {
                                  checkAllowTapButton();
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return _passwordError.value = 'Обязательно к заполнению';
                                  }

                                  if (value.length < 6) {
                                    return _passwordError.value = 'Минимальная длина пароля - 6';
                                  }

                                  return _passwordError.value = null;
                                },
                              );
                            },
                          ),
                          const Gap(16),
                          const Text(
                            'Повторите пароль',
                            style: AppTextStyles.fs14w400,
                          ),
                          const Gap(12),
                          ValueListenableBuilder(
                            valueListenable: _obscureText,
                            builder: (context, v, c) {
                              return CustomValidatorTextfield(
                                obscureText: _obscureText,
                                controller: passwordRepeatController,
                                valueListenable: _passwordRepeatError,
                                hintText: 'Повторите пароль',
                                onChanged: (value) {
                                  checkAllowTapButton();
                                },
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return _passwordRepeatError.value = 'Обязательно к заполнению';
                                  }

                                  if (value.length < 6) {
                                    return _passwordRepeatError.value = 'Минимальная длина пароля - 6';
                                  }

                                  if (value != passwordController.text) {
                                    return _passwordRepeatError.value = 'Пароли не совпадают';
                                  }
                                  return _passwordRepeatError.value = null;
                                },
                              );
                            },
                          ),
                          const Gap(34),
                          CustomButton(
                            allowTapButton: _allowTapButton,
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              context.router.replaceAll([const LauncherRoute()]);
                              if (_formKey.currentState!.validate()) {}
                              BlocProvider.of<NewPasswordCubit>(context).forgotPasswordChangePassword(
                                email: widget.email,
                                password: passwordController.text,
                              );
                            },
                            style: null,
                            text: 'Изменить',
                            child: null,
                          ),
                          const Gap(16),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
