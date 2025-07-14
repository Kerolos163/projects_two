import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.scaffoldBackground,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.black,
    primaryContainer: AppColors.white,
    outline: AppColors.black,
  ),
  brightness: Brightness.light,
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: AppColors.primary.withAlpha((0.2 * 255).toInt()),
    cursorColor: AppColors.primary,
    selectionHandleColor: AppColors.primary,
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: 18.sp,
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
      fontFamily: "Montserrat",
    ),
    titleMedium: TextStyle(
      fontSize: 16.sp,
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
      fontFamily: "Montserrat",
    ),
    labelLarge: TextStyle(
      fontSize: 14.sp,
      color: AppColors.primary,
      fontWeight: FontWeight.w400,
      fontFamily: "Montserrat",
    ),
    labelMedium: TextStyle(
      fontSize: 12.sp,
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
      fontFamily: "Montserrat",
    ),
    displayLarge: TextStyle(
      fontSize: 16.sp,
      color: AppColors.textPrimary,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w500,
    ),
    displayMedium: TextStyle(
      fontSize: 12.sp,
      color: AppColors.textPrimary,
      fontFamily: "Montserrat",
    ),
    headlineLarge: TextStyle(
      fontSize: 18.sp,
      color: AppColors.textPrimary,
      fontWeight: FontWeight.w600,
      fontFamily: "Montserrat",
    ),
    displaySmall: TextStyle(
      fontSize: 13.sp,
      color: AppColors.textPrimary,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w600,
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.black,
    selectedLabelStyle: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      fontFamily: "Roboto",
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      fontFamily: "Roboto",
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
      textStyle: const TextStyle(fontFamily: "Plus Jakarta Sans", fontSize: 15),
    ),
  ),
  // elevatedButtonTheme: ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(
  //     backgroundColor: AppColors.primaryButton,
  //     foregroundColor: Colors.white,
  //     minimumSize: Size(double.infinity, 56.h),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
  //     textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
  //   ),
  // ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: Color(0xFF971A1A),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
      textStyle: const TextStyle(fontFamily: "Plus Jakarta Sans", fontSize: 15),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.textfieldBackground,
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.textTertiary, width: 1.3),
      borderRadius: BorderRadius.circular(10.r),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.primary, width: 1.3),
      borderRadius: BorderRadius.circular(10.r),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 1.3),
      borderRadius: BorderRadius.circular(10.r),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.red, width: 1.3),
      borderRadius: BorderRadius.circular(10.r),
    ),
    hintStyle: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.textSecondary,
    ),
  ),

  // Add text button theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
    ),
  ),
);
