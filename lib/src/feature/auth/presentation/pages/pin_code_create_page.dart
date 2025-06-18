import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  String firstPin = '';
  bool isRepeatPin = false;
  bool isPinsEqual = true;

  void init(TextEditingController pinController) {
    pinController.addListener(() {
      if (pinController.value.text.length == 4) {
        if (isRepeatPin) {
          checkPins(pinController);
        } else {
          firstPin = pinController.text;
          log('FIRST PINN: $firstPin');
          Future.delayed(const Duration(milliseconds: 200)).then((value) {
            pinController.clear();
            isRepeatPin = true;
            setState(() {});
          });
        }
      }
    });
  }

    Future<void>  checkPins(TextEditingController controller) async {
    if (firstPin == controller.text) {
      // box.write('pin', firstPin.value);
      context.repository.authDao.pinCode.setValue(firstPin);

      await Future.delayed(const Duration(milliseconds: 200));

      // Сначала обновляем состояние приложения
      BlocProvider.of<AppBloc>(context).add(
        const AppEvent.changeState(state: AppState.inApp()),
      );

      // Затем заменяем роуты
      context.router.replaceAll([const LauncherRoute()]);
    } else {
      isPinsEqual = false;
      Future.delayed(const Duration(seconds: 1)).then(
        (value) {
          isPinsEqual = true;
          controller.clear();
        },
      );
    }
  }

  void setPin(String value, int index, TextEditingController pinController) {
    if (index == 11) {
      pinController.text.isNotEmpty
          ? pinController.text = pinController.text.substring(0, pinController.text.length - 1)
          : null;
    } else {
      pinController.value.text.length < 4 ? pinController.text = pinController.text + value : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    init(pinController);
    return Scaffold(
      bottomSheet: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(
          horizontal: 67,
          vertical: 40,
        ),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 83,
          childAspectRatio: 1,
          crossAxisSpacing: 44,
          mainAxisSpacing: 20,
        ),
        itemCount: 12,
        itemBuilder: (context, index) => index == 9
            ? const SizedBox()
            : InkWell(
                borderRadius: BorderRadius.circular(188),
                splashColor: AppColors.red.withOpacity(0.3),
                highlightColor: AppColors.white,
                onTap: () async {
                  setState(() {});
                  setPin(numbers[index], index, pinController);
                },
                child: Container(
                  // width: getProportionateScreenWidth(64),
                  // height: getProportionateScreenHeight(64),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(188),
                    border: Border.all(
                      color: AppColors.red,
                    ),
                  ),
                  child: index == 11
                      ? const Icon(
                          Icons.backspace,
                          color: AppColors.red,
                        )
                      : LombardText(
                          numbers[index],
                          fontSize: 36,
                          fontWeight: FontWeight.w400,
                          color: AppColors.red,
                        ),
                ),
              ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(
            flex: 2,
          ),
          LombardText(
            isPinsEqual
                ? isRepeatPin
                    ? 'Повторите код доступа'
                    : 'Придумайте код доступа'
                : 'Не совподает',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isPinsEqual ? AppColors.black : Colors.red,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 106,
            ),
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              enabled: false,
              controller: pinController,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.underline,
                fieldWidth: 32,
                disabledColor: AppColors.red,
              ),
              onChanged: (value) {
                // setState(() {});
              },
            ),
          ),
          const Spacer(
            flex: 3,
          ),
        ],
      ),
    );
  }

  List<String> numbers = [
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
}
