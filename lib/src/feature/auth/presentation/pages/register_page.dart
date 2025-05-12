// // ignore_for_file: deprecated_member_use

// import 'dart:developer';
// import 'dart:io';

// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
// import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
// import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
// import 'package:lombard/src/core/presentation/widgets/scroll/scroll_wrapper.dart';
// import 'package:lombard/src/core/presentation/widgets/textfields/custom_validator_textfield.dart';
// import 'package:lombard/src/core/theme/resources.dart';
// import 'package:lombard/src/core/utils/extensions/context_extension.dart';
// import 'package:lombard/src/core/utils/input/validator_util.dart';
// import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
// import 'package:lombard/src/feature/app/router/app_router.dart';
// import 'package:lombard/src/feature/auth/bloc/register_cubit.dart';
// import 'package:lombard/src/feature/auth/models/common_dto.dart';
// import 'package:lombard/src/feature/auth/models/request/user_payload.dart';
// import 'package:lombard/src/feature/profile/bloc/document_list_cubit.dart';

// @RoutePage()
// class RegisterPage extends StatefulWidget implements AutoRouteWrapper {
//   const RegisterPage({
//     super.key,
//   });

//   @override
//   _RegisterPageState createState() => _RegisterPageState();

//   @override
//   Widget wrappedRoute(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => RegisterCubit(repository: context.repository.authRepository),
//           child: this,
//         ),
//         BlocProvider(
//           create: (context) => DocumentListCubit(repository: context.repository.profileRepository),
//           child: this,
//         ),
//       ],
//       child: this,
//     );
//   }
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController surnameController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController passwordRepeatController = TextEditingController();
//   final ValueNotifier<bool> _obscureText = ValueNotifier(true);
//   final ValueNotifier<String?> _phoneError = ValueNotifier(null);
//   final ValueNotifier<String?> _passwordError = ValueNotifier(null);
//   final ValueNotifier<String?> _surnameError = ValueNotifier(null);
//   final ValueNotifier<String?> _nameError = ValueNotifier(null);
//   final ValueNotifier<String?> _passwordRepeatError = ValueNotifier(null);
//   final ValueNotifier<String?> _classError = ValueNotifier(null);
//   final ValueNotifier<bool> _allowTapButton = ValueNotifier(false);
//   final ValueNotifier<String?> _emailError = ValueNotifier(null);
//   CommonDTO? chosenClass;
//   final MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(mask: '+7(###) ###-##-##');
//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<DocumentListCubit>(context).getAddressList();
//   }

//   @override
//   void dispose() {
//     surnameController.dispose();
//     nameController.dispose();
//     phoneController.dispose();
//     emailController.dispose();
//     _surnameError.dispose();
//     _nameError.dispose();
//     _classError.dispose();
//     _emailError.dispose();
//     passwordController.dispose();
//     _allowTapButton.dispose();
//     passwordRepeatController.dispose();
//     super.dispose();
//   }

//   void checkAllowTapButton() {
//     _allowTapButton.value = maskFormatter.getUnmaskedText().length == 10 && passwordController.text.isNotEmpty;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LoaderOverlay(
//       overlayColor: AppColors.barrierColor,
//       overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
//       child: BlocConsumer<RegisterCubit, RegisterState>(
//         listener: (context, state) {
//           state.maybeWhen(
//             loading: () => context.loaderOverlay.show(),
//             error: (message) {
//               context.loaderOverlay.hide();
//               Toaster.showErrorTopShortToast(context, message);
//               Future<void>.delayed(
//                 const Duration(milliseconds: 300),
//               ).whenComplete(
//                 () => _formKey.currentState!.validate(),
//               );
//             },
//             loaded: (user) {
//               context.loaderOverlay.hide();
//               BlocProvider.of<AppBloc>(context).add(const AppEvent.logining());
//               context.router.replaceAll([const LauncherRoute()]);
//               Toaster.showTopShortToast(context, message: 'Успешно');
//             },
//             orElse: () => context.loaderOverlay.hide(),
//           );
//         },
//         builder: (context, state) {
//           return GestureDetector(
//             onTap: () {
//               FocusScope.of(context).unfocus();
//             },
//             child: Scaffold(
//               // appBar: AppBar(
//               //   leading: TextButton.icon(
//               //     onPressed: () {
//               //       context.router.maybePop();
//               //     },
//               //     label: SvgPicture.asset(Assets.icons.backArrow.path),
//               //   ),
//               // ),
//               body: Form(
//                 key: _formKey,
//                 // autovalidateMode: AutovalidateMode.onUserInteraction,
//                 child: ScrollWrapper(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Создать аккаунт ',
//                           style: AppTextStyles.fs26w600.copyWith(color: AppColors.greyTextColor),
//                         ),
//                         const Gap(40),
//                         Text(
//                           'Фамилия',
//                           style: AppTextStyles.fs14w400.copyWith(color: AppColors.greyTextColor),
//                         ),
//                         const Gap(6),
//                         CustomValidatorTextfield(
//                           controller: surnameController,
//                           valueListenable: _surnameError,
//                           hintText: 'Введите фамилию',
//                           onChanged: (value) {
//                             // checkAllowTapButton();
//                           },
//                           validator: (String? value) {
//                             if (value == null || value.isEmpty) {
//                               return _surnameError.value = 'Обязательно к заполнению';
//                             }

