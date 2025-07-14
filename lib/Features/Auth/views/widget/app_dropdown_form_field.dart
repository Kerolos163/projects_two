import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDropdownFormField<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;

  const AppDropdownFormField({
    super.key,
    required this.items,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.value,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      validator: validator,
      onChanged: onChanged,
      items: items,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20.w) : null,
        suffixIcon: suffixIcon,
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }
}
