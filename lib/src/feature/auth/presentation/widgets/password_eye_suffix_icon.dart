import 'package:flutter/material.dart';

class PasswordEyeSuffixIcon extends StatelessWidget {
  const PasswordEyeSuffixIcon({
    super.key,
    required this.valueListenable,
    this.hasError = true,
  });
  final ValueNotifier<bool> valueListenable;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        valueListenable.value = !valueListenable.value;
      },
      // child: Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 15),
      //   child: SvgPicture.asset(
      //     valueListenable.value ? Assets.icons.visibility.path : Assets.icons.visibilityOff.path,
      //     colorFilter: hasError ? const ColorFilter.mode(AppColors.red, BlendMode.srcIn) : null,
      //   ),
      // ),
    );
  }
}