//                             return _surnameError.value = null;
//                           },
//                         ),
//                         const Gap(16),
//                         Text(
//                           'Имя',
//                           style: AppTextStyles.fs14w400.copyWith(color: AppColors.greyTextColor),
//                         ),
//                         const Gap(6),
//                         CustomValidatorTextfield(
//                           controller: nameController,
//                           valueListenable: _nameError,
//                           hintText: 'Введите имя',
//                           onChanged: (value) {
//                             // checkAllowTapButton();
//                           },
//                           validator: (String? value) {
//                             if (value == null || value.isEmpty) {
//                               return _nameError.value = 'Обязательно к заполнению';
//                             }

//                             return _nameError.value = null;
//                           },
//                         ),
//                         const Gap(16),
//                         Text(
//                           'Email',
//                           style: AppTextStyles.fs14w400.copyWith(color: AppColors.greyTextColor),
//                         ),
//                         const Gap(6),
//                         CustomValidatorTextfield(
//                           controller: emailController,
//                           valueListenable: _emailError,
//                           hintText: 'Введите почту',
//                           keyboardType: TextInputType.emailAddress,
//                           onChanged: (value) {
//                             checkAllowTapButton();
//                           },
//                           validator: (String? value) {
//                             return _emailError.value = ValidatorUtil.emailValidator(
//                               emailController.text,
//                               errorLabel: 'Неверный логин',
//                             );
//                           },
//                         ),
//                         const Gap(16),
//                         Text(
//                           'Номер телефона',
//                           style: AppTextStyles.fs14w400.copyWith(color: AppColors.greyTextColor),
//                         ),
//                         const Gap(6),
//                         CustomValidatorTextfield(
//                           controller: phoneController,
//                           valueListenable: _phoneError,
//                           inputFormatters: [maskFormatter],
//                           keyboardType: TextInputType.phone,
//                           hintText: 'Введите номер телефона',
//                           onChanged: (value) {
//                             checkAllowTapButton();
//                           },
//                           validator: (String? value) {
//                             if (value == null || value.isEmpty) {
//                               return _phoneError.value = 'Обязательно к заполнению';
//                             }
//                             if (maskFormatter.getUnmaskedText().length != 10) {
//                               return _phoneError.value = 'Неверный формат номера';
//                             }
//                             return _phoneError.value = null;
//                           },
//                         ),
//                         const Gap(16),
//                         Text(
//                           'Пароль',
//                           style: AppTextStyles.fs14w400.copyWith(color: AppColors.greyTextColor),
//                         ),
//                         const Gap(6),
//                         ValueListenableBuilder(
//                           valueListenable: _obscureText,
//                           builder: (context, v, c) {
//                             return CustomValidatorTextfield(
//                               obscureText: _obscureText,
//                               controller: passwordController,
//                               valueListenable: _passwordError,
//                               hintText: 'Введите новый пароль',
//                               onChanged: (value) {
//                                 checkAllowTapButton();
//                               },
//                               validator: (String? value) {
//                                 if (value == null || value.isEmpty) {
//                                   return _passwordError.value = 'Обязательно к заполнению';
//                                 }

//                                 if (value.length < 6) {
//                                   return _passwordError.value = 'Минимальная длина пароля - 6';
//                                 }

