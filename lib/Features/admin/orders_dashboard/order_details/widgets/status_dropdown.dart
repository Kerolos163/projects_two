import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/constant/app_strings.dart';

class StatusDropdown extends StatelessWidget {
  final String? value;
  final void Function(String?) onChanged;

  const StatusDropdown({super.key, required this.value, required this.onChanged});

  static const statuses = [
    "fulfilled",
    "shipping",
    "rejected",
    "refunded",
    "pending"
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
