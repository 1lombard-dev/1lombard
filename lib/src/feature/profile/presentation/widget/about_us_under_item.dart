import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lombard/src/core/constant/generated/assets.gen.dart';
import 'package:lombard/src/core/theme/resources.dart';

class AboutUsUnderItem extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const AboutUsUnderItem({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: AppColors.greyTextField,
        borderRadius: BorderRadius.all(Radius.circular(12)),
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
                Text(
                  title,
                  style: AppTextStyles.fs14w500,
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
