import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/Services/service_locator.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Features/user/Home/view/widget/category_list_view.dart';
import 'package:projects_two/Features/user/Home/view/widget/container_products.dart';
import 'package:projects_two/Features/user/Home/view/widget/products_list.dart';
import 'package:projects_two/Features/user/Home/viewmodel/home_provider.dart';
import 'package:provider/provider.dart';

import '../../../../Core/Theme/app_provider.dart';
import '../../../../Core/api/api_state.dart';
import '../../../../Core/constant/app_colors.dart';
import '../../../../Core/widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      lazy: false,
      create: (_) => getIt<HomeProvider>()..loadHomeData(),
      builder: (context, child) => Scaffold(
        body: ListView(
          children: [
            Consumer<AppProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: HomeHeader(
                    readOnly: true,
                    onTap: () => provider.changeIndex(index: 1),
                    onMenuTap: () =>
                        provider.scaffoldKey.currentState?.openDrawer(),
                    onAvatarTap: () => provider.changeIndex(index: 4),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                AppStrings.allFeatured.tr(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CategoryListView(
                      items: provider.state == ApiState.loading
                          ? []
                          : provider.categories,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return ProductsList(
                  products: provider.products.take(4).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ProductContainer(
                btntext: "view all",
                colorr: AppColors.primary,
                textt: "Trending Products",
              ),
            ),
            const SizedBox(height: 5),
            Consumer<HomeProvider>(
              builder: (context, provider, child) {
                return ProductsList(
                  products: provider.products.skip(3).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
