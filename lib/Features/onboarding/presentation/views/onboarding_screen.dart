import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/Services/preferences_manager.dart';
import '../../../../Core/constant/image.dart';
import '../../../../Core/utils/app_constants.dart';
import '../../../Auth/views/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> onboardingPages = [
    OnboardingPageData(
      image: ImagePath.onb1,
      title: 'Choose Products',
      description:
          'Browse our wide selection of products and find exactly what you need.',
    ),
    OnboardingPageData(
      image: ImagePath.onb2,
      title: 'Make Payment',
      description:
          'Secure and easy payment options for a hassle-free checkout.',
    ),
    OnboardingPageData(
      image: ImagePath.onb3,
      title: 'Get Your Order',
      description:
          'Fast delivery right to your doorstep. Track your order in real-time.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: PageView.builder(
        controller: _pageController,
        itemCount: onboardingPages.length,
        onPageChanged: (int page) {
          log('page: $page');
          setState(() => _currentPage = page);
        },
        itemBuilder: (context, index) =>
            OnboardingPageContent(data: onboardingPages[index]),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Center(
        child: Text(
          '${_currentPage + 1}/${onboardingPages.length}',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: _currentPage == onboardingPages.length - 1
                ? Colors.grey
                : Colors.black,
          ),
        ),
      ),
      actions: [
        if (_currentPage != onboardingPages.length - 1)
          TextButton(
            onPressed: getStart,
            child: Text(
              'Skip',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: _goToPreviousPage,
              child: Text(
                'Prev',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffC4C4C4),
                ),
              ),
            )
          else
            const SizedBox(width: 60), // Placeholder for alignment

          _buildPageIndicator(),

          TextButton(
            onPressed: _currentPage == onboardingPages.length - 1
                ? getStart
                : _goToNextPage,
            child: Text(
              _currentPage == onboardingPages.length - 1
                  ? 'Get Started'
                  : 'Next',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xffF83758),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getStart() {
    PreferencesManager.setBool(AppConstants.firstTime, false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        onboardingPages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: index == _currentPage ? 24.w : 8.w,
          height: 8.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: index == _currentPage
                ? const Color(0xffF83758)
                : const Color(0xffC4C4C4),
          ),
        ),
      ),
    );
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class OnboardingPageData {
  final String image;
  final String title;
  final String description;

  const OnboardingPageData({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingPageContent extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPageContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            data.image,
            height: 300.h,
            width: 297.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 40.h),
          Text(
            data.title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            data.description,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xffA8A8A9),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
