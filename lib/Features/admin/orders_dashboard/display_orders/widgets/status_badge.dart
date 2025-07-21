import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _getColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getColor(String status) {
    switch (status) {
      case 'fulfilled':
        return Colors.green;
      case 'shipping':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'refunded':
        return Colors.orange;
      case 'pending':
      default:
        return Colors.grey;
    }
  }
}
