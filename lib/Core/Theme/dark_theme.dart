import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
    primary: AppColors.primary,
    secondary: Colors.white70,
    primaryContainer: AppColors.black,
    outline: AppColors.white
  ),
  scaffoldBackgroundColor: Colors.black,
  textSelectionTheme: TextSelectionThemeData(
    selectionColor: AppColors.primary.withAlpha((0.3 * 255).toInt()),
    cursorColor: AppColors.primary,
    selectionHandleColor: AppColors.primary,
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: 18.sp,
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontFamily: "Montserrat",
    ),
    titleMedium: TextStyle(
      fontSize: 16.sp,
      color: Colors.white,
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
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontFamily: "Montserrat",
    ),
    displayLarge: TextStyle(
      fontSize: 16.sp,
      color: Colors.white,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w500,
    ),
    displayMedium: TextStyle(
      fontSize: 12.sp,
      color: Colors.white70,
      fontFamily: "Montserrat",
    ),
    headlineLarge: TextStyle(
      fontSize: 18.sp,
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontFamily: "Montserrat",
    ),
    displaySmall: TextStyle(
      fontSize: 13.sp,
      color: Colors.white,
      fontFamily: "Montserrat",
      fontWeight: FontWeight.w600,
    ),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.black,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: Colors.white70,
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
    fillColor: Colors.grey[900],
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[700]!, width: 1.3),
      borderRadius: BorderRadius.circular(10.r),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 1.3),
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
      color: Colors.white54,
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
    ),
  ),
);
