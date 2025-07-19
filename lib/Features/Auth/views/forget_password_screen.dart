import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../Core/Services/service_locator.dart';
import '../../../Core/api/api_state.dart';
import '../../../Core/constant/app_colors.dart';
import '../../../Core/constant/app_strings.dart';
import '../../../Core/utils/custom_snak_bar.dart';
import '../../../Core/widgets/app_text_form_field.dart';
import '../viewmodel/auth_provider.dart';
import 'verify_password_screen.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController emailController;
  late GlobalKey<FormState> _formKey;
  @override
  void initState() {
    emailController = TextEditingController(text: "kokoessa951@gmail.com");
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (context) => getIt<AuthProvider>(),
      builder: (context, child) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Text(
                  AppStrings.forgetPassword.tr(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 30),
                AppTextFormField(
                  hintText: AppStrings.enterYourEmail.tr(),
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppStrings.emailEmpty.tr();
                    }
                    bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value);
                    if (!emailValid) {
                      return AppStrings.enterValidEmail.tr();
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
                                await authProvider.forgetPassword(
                                  email: emailController.text.trim(),
                                );
                                if (context.mounted) {
                                  if (authProvider.state == ApiState.success) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VerifyPasswordScreen(
                                              email: emailController.text
                                                  .trim(),
                                            ),
                                      ),
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
                            child: Text(AppStrings.send.tr()),
                          );
                  },
                ),
                SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
