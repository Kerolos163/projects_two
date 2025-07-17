import 'package:flutter/material.dart';

class CustomLabel extends StatelessWidget {
  final String text;
  const CustomLabel({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 16),
      child: Text(this.text, style: Theme.of(context).textTheme.displayMedium),
    );
  }
}
