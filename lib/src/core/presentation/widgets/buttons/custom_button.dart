import 'package:flutter/material.dart';
import 'package:lombard/src/core/theme/resources.dart';
import 'package:lombard/src/core/utils/extensions/context_extension.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onPressed,
    required this.style,
    required this.child,
    super.key,
    this.width,
    this.height,
    this.text = '',
    this.isExpanded = true,
    this.onLongPress,
    this.allowTapButton,
  });
  final Widget? child;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final double? width;
  final double? height;
  final String text;
  final bool isExpanded;
  final VoidCallback? onLongPress;
  final ValueNotifier<bool>? allowTapButton;

  @override
  Widget build(BuildContext context) {
    Widget getWidget(bool allowTap) => SizedBox(
          width: width ?? (isExpanded ? double.infinity : null),
          height: height,
          child: ElevatedButton(
            onPressed: allowTap ? onPressed : null,
            onLongPress: onLongPress,
            style: style,
            child: child ??
                Text(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: context.deviceSize.maybeWhenByValue(
                      orElse: 16,
                      smallPhone: 14,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
          ),
        );

    if (allowTapButton != null) {
      return ValueListenableBuilder(
        valueListenable: allowTapButton!,
        builder: (context, v, c) => getWidget(v),
      );
    }

    return getWidget(true);
  }
}

class CustomButtonStyles {
  const CustomButtonStyles._();

  static ButtonStyle mainButtonStyle(
    BuildContext context, {
    double elevation = 0,
    double radius = 16,
    double height = 51,
    Color? backgroundColor = AppColors.red,
    Color? foregroundColor = Colors.white,
    Color? disabledForegroundColor = Colors.white,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    EdgeInsetsGeometry? padding,
    BorderSide side = BorderSide.none,
  }) =>
      ElevatedButton.styleFrom(
        fixedSize: Size.fromHeight(height),
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        // disabledBackgroundColor: disabledBackgroundColor ?? context.theme.mainColor.withOpacity(0.4),
        elevation: elevation,
        // shadowColor: shadowColor ?? context.theme.background50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          side: side,
        ),
        padding: padding,
      );

  static ButtonStyle disabledMainButtonStyle(
    BuildContext context, {
    double elevation = 0,
    double radius = 16,
    double height = 51,
    Color? backgroundColor = AppColors.thirdBlueColor,
    Color? foregroundColor = Colors.white,
    Color? disabledForegroundColor = Colors.white,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    EdgeInsetsGeometry? padding,
    BorderSide side = BorderSide.none,
  }) =>
      ElevatedButton.styleFrom(
        fixedSize: Size.fromHeight(height),
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        // disabledBackgroundColor: disabledBackgroundColor ?? context.theme.mainColor.withOpacity(0.4),
        elevation: elevation,
        // shadowColor: shadowColor ?? context.theme.background50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          side: side,
        ),
        padding: padding,
      );

  static ButtonStyle primaryButtonStyle(
    BuildContext context, {
    double elevation = 0,
    double radius = 16,
    double height = 51,
    Color? backgroundColor = AppColors.white,
    Color? foregroundColor = AppColors.black,
    Color? disabledForegroundColor = Colors.white,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    EdgeInsetsGeometry? padding,
    BorderSide side = const BorderSide(color: AppColors.mainColor),
  }) =>
      ElevatedButton.styleFrom(
        fixedSize: Size.fromHeight(height),
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        // backgroundColor ?? AppColors.mainColor,
        disabledForegroundColor: disabledForegroundColor,
        // disabledBackgroundColor: disabledBackgroundColor ?? context.theme.mainColor.withOpacity(0.4),
        // elevation: elevation,
        shadowColor: Colors.transparent,
        // shadowColor: shadowColor ?? context.theme.background50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          side: side,
        ),
        padding: padding,
      );

  static ButtonStyle muteBlueButtonStyle(
    BuildContext context, {
    double elevation = 0,
    double radius = 16,
    double height = 42,
    Color? backgroundColor = AppColors.muteBlue2,
    Color? foregroundColor = AppColors.mainBlueColor,
    Color? disabledForegroundColor = Colors.white,
    Color? disabledBackgroundColor,
    Color? shadowColor,
    EdgeInsetsGeometry? padding,
    BorderSide side = BorderSide.none,
  }) =>
      ElevatedButton.styleFrom(
        fixedSize: Size.fromHeight(height),
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        disabledForegroundColor: disabledForegroundColor,
        // disabledBackgroundColor: disabledBackgroundColor ?? context.theme.mainColor.withOpacity(0.4),
        elevation: elevation,
        // shadowColor: shadowColor ?? context.theme.background50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          side: side,
        ),
        padding: padding,
      );
}
