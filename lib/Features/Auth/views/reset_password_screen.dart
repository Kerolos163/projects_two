import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Features/Auth/views/login_screen.dart';
import '../../../Core/Services/service_locator.dart';
import '../../../Core/api/api_state.dart';
import '../../../Core/constant/app_colors.dart';
import '../../../Core/constant/app_strings.dart';
import '../../../Core/utils/custom_snak_bar.dart';
import '../../../Core/widgets/app_text_form_field.dart';
import 'package:provider/provider.dart';

import '../models/login_model.dart';
import '../viewmodel/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email});
  final String email;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late TextEditingController passwordController;
  late GlobalKey<FormState> _formKey;
  @override
  void initState() {
    passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => getIt<AuthProvider>(),
      builder: (context, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Spacer(),
                    Text(
                      AppStrings.resetPassword.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 30),
                    AppTextFormField(
                      controller: passwordController,
                      hintText: AppStrings.newPassword.tr(),
                      isObscureText: authProvider.obscureText,
                      suffixIcon: IconButton(
                        onPressed: authProvider.toggleObscureText,
                        icon: Icon(
                          authProvider.obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.remove_red_eye,
                          color: const Color(0xff676767),
                        ),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return AppStrings.passwordError.tr();
                        }
                        return null;
                      },
                    ),
                    Spacer(),
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return authProvider.state == ApiState.loading
                            ? Center(child: const CircularProgressIndicator())
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await authProvider.resetPassword(
                                      loginModel: LoginModel(
                                        email: widget.email,
                                        password: passwordController.text
                                            .trim(),
                                      ),
                                    );
                                    if (context.mounted) {
                                      if (authProvider.state ==
                                          ApiState.success) {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                          (route) => false,
                                        );
                                      } else {
                                        customSnackBar(
                                          context,
                                          authProvider.errorMessage,
                                        );
                                      }
                                    }
                                  }
                                },
                                child: Text(AppStrings.resetPassword.tr()),
                              );
                      },
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
