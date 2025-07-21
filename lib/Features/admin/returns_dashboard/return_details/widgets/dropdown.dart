import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:projects_two/Core/constant/app_colors.dart';
import 'package:projects_two/Core/constant/app_strings.dart';

class ReturnStatusDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;

  const ReturnStatusDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const statuses = [
    "pending", "fulfilled", "rejected"
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: statuses
          .map((status) => DropdownMenuItem(
                value: status,
                child: Text(status, style: Theme.of(context).textTheme.displaySmall),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (val) => val == null ? AppStrings.requiredField.tr() : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
