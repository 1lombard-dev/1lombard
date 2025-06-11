import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:lombard/src/core/constant/constants.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/extensions/build_context.dart';
import 'package:lombard/src/core/presentation/widgets/buttons/custom_button.dart';
import 'package:lombard/src/core/presentation/widgets/dialog/toaster.dart';
import 'package:lombard/src/core/presentation/widgets/other/custom_loading_overlay_widget.dart';
import 'package:lombard/src/core/presentation/widgets/textfields/custom_textfield.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/auth/models/request/user_payload.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';
import 'package:lombard/src/feature/profile/bloc/profile_bloc.dart';
import 'package:lombard/src/feature/profile/bloc/profile_edit_cubit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@RoutePage()
class EditProfilePage extends StatefulWidget implements AutoRouteWrapper {
  final UserDTO? user;
  const EditProfilePage({super.key, this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileEditCubit(
            repository: context.repository.profileRepository,
          ),
        ),
      ],
      child: this,
    );
  }
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<String?> _surnameError = ValueNotifier(null);
  final ValueNotifier<String?> _nameError = ValueNotifier(null);
  final ValueNotifier<String?> _lastnameError = ValueNotifier(null);
  final ValueNotifier<String?> _passwordError = ValueNotifier(null);
  // final ValueNotifier<bool> _obscureText = ValueNotifier(true);
  String phone = '';
  String email = '';

  String? imageNetwork;
  XFile? image;

  MaskTextInputFormatter maskPhoneFormatter = MaskTextInputFormatter(
    mask: '+7 ### ### ## ##',
    filter: {"#": RegExp('[0-9]')},
  );

  @override
  void initState() {
  

   

    super.initState();
  }

  @override
  void dispose() {
    surnameController.dispose();
    nameController.dispose();
    passwordController.dispose();
    lastnameController.dispose();
    _surnameError.dispose();
    _nameError.dispose();
    _lastnameError.dispose();
    _passwordError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onPanDown: (details) {
        FocusScope.of(context).unfocus();
      },
      child: LoaderOverlay(
        overlayWidgetBuilder: (progress) => const CustomLoadingOverlayWidget(),
        overlayColor: AppColors.barrierColor,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Жеке кабинетті өзгерту',
              style: AppTextStyles.fs18w600,
            ),
            shape: const Border(
              bottom: BorderSide(
                color: AppColors.dividerGrey,
                width: 0.5,
              ),
            ),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(14),

                    ///
                    /// edit avatar
                    ///
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            height: 82,
                            width: 82,
                            decoration: BoxDecoration(
                              color: AppColors.dividerGrey,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5.6,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(100)),
                              child: image != null
                                  ? Image.file(
                                      File(image?.path ?? ''),
                                      fit: BoxFit.cover,
                                    )
                                  : imageNetwork != null
                                      ? Image.network(
                                          imageNetwork ?? NOT_FOUND_IMAGE,
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: SvgPicture.asset(
                                            Assets.icons.backButton.path,
                                            height: 54,
                                            width: 54,
                                          ),
                                        ),
                              // : Center(
                              //     child: SvgPicture.asset(
                              //       Assets.icons.person.path,
                              //     ),
                              //   ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoActionSheet(
                                      actions: [
                                        CupertinoActionSheetAction(
                                          onPressed: () => pickImageFromGallery(
                                            ImageSource.camera,
                                          ).whenComplete(() {
                                            if (context.mounted) {
                                              context.router.maybePop();
                                            }
                                            setState(() {});
                                          }),
                                          child: Text(
                                            'Суретке түсіру',
                                            style: AppTextStyles.fs16w400.copyWith(color: Colors.black),
                                          ),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () => pickImageFromGallery(
                                            ImageSource.gallery,
                                          ).whenComplete(() {
                                            if (context.mounted) {
                                              context.router.maybePop();
                                            }
                                            setState(() {});
                                          }),
                                          child: Text(
                                            'Галерея',
                                            style: AppTextStyles.fs16w400.copyWith(color: Colors.black),
                                          ),
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        onPressed: () {
                                          context.router.maybePop();
                                        },
                                        child: Text(
                                          'Отмена',
                                          style: AppTextStyles.fs16w400.copyWith(color: Colors.red),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              // onTap: () => Toaster.showTopShortToast(context, message: 'Бұл функция дайын емес'),
                              child: SvgPicture.asset(Assets.icons.circle.path),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(12),

                    const Gap(24),
                    Text(
                      'Тегіңіз (Фамилия)',
                      style: AppTextStyles.fs14w400.copyWith(height: 1.6),
                    ),
                    const Gap(8),
                    CustomTextField(
                      controller: surnameController,
                      hintText: 'Тегіңізді еңгізіңіз',
                      onChanged: (value) {},
                    ),
                    const Gap(10),
                    Text(
                      'Есіміңіз',
                      style: AppTextStyles.fs14w400.copyWith(height: 1.6),
                    ),
                    const Gap(8),
                    CustomTextField(
                      controller: nameController,
                      hintText: 'Есіміңізді еңгізіңіз',
                      onChanged: (value) {},
                    ),
                    const Gap(10),
                    Text(
                      'Әкеніздің аты',
                      style: AppTextStyles.fs14w400.copyWith(height: 1.6),
                    ),
                    const Gap(8),
                    CustomTextField(
                      controller: lastnameController,
                      hintText: 'Әкеңіздің атын еңгізіңіз',
                      onChanged: (value) {},
                    ),
                    const Gap(10),
                    Text(
                      'Құпиясөз',
                      style: AppTextStyles.fs14w400.copyWith(height: 1.6),
                    ),
                    const Gap(8),
                    CustomTextField(
                      controller: passwordController,
                      obscureText: true,
                      hintText: 'Құпиясөз еңгізіңіз',
                      onChanged: (value) {},
                    ),
                    const Gap(10),
                    Text(
                      'Телефон номері',
                      style: AppTextStyles.fs14w400.copyWith(height: 1.6),
                    ),
                    const Gap(8),
                    GestureDetector(
                      onTap: () => Toaster.showErrorTopShortToast(context, 'Телефон номер, почта өзгертілмейді'),
                      child: Text(
                        maskPhoneFormatter.getMaskedText(),
                        style: AppTextStyles.fs16w400.copyWith(height: 1.6),
                      ),
                    ),
                    const Gap(10),
                    Text(
                      'Почта',
                      style: AppTextStyles.fs14w400.copyWith(height: 1.6),
                    ),
                    const Gap(8),
                    GestureDetector(
                      onTap: () => Toaster.showErrorTopShortToast(context, 'Телефон номер, почта өзгертілмейді'),
                      child: Text(
                        email,
                        style: AppTextStyles.fs16w400.copyWith(height: 1.6),
                      ),
                    ),
                    const Gap(19),
                    BlocListener<ProfileEditCubit, ProfileEditState>(
                      listener: (context, state) {
                        state.maybeWhen(
                          error: (message) {
                            context.loaderOverlay.hide();
                            Toaster.showErrorTopShortToast(context, message);
                            //
                          },
                          loading: () {
                            context.loaderOverlay.show();
                            // _refreshController.resetNoData();
                          },
                          loaded: () {
                            context.loaderOverlay.hide();
                            Toaster.showTopShortToast(context, message: 'Сәтті өзгертілді');
                            context.router.popUntil((route) => route.settings.name == LauncherRoute.name);
                            BlocProvider.of<ProfileBLoC>(context).add(const ProfileEvent.getProfile());
                          },
                          orElse: () {
                            context.loaderOverlay.hide();
                            // _completeRefreshControllers();
                          },
                        );
                      },
                      child: CustomButton(
                        onPressed: () {
                          log(name: 'name', nameController.text);
                          log(name: 'surname', surnameController.text);
                          log(name: 'lastname', lastnameController.text);
                          log(name: 'password', passwordController.text);
                          log(name: 'phone', phone);
                          log(name: 'email', email);
                          log(name: 'avatar', '$image');

                          BlocProvider.of<ProfileEditCubit>(context).editAccount(
                            userPayload: UserPayload(
                              surname: surnameController.text,
                              name: nameController.text,
                              patronymic: lastnameController.text,
                              password: passwordController.text,
                            ),
                            avatar: image,
                          );
                        },
                        style: CustomButtonStyles.mainButtonStyle(context),
                        child: const Text(
                          'Сақтау',
                          style: AppTextStyles.fs16w600,
                        ),
                      ),
                    ),

                    const Gap(20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future pickImageFromGallery(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = XFile(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }
}
