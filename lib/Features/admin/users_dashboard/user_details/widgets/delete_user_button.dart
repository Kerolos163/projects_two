import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Features/admin/users_dashboard/viewmodel/users_dashboard_provider.dart';
import 'package:provider/provider.dart';

class DeleteUserButton extends StatelessWidget {
  final String userId;

  const DeleteUserButton({super.key, required this.userId});

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppStrings.confirmDeletion.tr()),
        content: Text(AppStrings.confirmDeleteUser.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel.tr()),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await context.read<UserDashboardProvider>().deleteUser(
                id: userId,
              );
              Navigator.pop(context);
            },
            child: Text(
              AppStrings.yes.tr(),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _confirmDelete(context),
      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
      child: Text(AppStrings.deleteUser.tr()),
    );
  }
}
