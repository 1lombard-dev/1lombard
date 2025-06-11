import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/auth/bloc/login_cubit.dart';

@RoutePage()
class AuthPage extends StatefulWidget implements AutoRouteWrapper {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(repository: context.repository.authRepository),
      child: this,
    );
  }
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController iinController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ValueNotifier<String?> _iinError = ValueNotifier(null);
  final ValueNotifier<String?> _passwordError = ValueNotifier(null);
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);
  final ValueNotifier<bool> _allowTapButton = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    iinController.addListener(checkAllowTapButton);
    passwordController.addListener(checkAllowTapButton);
  }

  void checkAllowTapButton() {
    final isIINValid = iinController.text.length == 12;
    final isPasswordValid = passwordController.text.length >= 6;
    _allowTapButton.value = isIINValid && isPasswordValid;
  }

  @override
  void dispose() {
    iinController.removeListener(checkAllowTapButton);
    passwordController.removeListener(checkAllowTapButton);
    iinController.dispose();
    passwordController.dispose();
    _obscurePassword.dispose();
    _iinError.dispose();
    _passwordError.dispose();
    _allowTapButton.dispose();
    super.dispose();
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
            error: (message, error, errorResponse) {
              context.loaderOverlay.hide();
              Toaster.showErrorTopShortToast(context, message);
              Future<void>.delayed(const Duration(milliseconds: 300))
                  .whenComplete(() => _formKey.currentState!.validate());
            },
            loaded: (_) {
              context.loaderOverlay.hide();
              BlocProvider.of<AppBloc>(context).add(
                const AppEvent.changeState(
                  state: AppState.inApp(),
                ),
              );
              context.router.replaceAll([const LauncherRoute()]);
            },
            orElse: () => context.loaderOverlay.hide(),
          );
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColors.backgroundInput,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Container(
                  decoration: const BoxDecoration(color: AppColors.white),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.localized.office,
                          style: AppTextStyles.fs18w600.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          Assets.images.logoHeader.path,
                          height: 34,
                        ),
                      ],
                    ),
                  ),
                ),
                shape: const Border(
                  bottom: BorderSide(color: AppColors.dividerGrey, width: 0.5),
                ),
              ),
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
                              const Gap(30.5),
                              Container(height: 0.5, width: double.infinity, color: AppColors.muteBlue),
                              const Gap(30.5),
                              const Text(
                                'Войдите или зарегестрироуйтесь!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  height: 1.3,
                                ),
                              ),
                              const Gap(20),
                              Text(
                                'Вход',
                                style: AppTextStyles.fs18w600.copyWith(height: 1.6, color: AppColors.red),
                              ),
                              const Gap(12),
                              Text(
                                'ИИН',
                                style: AppTextStyles.fs18w500.copyWith(height: 1.6, color: AppColors.black),
                              ),
                              const Gap(12),
                              ValueListenableBuilder<String?>(
                                valueListenable: _iinError,
                                builder: (context, errorText, _) {
                                  return CustomTextField(
                                    controller: iinController,
                                    maxLength: 12, // ✅ Ограничение по длине

                                    hintText: 'Введите ИИН',
                                    keyboardType: TextInputType.number,
                                    textStyle: AppTextStyles.fs16w400.copyWith(letterSpacing: 0.4),
                                    onChanged: (value) {
                                      _iinError.value = value.length == 12 ? null : 'ИИН должен содержать 12 цифр';
                                    },
                                  );
                                },
                              ),
                              const Gap(12),
                              Text(
                                'Пароль',
                                style: AppTextStyles.fs18w500.copyWith(height: 1.6, color: AppColors.black),
                              ),
                              const Gap(12),
                              ValueListenableBuilder<bool>(
                                valueListenable: _obscurePassword,
                                builder: (context, obscure, _) {
                                  return ValueListenableBuilder<String?>(
                                    valueListenable: _passwordError,
                                    builder: (context, errorText, _) {
                                      return CustomTextField(
                                        controller: passwordController,
                                        hintText: 'Введите пароль',
                                        obscureText: obscure,
                                        keyboardType: TextInputType.text,
                                        textStyle: AppTextStyles.fs16w400.copyWith(letterSpacing: 0.4),
                                        onChanged: (value) {
                                          _passwordError.value = value.length >= 6 ? null : 'Минимум 6 символов';
                                        },
                                        suffixIcon: GestureDetector(
                                          onTap: () => _obscurePassword.value = !_obscurePassword.value,
                                          child: Icon(
                                            obscure ? Icons.visibility_off : Icons.visibility,
                                            color: AppColors.black,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              const Gap(25),
                              ValueListenableBuilder<bool>(
                                valueListenable: _allowTapButton,
                                builder: (context, enabled, _) {
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                          onPressed: enabled
                                              ? () {
                                                  FocusScope.of(context).unfocus();
                                                  context.read<LoginCubit>().login(
                                                        iin: iinController.text,
                                                        password: passwordController.text,
                                                      );
                                                }
                                              : null,
                                          style: CustomButtonStyles.mainButtonStyle(context),
                                          child: const Text(
                                            'Войти',
                                            style: AppTextStyles.fs16w600,
                                          ),
                                        ),
                                      ),
                                      const Gap(20),
                                      Expanded(
                                        child: CustomButton(
                                          onPressed: () {
                                            // Навигация на страницу регистрации, если есть
                                          },
                                          style: CustomButtonStyles.mainButtonStyle(
                                            context,
                                            backgroundColor: Colors.white,
                                            side: const BorderSide(color: AppColors.barrierColor),
                                          ),
                                          child: Text(
                                            'Регистрация',
                                            style: AppTextStyles.fs16w600.copyWith(color: AppColors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const Gap(12),
                            ],
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
