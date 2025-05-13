import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lombard/src/core/theme/resources.dart';

class MainRowContainer extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback? onTap;
  const MainRowContainer({
    super.key,
    required this.image,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE3E3E3),
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.only(left: 9, top: 5, bottom: 8, right: 9),
            child: Image.asset(
              image,
              height: 24,
              width: 24,
            ),
          ),
          const Gap(6),
          Text(
            title,
            style: AppTextStyles.fs16w500.copyWith(color: AppColors.black),
          ),
        ],
      ),
    );
  }
}
