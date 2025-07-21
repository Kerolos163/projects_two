import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/constant/app_strings.dart';

class RoleDropdown extends StatelessWidget {
  final String? selectedRole;
  final List<String> roles;
  final void Function(String?) onChanged;

  const RoleDropdown({
    super.key,
    required this.selectedRole,
    required this.roles,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedRole ?? "admin",
      items: roles
          .map(
            (role) => DropdownMenuItem(
              value: role,
              child: Text(
                role,
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
      validator: (val) =>
          val == null ? AppStrings.requiredField.tr() : null,
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
