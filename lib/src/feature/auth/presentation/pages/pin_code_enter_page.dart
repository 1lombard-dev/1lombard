import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';
import 'package:lombard/src/feature/app/bloc/app_bloc.dart';
import 'package:lombard/src/feature/app/router/app_router.dart';
import 'package:lombard/src/feature/auth/models/user_dto.dart';
import 'package:lombard/src/feature/auth/presentation/widgets/nsk_text.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

@RoutePage()
class PinCodeEnterPage extends StatefulWidget {
  const PinCodeEnterPage({super.key});

  @override
  State<PinCodeEnterPage> createState() => _PinCodeEnterPageState();
}

class _PinCodeEnterPageState extends State<PinCodeEnterPage> {
  final TextEditingController pinController = TextEditingController();
  bool isPinCorrect = true;
  bool isBiommericsEnabled = false;
  bool loadRx = false;
  String userName = '';

  Future<void> checkPin(TextEditingController controller) async {
    final UserDTO? userDTO = context.repository.authRepository.cacheUser();
    userName = userDTO!.fullname!;
    if (controller.text.length == 4) {
      final pin = context.repository.authDao.pinCode.value;

      if (pin == controller.text) {
        await Future.delayed(const Duration(milliseconds: 200));

        // Сначала обновляем состояние приложения
        BlocProvider.of<AppBloc>(context).add(
          const AppEvent.changeState(state: AppState.inApp()),
        );

        // Затем заменяем роуты
        context.router.replaceAll([const LauncherRoute()]);
      } else {
        setState(() => isPinCorrect = false);

        await Future.delayed(const Duration(seconds: 1));

        controller.clear();

        setState(() => isPinCorrect = true);
      }
    }
  }

  void setPin(String value, int index, TextEditingController pinController) async {
    // index == 9
    //     ? isBiommericsEnabled.value
    //         ? authenticate()
    //         : null
    // :
    index == 11
        ? pinController.text.isNotEmpty
            ? pinController.text = pinController.text.substring(0, pinController.text.length - 1)
            : null
        : pinController.text.length < 4
            ? pinController.text = pinController.value.text + value
            : null;
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
    '',
    '0',
    'backspace',
  ];

  @override
  Widget build(BuildContext context) {
    checkPin(pinController);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          onPressed: () {
            BlocProvider.of<AppBloc>(context).add(
              const AppEvent.changeState(
                state: AppState.notAuthorized(),
              ),
            );
            context.router.replaceAll([const LauncherRoute()]);
          },
          icon: const Icon(
            Icons.clear,
            color: AppColors.red,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Image.asset(
          Assets.images.logoHeader.path,
          height: 20,
        ),
      ),
      bottomSheet: GridView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 67,
          vertical: 30,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 90,
          childAspectRatio: 1,
          crossAxisSpacing: 24,
          mainAxisSpacing: 16,
        ),
        itemCount: 12,
        itemBuilder: (context, index) => InkWell(
          borderRadius: BorderRadius.circular(188),
          splashColor: AppColors.red.withOpacity(0.3),
          highlightColor: AppColors.white,
          onTap: () {
            setState(() {});
            setPin(numbers[index], index, pinController);
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(188),
              border: Border.all(
                color: AppColors.red,
              ),
            ),
            child: index == 9
                ? SvgPicture.asset(Assets.icons.fingerprint.path,
                    color:
                        // controller.isBiommericsEnabled.value
                        //     ?
                        AppColors.red
                    // : Colors.grey,
                    )
                : index == 11
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
              onChanged: (value) {},
            ),
          ),
          LombardText(
            isPinCorrect ? 'Введите 4-х значный код для \nбыстрого доступа к приложению' : 'Неверный код',
            color: isPinCorrect ? AppColors.black : Colors.red,
          ),
        ],
      ),
    );
  }
}
