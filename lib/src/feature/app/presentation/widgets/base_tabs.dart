import 'package:flutter/material.dart';
import 'package:lombard/src/core/theme/resources.dart';

class CustomTabWidget extends StatelessWidget {
  final String icon;
  final String activeIcon;
  final String title;
  final int currentIndex;
  final int tabIndex;
  const CustomTabWidget({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.currentIndex,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = tabIndex == currentIndex;

    Widget iconWidget = Image.asset(
      isActive ? activeIcon : icon,
      height: 36,
      width: 36,
    );

    // Смещаем иконку вниз, только если tabIndex == 1
    if (tabIndex == 1) {
      iconWidget = Transform.translate(
        offset: const Offset(0, 4), // немного вниз
        child: iconWidget,
      );
    }
    return Tab(
      text: title,
      iconMargin: const EdgeInsets.only(
        bottom: 8,
      ),
      icon: iconWidget,
    );
  }
}

class TabDotIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TopIndicatorBoxDark();
  }
}

class _TopIndicatorBoxDark extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Paint paint = Paint()
      // ..shader = const RadialGradient(
      //   colors: [
      //     AppLightColors.tabActive,
      //     AppLightColors.tabActive,
      //   ],
      // ).createShader(
      //   Rect.fromCircle(
      //     center: offset,
      //     radius: 10,
      //   ),
      // )
      ..color = AppColors.tabActive
      ..strokeWidth = 6
      ..isAntiAlias = true
      ..strokeCap = StrokeCap.round;

    final Offset circleOffset = offset + Offset(cfg.size!.width / 2, 3);
    canvas.drawCircle(circleOffset, 3, paint);
  }
}
