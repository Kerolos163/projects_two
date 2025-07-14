import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/Services/service_locator.dart';
import 'package:projects_two/Features/Auth/views/sign_up_screen.dart';
import '../../../Core/api/api_state.dart';
import '../../../Core/constant/app_strings.dart';
import '../../../Core/utils/custom_snak_bar.dart';
import 'package:provider/provider.dart';

import '../../../Core/widgets/app_text_form_field.dart';
import '../../../core/widgets/app_text_button.dart';
import '../../user/layout/view/layout_screen.dart';
import '../models/login_model.dart';
import '../viewmodel/auth_provider.dart';
import 'forget_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late GlobalKey<FormState> formKey;

  @override
  void initState() {
    usernameController = TextEditingController(text: "kokoessa951@gmail.com");
    passwordController = TextEditingController(text: "123456");
    formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthProvider>(),
      child: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: formKey,
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(height: 60),
                      Text(
                        AppStrings.welcome.tr(),
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 26),
                      _buildEmailField(context, provider),
                      const SizedBox(height: 16),
                      _buildPasswordField(context, provider),
                      const SizedBox(height: 8),
                      _buildForgotPassword(context),
                      const SizedBox(height: 24),
                      _buildLoginButton(context, provider),
                      // const SizedBox(height: 40),
                      // _buildOrContinueWith(context),
                      // const SizedBox(height: 24),
                      // _buildSocialLoginButtons(context),
                      const SizedBox(height: 30),
                      _buildSignUpRedirect(context),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmailField(BuildContext context, AuthProvider provider) {
    return AppTextFormField(
      controller: usernameController,
      hintText: AppStrings.enterYourEmail.tr(),
      prefixIcon: Icons.person,
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
    );
  }

  Widget _buildPasswordField(BuildContext context, AuthProvider provider) {
    return AppTextFormField(
      controller: passwordController,
      hintText: AppStrings.password.tr(),
      prefixIcon: Icons.lock,
      isObscureText: provider.obscureText,
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return AppStrings.passwordError.tr();
        }
        return null;
      },
      suffixIcon: IconButton(
        onPressed: provider.toggleObscureText,
        icon: Icon(
          provider.obscureText
              ? Icons.visibility_off_outlined
              : Icons.remove_red_eye,
          color: const Color(0xff676767),
        ),
      ),
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ForgetPasswordScreen()),
        ),
        child: Text(
          AppStrings.forgotPassword2.tr(),
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context, AuthProvider provider) {
    return provider.state == ApiState.loading
        ? Center(child: const CircularProgressIndicator())
        : AppTextButton(
            buttonText: AppStrings.login.tr(),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await provider.login(
                  loginModel: LoginModel(
                    email: usernameController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
                if (context.mounted) {
                  if (provider.state == ApiState.success) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LayoutScreen();
                          //ToDo check role
                          // return provider.userModel.role == AccountType.admin
                          //     ? DashboardScreen()
                          //     :  LayoutScreen();
                        },
                      ),
                      (route) => false,
                    );
                  } else if (provider.state == ApiState.error) {
                    customSnackBar(context, provider.errorMessage);
                  }
                }
              }
            },
          );
  }

  Widget _buildSignUpRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.createAccount.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(width: 4.w),
        InkWell(
          onTap: () {
            usernameController.clear();
            passwordController.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: Text(
            AppStrings.signUp.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.underline,
              color: const Color(0xffF83758),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
