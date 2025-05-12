import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lombard/src/core/presentation/widgets/error/error_text_widget.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/feature/auth/presentation/widgets/password_eye_suffix_icon.dart';

class CustomValidatorTextfield extends StatelessWidget {
  const CustomValidatorTextfield({
    super.key,
    required this.controller,
    this.validator,
    required this.valueListenable,
    this.onChanged,
    this.hintText,
    this.obscureText,
    this.inputFormatters,
    this.suffixIcon,
    this.onTap,
    this.autofocus = false,
    this.readOnly = false,
    this.keyboardType,
  });

  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueNotifier<String?> valueListenable;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final String? hintText;
  final ValueNotifier<bool>? obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final bool autofocus;
  final bool readOnly;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (context, v, c) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              readOnly: readOnly,
              onTap: onTap,
              autofocus: autofocus,
              autocorrect: false,
              obscureText: obscureText?.value ?? false,
              style: AppTextStyles.fs16w400h1_6,
              inputFormatters: inputFormatters,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: keyboardType,
              controller: controller,
              onChanged: onChanged,
              cursorHeight: 18,
              validator: validator,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                fillColor: v == null ? null : AppColors.red,
                suffixIcon: obscureText != null
                    ? PasswordEyeSuffixIcon(
                        valueListenable: obscureText!,
                        hasError: valueListenable.value != null,
                      )
                    : suffixIcon,
                hintText: hintText,
                errorStyle: const TextStyle(
                  height: 0,
                  fontSize: 0,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ErrorTextWidget(
                text: valueListenable.value,
              ),
            ),
          ],
        );
      },
    );
  }
}
