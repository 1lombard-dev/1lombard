import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/auth/presentation/widgets/nsk_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

@RoutePage()
class PinCodeCreatePage extends StatefulWidget {
  const PinCodeCreatePage({super.key});

  @override
  State<PinCodeCreatePage> createState() => _PinCodeCreatePageState();
}

class _PinCodeCreatePageState extends State<PinCodeCreatePage> {
  final TextEditingController pinController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();

  String firstPin = '';
  bool isRepeatPin = false;
  bool isPinsEqual = true;

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
    'empty',
    '0',
    'backspace',
  ];

  @override
  void initState() {
    super.initState();
    pinController.addListener(() {
      if (pinController.text.length == 4) {
        if (isRepeatPin) {
          checkPins(pinController);
        } else {
          firstPin = pinController.text;
          Future.delayed(const Duration(milliseconds: 200)).then((_) {
            if (!mounted) return;
            pinController.clear();
            isRepeatPin = true;
            setState(() {});
          });
        }
      }
    });
  }

  Future<void> checkPins(TextEditingController controller) async {
    if (firstPin == controller.text) {
      context.repository.authDao.pinCode.setValue(firstPin);

      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;

      // Проверка биометрии
      final canCheckBiometrics = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();
      final biometrics = await auth.getAvailableBiometrics();

      if (canCheckBiometrics && isDeviceSupported && biometrics.isNotEmpty) {
        BiometricType? preferredBiometric;

        if (biometrics.contains(BiometricType.face)) {
          preferredBiometric = BiometricType.face;
        } else if (biometrics.contains(BiometricType.fingerprint)) {
          preferredBiometric = BiometricType.fingerprint;
        }

        if (preferredBiometric != null) {
          final enable = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(preferredBiometric == BiometricType.face
                  ? 'Включить Face ID?'
                  : 'Включить вход по отпечатку пальца?'),
              content: const Text('Вы сможете входить в приложение с помощью биометрии.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Нет'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Да'),
                ),
              ],
            ),
          );

          if (!mounted) return;

          if (enable == true) {
            try {
              final authenticated = await auth.authenticate(
                localizedReason:
                    preferredBiometric == BiometricType.face ? 'Подтвердите Face ID' : 'Подтвердите отпечаток пальца',
                options: const AuthenticationOptions(
                  biometricOnly: true,
                  stickyAuth: true,
                ),
              );

              if (authenticated) {
                // context.repository.authDao.biometricEnabled.setValue(true);
                log('✅ Биометрия успешно включена');
              }
            } catch (e) {
              debugPrint('❌ Ошибка биометрии: $e');
            }
          }
        }
      }

      if (!mounted) return;
      BlocProvider.of<AppBloc>(context).add(
        const AppEvent.changeState(state: AppState.inApp()),
      );
      context.router.replaceAll([const LauncherRoute()]);
    } else {
      isPinsEqual = false;
      setState(() {});
      Future.delayed(const Duration(seconds: 1)).then((_) {
        if (!mounted) return;
        isPinsEqual = true;
        controller.clear();
        setState(() {});
      });
    }
  }

  void setPin(String value, int index) {
    if (index == 11) {
      if (pinController.text.isNotEmpty) {
        pinController.text = pinController.text.substring(0, pinController.text.length - 1);
      }
    } else if (pinController.text.length < 4) {
      pinController.text += value;
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          LombardText(
            isPinsEqual ? (isRepeatPin ? 'Повторите код доступа' : 'Придумайте код доступа') : 'Коды не совпадают',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isPinsEqual ? AppColors.black : Colors.red,
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
                borderWidth: 1,
                activeColor: AppColors.red,
                inactiveColor: AppColors.red,
                selectedColor: AppColors.red,
                activeFillColor: Colors.transparent,
                inactiveFillColor: Colors.transparent,
                selectedFillColor: Colors.transparent,
              ),
              backgroundColor: Colors.transparent,
              onChanged: (_) {},
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
      bottomSheet: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 67, vertical: 40),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 83,
          childAspectRatio: 1,
          crossAxisSpacing: 44,
          mainAxisSpacing: 20,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final label = numbers[index];
          if (index == 9) return const SizedBox(); // пустая кнопка

          return InkWell(
            borderRadius: BorderRadius.circular(188),
            splashColor: AppColors.red.withOpacity(0.3),
            highlightColor: AppColors.white,
            onTap: () => setPin(label, index),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(188),
                border: Border.all(color: AppColors.red),
              ),
              child: index == 11
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
    );
  }
}