//                                 return _passwordError.value = null;
//                               },
//                             );
//                           },
//                         ),
//                         const Gap(16),
//                         Text(
//                           'Повторите пароль',
//                           style: AppTextStyles.fs14w400.copyWith(color: AppColors.greyTextColor),
//                         ),
//                         const Gap(6),
//                         ValueListenableBuilder(
//                           valueListenable: _obscureText,
//                           builder: (context, v, c) {
//                             return CustomValidatorTextfield(
//                               obscureText: _obscureText,
//                               controller: passwordRepeatController,
//                               valueListenable: _passwordRepeatError,
//                               hintText: 'Повторите пароль',
//                               onChanged: (value) {
//                                 checkAllowTapButton();
//                               },
//                               validator: (String? value) {
//                                 if (value == null || value.isEmpty) {
//                                   return _passwordRepeatError.value = 'Обязательно к заполнению';
//                                 }

//                                 if (value.length < 6) {
//                                   return _passwordRepeatError.value = 'Минимальная длина пароля - 6';
//                                 }

//                                 if (value != passwordController.text) {
//                                   return _passwordRepeatError.value = 'Пароли не совпадают';
//                                 }
//                                 return _passwordRepeatError.value = null;
//                               },
//                             );
//                           },
//                         ),
//                         const Gap(24),
//                         BlocConsumer<DocumentListCubit, DocumentListState>(
//                           listener: (context, state) {
//                             state.maybeWhen(
//                               error: (message) {
//                                 Toaster.showErrorTopShortToast(context, message);
//                               },
//                               orElse: () {},
//                             );
//                           },
//                           builder: (context, state) {
//                             return RichText(
//                               text: TextSpan(
//                                 text: 'Нажимая на кнопку “Создать аккаунт” вы соглашаетесь  с ', // Default style text
//                                 style: AppTextStyles.fs14w400.copyWith(color: AppColors.black),
//                                 children: <TextSpan>[
//                                   TextSpan(
//                                     recognizer: TapGestureRecognizer()
//                                       ..onTap = () {
//                                         state.whenOrNull(
//                                           loaded: (meta) {
//                                             launch(meta[1].file ?? '');
//                                             log('${meta[1].file}', name: 'term doc');
//                                           },
//                                         );
//                                       },
//                                     text: 'Условиями Использования ', // Bold text
//                                     style: AppTextStyles.fs14w400.copyWith(color: const Color(0xFFEB4879)),
//                                   ),
//                                   TextSpan(
//                                     text: ' и ', // Underlined and clickable text
//                                     style: AppTextStyles.fs14w400.copyWith(color: AppColors.black),
//                                   ),
//                                   TextSpan(
//                                     recognizer: TapGestureRecognizer()
//                                       ..onTap = () {
//                                         state.whenOrNull(
//                                           loaded: (meta) {
//                                             log('${meta[0].file}', name: 'policy doc');
//                                             launch(meta[0].file ?? '');
//                                           },
//                                         );
//                                       },
//                                     text: 'Политикой Конфиденциальности, ', // Underlined and clickable text
//                                     style: AppTextStyles.fs14w400.copyWith(color: const Color(0xFFEB4879)),
//                                   ),
//                                   TextSpan(
//                                     recognizer: TapGestureRecognizer()
//                                       ..onTap = () {
//                                         state.whenOrNull(
//                                           loaded: (meta) {
//                                             launch(meta[2].file ?? '');
//                                             log('${meta[2].file}', name: 'payment doc');
//                                           },
//                                         );
//                                       },
//                                     text: 'Онлайн оплата', // Underlined and clickable text
//                                     style: AppTextStyles.fs14w400.copyWith(color: const Color(0xFFEB4879)),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                         const Gap(28),
//                         CustomButton(
//                           allowTapButton: _allowTapButton,
//                           onPressed: () {
//                             if (!_formKey.currentState!.validate()) return;

//                             final UserPayload userPayload = UserPayload(
//                               name: nameController.text,
//                               surname: surnameController.text,
//                               email: emailController.text,
//                               phone: maskFormatter.getUnmaskedText(),
//                               password: passwordController.text,
//                             );
//                             BlocProvider.of<RegisterCubit>(context).register(
//                               user: userPayload,
//                               deviceType: Platform.isAndroid ? 'Android' : 'IOS',
//                             );
//                           },
//                           style: null,
//                           text: 'Создать аккаунт',
//                           child: null,
//                         ),
//                         const Gap(22),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
