import 'package:flutter/material.dart';
import 'package:lombard/src/core/theme/resources.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController? searchController;
  const SearchWidget({
    super.key,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16), // Apply borderRadius using ClipRRect
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.muteGrey,
          borderRadius: BorderRadius.circular(16), // BorderRadius applied to the Container
        ),
        child: TextFormField(
          readOnly: true,
          controller: searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            isCollapsed: true,
            // prefixIcon: Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 12),
            //   child: SvgPicture.asset(
            //     Assets.icons.search.path,
            //   ),
            // ),
            hintText: 'Поиск',
            hintStyle: AppTextStyles.fs16w500.copyWith(color: AppColors.greyText),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: const TextStyle(
            color: Colors.black,
          ),
          textAlignVertical: TextAlignVertical.center,
          onTap: () {},
          onFieldSubmitted: (value) {
            if (value.isNotEmpty) {}
          },
        ),
      ),
    );
  }
}
