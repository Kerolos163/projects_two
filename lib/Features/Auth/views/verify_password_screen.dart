import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../Core/Services/service_locator.dart';
import '../../../Core/api/api_state.dart';
import '../../../Core/constant/app_colors.dart';
import '../../../Core/constant/app_strings.dart';
import '../../../Core/utils/custom_snak_bar.dart';
import '../viewmodel/auth_provider.dart';
import 'reset_password_screen.dart';

class VerifyPasswordScreen extends StatefulWidget {
  const VerifyPasswordScreen({super.key, required this.email});
  final String email;

  @override
  State<VerifyPasswordScreen> createState() => _VerifyPasswordScreenState();
}

class _VerifyPasswordScreenState extends State<VerifyPasswordScreen> {
  final defaultPinTheme = PinTheme(
    width: 55,
    height: 55,
    textStyle: TextStyle(
      fontSize: 24,
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.primary),
      borderRadius: BorderRadius.circular(18),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (context) => getIt<AuthProvider>(),
        builder: (context, child) => Center(
          child: Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.checkYourEmail.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 28.sp,
                    ),
                  ),
                  SizedBox(height: 40),
                  Pinput(
                    autofocus: true,
                    closeKeyboardWhenCompleted: true,
                    keyboardType: TextInputType.number,
                    separatorBuilder: (index) => const SizedBox(width: 6),
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyDecorationWith(
                      border: Border.all(color: AppColors.primary, width: 1.5),
                      color: AppColors.primary.withAlpha((.2 * 255).toInt()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    length: 6,
                    onCompleted: (pin) async {
                      await provider.verifyPassword(resetCode: pin);
                      if (context.mounted) {
                        if (provider.state == ApiState.success) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ResetPasswordScreen(email: widget.email),
                            ),
                          );
                        } else {
                          customSnackBar(context, AppStrings.wrongCode.tr());
                        }
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  Text(
                    AppStrings.accountHolderName.tr(),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkWell(
                    onTap: () => provider.forgetPassword(email: widget.email),
                    borderRadius: BorderRadius.circular(8),
                    splashColor: AppColors.primary.withAlpha(
                      (.2 * 255).toInt(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        AppStrings.resend.tr(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
