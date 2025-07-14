import 'package:flutter/material.dart';

class PriceDetailRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isHighlight;
  final bool bold;
  final TextStyle? style;

  const PriceDetailRow({
    super.key,
    required this.title,
    required this.value,
    this.isHighlight = false,
    this.bold = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle =
        style ??
        TextStyle(
          color: isHighlight ? Colors.red : Colors.black,
          fontSize: 16,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style ?? Theme.of(context).textTheme.bodyLarge),
        Row(
          children: [
            if (!isHighlight) const Icon(Icons.euro, size: 18),
            const SizedBox(width: 4),
            Text(value, style: valueStyle),
          ],
        ),
      ],
    );
  }
}
