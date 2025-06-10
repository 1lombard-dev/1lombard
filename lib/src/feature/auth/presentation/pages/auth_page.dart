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
  final ValueNotifier<String?> _iinError = ValueNotifier(null);

  final ValueNotifier<bool> _obscureText = ValueNotifier(true);
  final ValueNotifier<bool> _allowTapButton = ValueNotifier(false);

  bool isIINValid = false;

  @override
  void dispose() {
    iinController.dispose();
    _obscureText.dispose();
    _iinError.dispose();
    _allowTapButton.dispose();
    super.dispose();
  }

  void checkAllowTapButton() {
    final isIINValid = iinController.text.length == 12;

    _allowTapButton.value = isIINValid;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayColor: AppColors.barrierColor,
      overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          state.maybeWhen(
            loading: () {
              // Toaster.showLoadingTopShortToast(context, message: 'Құпиясөз жіберілді');
            },
            error: (message, error, errorResponse) {
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
              backgroundColor: AppColors.backgroundInput,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                  ),
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
                  bottom: BorderSide(
                    color: AppColors.dividerGrey,
                    width: 0.5,
                  ),
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
                              Container(
                                height: 0.5,
                                width: double.infinity,
                                color: AppColors.muteBlue,
                              ),
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
                              CustomTextField(
                                controller: iinController,
                                hintText: 'Введите ИИН',
                                keyboardType: TextInputType.number,
                                textStyle: AppTextStyles.fs16w400.copyWith(letterSpacing: 0.4),
                                onChanged: (value) {
                                  checkAllowTapButton();
                                  setState(() {});
                                },
                              ),
                              const Gap(12),
                              Text(
                                'Пароль',
                                style: AppTextStyles.fs18w500.copyWith(height: 1.6, color: AppColors.black),
                              ),
                              const Gap(12),
                              CustomTextField(
                                controller: iinController,
                                hintText: 'Введите пароль',
                                keyboardType: TextInputType.number,
                                textStyle: AppTextStyles.fs16w400.copyWith(letterSpacing: 0.4),
                                onChanged: (value) {
                                  checkAllowTapButton();
                                  setState(() {});
                                },
                              ),
                              const Gap(25),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      onPressed: () {},
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
                                      onPressed: () {},
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
