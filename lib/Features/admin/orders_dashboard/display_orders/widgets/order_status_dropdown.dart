import 'package:flutter/material.dart';

class OrderStatusDropdown extends StatelessWidget {
  final String selectedStatus;
  final List<String> statusOptions;
  final ValueChanged<String> onChanged;

  const OrderStatusDropdown({
    super.key,
    required this.selectedStatus,
    required this.statusOptions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Text(
            "Filter by status:",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: selectedStatus,
            style: Theme.of(context).textTheme.bodyLarge,
            items: statusOptions.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Text(
                  status[0].toUpperCase() + status.substring(1),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) onChanged(value);
            },
          ),
        ],
      ),
    );
  }
}
