import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Core/constant/image.dart';
import 'package:projects_two/Features/admin/users_dashboard/user_details/widgets/delete_user_button.dart';
import 'package:projects_two/Features/admin/users_dashboard/user_details/widgets/role_drop_down.dart';
import 'package:projects_two/Features/admin/users_dashboard/user_details/widgets/user_avatar.dart';
import 'package:projects_two/Features/admin/users_dashboard/user_details/widgets/user_info_text_field.dart';
import 'package:projects_two/Core/models/user_model.dart';
import 'package:projects_two/Features/admin/users_dashboard/viewmodel/users_dashboard_provider.dart';
import 'package:provider/provider.dart';



class UserDetailsScreen extends StatefulWidget {
   final UserModel user;

   const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController idController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController avatarController;

  final List<String> roles = ['admin', 'user'];
  String? selectedRole;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.user.id);
    firstNameController = TextEditingController(text: widget.user.fName);
    lastNameController = TextEditingController(text: widget.user.lName);
    emailController = TextEditingController(text: widget.user.email);
    avatarController = TextEditingController(text: widget.user.avatar);
    selectedRole = widget.user.role;
  }

  Future<void> _submitRoleUpdate(UserDashboardProvider controller) async {
    if (_formKey.currentState!.validate()) {
      widget.user.role = selectedRole ?? widget.user.role;

      await controller.updateUser(
        id: widget.user.id,
        user: widget.user,
      );

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(AppStrings.success.tr()),
          content: Text(AppStrings.userRoleUpdated.tr()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(AppStrings.close.tr()),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  
    return Consumer<UserDashboardProvider>(
      builder: (context, controller, _) {
       return     Scaffold(
      appBar: AppBar(title: Text(AppStrings.userDetails.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              UserInfoTextField(label: AppStrings.userId.tr(), controller: idController),
              UserInfoTextField(label: AppStrings.firstName.tr(), controller: firstNameController),
              UserInfoTextField(label: AppStrings.lastName.tr(), controller: lastNameController),
              UserInfoTextField(label: AppStrings.email.tr(), controller: emailController),
              const SizedBox(height: 8),
              UserAvatar(image: widget.user.avatar?? ImagePath.avatar),
              RoleDropdown(
                selectedRole: selectedRole,
                roles: roles,
                onChanged: (val) => setState(() => selectedRole = val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _submitRoleUpdate(controller),
                child: Text(AppStrings.updateRole.tr()),
              ),
              const SizedBox(height: 12),
              DeleteUserButton(userId: widget.user.id),
            ],
          ),
        ),
      ),
    );
      },
    );
 }
}
