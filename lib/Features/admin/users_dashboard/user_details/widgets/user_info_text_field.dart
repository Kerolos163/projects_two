import 'package:flutter/material.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_label.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_textfield.dart';

class UserInfoTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const UserInfoTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomLabel(text: label),
        CustomTextfield(
          controller: controller,
          hint: '',
          enabled: false,
        ),
      ],
    );
  }
}
