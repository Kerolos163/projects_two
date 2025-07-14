// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final bool obscureText;
  final String placeholder;
  final TextEditingController? controller;
  // {bool obscureText = false}
  const CustomTextFormField({
    super.key,
    this.controller,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.displayMedium),
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: TextFormField(
            controller: controller,
            onTapUpOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            obscureText: obscureText,
            initialValue: hintText,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.textfieldBackground,
              hint: Text(placeholder),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
