import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/theme/resources.dart';

class ProfilePageItem extends StatelessWidget {
  final String prefixIcon;
  final String text;
  final void Function()? onTap;

  const ProfilePageItem({
    super.key,
    required this.prefixIcon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lineGray),
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(prefixIcon),
                    const Gap(10),
                    Text(
                      text,
                      style: AppTextStyles.fs14w500,
                    ),
                  ],
                ),
                SvgPicture.asset(Assets.icons.down.path),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
