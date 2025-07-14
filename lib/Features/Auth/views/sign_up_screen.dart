import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/Services/service_locator.dart';
import 'package:projects_two/Features/Auth/views/login_screen.dart';
import '../../../Core/api/api_state.dart';
import '../../../Core/constant/app_strings.dart';
import '../../../Core/utils/custom_snak_bar.dart';
import '../models/sign_up_param.dart';
import '../viewmodel/auth_provider.dart';
import 'widget/app_dropdown_form_field.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/app_text_button.dart';
import '../../../../core/widgets/app_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController roleController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late GlobalKey<FormState> _formKey;
  @override
  void initState() {
    firstNameController = TextEditingController(text: "kkkkkkkkk");
    lastNameController = TextEditingController(text: "mmmmmmmmm");
    emailController = TextEditingController(text: "kokoessa951@gmail.com");
    addressController = TextEditingController(text: "cairo");
    roleController = TextEditingController();
    passwordController = TextEditingController(text: "123456");
    confirmPasswordController = TextEditingController(text: "123456");
    _formKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthProvider>(),
      child: Consumer<AuthProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        AppStrings.createAnAccount.tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 20),
                      _buildFirstNameField(context),
                      SizedBox(height: 8),
                      _buildLastNameField(context),
                      SizedBox(height: 8),
                      _buildAddressField(context),
                      SizedBox(height: 8),
                      _buildRoleField(context),
                      SizedBox(height: 8),
                      _buildEmailField(context),
                      SizedBox(height: 8),
                      _buildPasswordField(context, provider),
                      SizedBox(height: 8),
                      _buildConfirmPasswordField(context, provider),
                      SizedBox(height: 20),
                      _buildSignUpButton(context, provider),
                      SizedBox(height: 20),
                      // _buildOrContinueWith(context),
                      // SizedBox(height: 24),
                      // _buildSocialLoginButtons(context),
                      // SizedBox(height: 32),
                      _buildLoginRedirect(context),
                      SizedBox(height: 20),
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

  Widget _buildFirstNameField(BuildContext context) {
    return AppTextFormField(
      controller: firstNameController,
      hintText: AppStrings.firstName.tr(),
      prefixIcon: Icons.person,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.firstNameError.tr();
        }
        return null;
      },
    );
  }

  Widget _buildLastNameField(BuildContext context) {
    return AppTextFormField(
      controller: lastNameController,
      hintText: AppStrings.lastName.tr(),
      prefixIcon: Icons.person,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.lastNameError.tr();
        }
        return null;
      },
    );
  }

  Widget _buildAddressField(BuildContext context) {
    return AppTextFormField(
      controller: addressController,
      hintText: AppStrings.address.tr(),
      prefixIcon: Icons.home,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.addressError.tr();
        }
        return null;
      },
    );
  }

  Widget _buildRoleField(BuildContext context) {
    return AppDropdownFormField<String>(
      items: [
        AppStrings.admin.tr(),
        AppStrings.user.tr(),
      ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      value: null,
      onChanged: (value) {
        setState(() {
          roleController.text = value!.toLowerCase();
        });
      },
      hintText: AppStrings.role.tr(),
      prefixIcon: Icons.person,
      validator: (value) {
        if (value == null) {
          return AppStrings.roleError.tr();
        }
        return null;
      },
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return AppTextFormField(
      controller: emailController,
      hintText: AppStrings.email.tr(),
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
      hintText: 'Password',
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
          provider.obscureText ? Icons.visibility_off : Icons.visibility,
          color: const Color(0xff676767),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField(
    BuildContext context,
    AuthProvider provider,
  ) {
    return AppTextFormField(
      controller: confirmPasswordController,
      hintText: AppStrings.confirmPassword.tr(),
      prefixIcon: Icons.lock,
      isObscureText: provider.obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.confirmPasswordError.tr();
        }
        if (value != passwordController.text) {
          return AppStrings.passwordsDoNotMatch.tr();
        }
        return null;
      },
      suffixIcon: IconButton(
        onPressed: provider.toggleObscureText,
        icon: Icon(
          provider.obscureText ? Icons.visibility_off : Icons.visibility,
          color: const Color(0xff676767),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context, AuthProvider provider) {
    return provider.state == ApiState.loading
        ? Center(child: const CircularProgressIndicator())
        : AppTextButton(
            buttonText: AppStrings.create.tr(),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await provider.signUp(
                  signUpParam: SignUpParam(
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    email: emailController.text.trim(),
                    address: addressController.text.trim(),
                    role: roleController.text.trim(),
                    password: passwordController.text.trim(),
                  ),
                );
                if (context.mounted) {
                  if (provider.state == ApiState.success) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
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

  Widget _buildLoginRedirect(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.iHaveAnAccount.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(width: 4.w),
        InkWell(
          onTap: () {
            firstNameController.clear();
            lastNameController.clear();
            emailController.clear();
            addressController.clear();
            roleController.clear();
            passwordController.clear();
            confirmPasswordController.clear();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text(
            AppStrings.login.tr(),
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
