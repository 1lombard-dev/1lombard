import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';
import 'package:lombard/src/feature/auth/presentation/widgets/forgot_pincode_bottom_sheet.dart';
import 'package:lombard/src/feature/auth/presentation/widgets/nsk_text.dart';
import 'package:lombard/src/feature/profile/bloc/logout_cubit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

@RoutePage()
class PinCodeEnterPage extends StatefulWidget {
  const PinCodeEnterPage({super.key});

  @override
  State<PinCodeEnterPage> createState() => _PinCodeEnterPageState();
}

class _PinCodeEnterPageState extends State<PinCodeEnterPage> {
  final TextEditingController pinController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();

  bool isPinCorrect = true;
  String userName = '';

  final List<String> numbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '',
    '0',
    'backspace',
  ];

  @override
  void initState() {
    super.initState();

    final UserDTO? userDTO = context.repository.authRepository.cacheUser();
    userName = userDTO?.fullname ?? '';

    // Автоматически запрашивает Face ID / Fingerprint
    authenticateWithBiometricsIfAvailable();
  }

  Future<void> authenticateWithBiometricsIfAvailable() async {
    final canCheckBiometrics = await auth.canCheckBiometrics;
    final isDeviceSupported = await auth.isDeviceSupported();
    final biometrics = await auth.getAvailableBiometrics();

    if (!canCheckBiometrics || !isDeviceSupported || biometrics.isEmpty) return;

    try {
      if (biometrics.contains(BiometricType.face)) {
        final authenticated = await auth.authenticate(
          localizedReason: 'Войдите с помощью Face ID',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (authenticated && mounted) {
          _enterApp();
        }
      } else if (biometrics.contains(BiometricType.fingerprint)) {
        final authenticated = await auth.authenticate(
          localizedReason: 'Войдите с помощью отпечатка пальца',
          options: const AuthenticationOptions(biometricOnly: true),
        );
        if (authenticated && mounted) {
          _enterApp();
        }
      }
    } catch (e) {
      debugPrint('Ошибка биометрии: $e');
    }
  }

  void _enterApp() {
    BlocProvider.of<AppBloc>(context).add(const AppEvent.changeState(state: AppState.inApp()));
    context.router.replaceAll([const LauncherRoute()]);
  }

  Future<void> checkPin(String input) async {
    final savedPin = context.repository.authDao.pinCode.value;
    if (input == savedPin) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _enterApp();
    } else {
      setState(() => isPinCorrect = false);
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      pinController.clear();
      setState(() => isPinCorrect = true);
    }
  }

  void onKeyPressed(String value, int index) async {
    if (index == 11) {
      if (pinController.text.isNotEmpty) {
        pinController.text = pinController.text.substring(0, pinController.text.length - 1);
        setState(() {});
      }
      return;
    }

    if (pinController.text.length < 4) {
      pinController.text += value;
      setState(() {});
      if (pinController.text.length == 4) {
        await checkPin(pinController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          onPressed: () {
            showDialog(
              context: context,
              useRootNavigator: false,
              // barrierDismissible: true,
              builder: (BuildContext context) {
                return BlocProvider(
                  create: (context) => LogoutCubit(),
                  child: ForgotPincodeBottomSheet(
                    parentContext: context,
                  ),
                );
              },
            );
          },
          icon: const Icon(
            Icons.clear,
            color: AppColors.red,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        title: Image.asset(
          Assets.images.logoHeader.path,
          height: 20,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 54,
            height: 54,
            padding: const EdgeInsets.all(2.57),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.black, width: 1),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.lightGrey,
              ),
              child: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 10),
          LombardText(
            '$userName, \nЗдравствуйте!',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 106),
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              controller: pinController,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                fieldWidth: 32,
                activeColor: AppColors.red,
                inactiveColor: AppColors.red,
                selectedColor: AppColors.red,
                disabledColor: AppColors.red,
                borderWidth: 1,
                activeFillColor: Colors.transparent,
                inactiveFillColor: Colors.transparent,
                selectedFillColor: Colors.transparent,
              ),
              backgroundColor: Colors.transparent,
              onChanged: (_) {},
            ),
          ),
          const SizedBox(height: 12),
          LombardText(
            isPinCorrect ? 'Введите 4-х значный код для \nбыстрого доступа к приложению' : 'Неверный код',
            color: isPinCorrect ? AppColors.black : Colors.red,
          ),
          const Gap(
            26,
          ),
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 67, vertical: 30),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 90,
              childAspectRatio: 1,
              crossAxisSpacing: 24,
              mainAxisSpacing: 16,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final label = numbers[index];
              return InkWell(
                borderRadius: BorderRadius.circular(188),
                splashColor: AppColors.red.withOpacity(0.3),
                highlightColor: AppColors.white,
                onTap: () => onKeyPressed(label, index),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(188),
                    border: Border.all(color: AppColors.red),
                  ),
                  child: index == 9
                      ? SvgPicture.asset(
                          Assets.icons.fingerprint.path,
                          color: AppColors.red,
                        )
                      : index == 11
                          ? const Icon(Icons.backspace, color: AppColors.red)
                          : LombardText(
                              label,
                              fontSize: 36,
                              fontWeight: FontWeight.w400,
                              color: AppColors.red,
                            ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
