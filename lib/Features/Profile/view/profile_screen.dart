import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/Services/service_locator.dart';
import 'package:provider/provider.dart';

import '../../../Core/api/api_state.dart';
import '../../../Core/constant/app_colors.dart';
import '../../../Core/constant/app_strings.dart';
import '../../../Core/widgets/custom_text_form_field.dart';
import '../viewmodel/profile_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProfileProvider>(
      create: (context) => getIt<ProfileProvider>()..getUserInfo(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          centerTitle: true,
          title: Text(
            AppStrings.profile.tr(),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            return profileProvider.state == ApiState.loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 48.r,
                              child: Image.asset(
                                "assets/image/profile.png",
                                width: 96.w,
                                height: 96.h,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 16.r,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 14.r,
                                  backgroundColor: AppColors.primary,
                                  child: Icon(
                                    Icons.edit,
                                    size: 16.sp,
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28),
                      Text(
                        AppStrings.peronalDetails.tr(),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      SizedBox(height: 20),

                      CustomTextFormField(
                        label: AppStrings.firstName.tr(),
                        onChanged: (value) {
                          if (profileProvider.userModel.fName != value) {
                            profileProvider.setUpdateValue(true);
                          } else {
                            profileProvider.setUpdateValue(false);
                          }
                        },
                        placeholder: AppStrings.enterYourFirstName.tr(),
                        controller: profileProvider.firstNameController,
                      ),
                      CustomTextFormField(
                        label: AppStrings.lastName.tr(),
                        onChanged: (value) {
                          if (profileProvider.userModel.lName != value) {
                            profileProvider.setUpdateValue(true);
                          } else {
                            profileProvider.setUpdateValue(false);
                          }
                        },
                        placeholder: AppStrings.enterYourLastName.tr(),
                        controller: profileProvider.lastNameController,
                      ),
                      CustomTextFormField(
                        label: AppStrings.address.tr(),
                        onChanged: (value) {
                          if (profileProvider.userModel.address != value) {
                            profileProvider.setUpdateValue(true);
                          } else {
                            profileProvider.setUpdateValue(false);
                          }
                        },
                        placeholder: AppStrings.enterYourAddress.tr(),
                        controller: profileProvider.addressController,
                      ),
                      CustomTextFormField(
                        label: AppStrings.emailAddress.tr(),
                        onChanged: (value) {
                          if (profileProvider.userModel.email != value) {
                            profileProvider.setUpdateValue(true);
                          } else {
                            profileProvider.setUpdateValue(false);
                          }
                        },
                        controller: profileProvider.emailController,
                        placeholder: AppStrings.enterYourEmail.tr(),
                      ),
                      CustomTextFormField(
                        label: AppStrings.password.tr(),
                        onChanged: (value) {
                          if (profileProvider
                              .passwordController
                              .text
                              .isNotEmpty) {
                            profileProvider.setUpdateValue(true);
                          }
                          else{
                            profileProvider.setUpdateValue(false);
                          }
                        },
                        placeholder: AppStrings.enterYourPassword.tr(),
                        obscureText: true,
                        controller: profileProvider.passwordController,
                      ),
                      SizedBox(height: 24.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: profileProvider.update
                            ? () async {
                                await profileProvider.updateUser();
                              }
                            : null,
                        child: Text(
                          AppStrings.save.tr(),
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
