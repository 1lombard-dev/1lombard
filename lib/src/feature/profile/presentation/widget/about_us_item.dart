import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lombard/src/core/theme/resources.dart';

class AboutUsItem extends StatelessWidget {
  final String title;
  final String icon;
  final String subtitle;
  final void Function()? onTap;
  const AboutUsItem({
    super.key,
    required this.title,
    required this.icon,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: AppColors.greyTextField,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.fs14w600.copyWith(height: 1.7),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.fs14w400.copyWith(color: AppColors.grayText, height: 1.7),
                    ),
                  ],
                ),
                SvgPicture.asset(icon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
