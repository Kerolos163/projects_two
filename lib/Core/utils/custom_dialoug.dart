import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/constant/app_strings.dart';

void showCustomDialog(BuildContext context, String title, String message, {VoidCallback? onClose}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            if (onClose != null) onClose();
          },
          child: Text(AppStrings.close.tr()),
        ),
      ],
    ),
  );
}
