import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentTextButton extends StatelessWidget {
  final String buttonText;
  final Future<void> Function()? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;

  const PaymentTextButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
        ),
        child: Text(buttonText, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}
