import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../constant/app_colors.dart';
import '../constant/app_strings.dart';
import '../constant/image.dart';
import 'svg_img.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
  });
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withAlpha((.15 * 255).toInt()),
            blurRadius: 38,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onTap: onTap,
        readOnly: readOnly,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),

          filled: true,
          fillColor: AppColors.white,
          hintText: AppStrings.searchAnyProduct.tr(),
          hintStyle: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppColors.textDisabled),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: SVGImage(path: ImagePath.searchIcon2),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 36,
            minHeight: 36,
          ),
          // suffixIcon: Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          //   child: SVGImage(path: ImagePath.micIcon),
          // ),
          border: borderBuilder(),
          focusedBorder: borderBuilder(),
          enabledBorder: borderBuilder(),
        ),
      ),
    );
  }

  OutlineInputBorder borderBuilder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide.none,
    );
  }
}
