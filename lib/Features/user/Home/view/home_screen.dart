import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Services/service_locator.dart';
import '../../../../Core/constant/app_strings.dart';
import 'widget/category_list_view.dart';
import 'widget/container_products.dart';
import 'widget/products_list.dart';
import '../viewmodel/home_provider.dart';
import 'package:provider/provider.dart';

import '../../../../Core/Theme/app_provider.dart';
import '../../../../Core/api/api_state.dart';
import '../../../../Core/constant/app_colors.dart';
import '../../../../Core/widgets/home_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<AppProvider>(context, listen: false).getRecentlyViewed();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<HomeProvider>()..loadHomeData(),
      builder: (context, child) => Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return Scaffold(
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: HomeHeader(
                    readOnly: true,
                    onTap: () => appProvider.changeIndex(index: 1),
                    onMenuTap: () =>
                        appProvider.scaffoldKey.currentState?.openDrawer(),
                    onAvatarTap: () => appProvider.changeIndex(index: 4),
                  ),
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
                        child: Consumer<AppProvider>(
                          builder: (context, appProvider, child) {
                            return CategoryListView(
                              appProvider: appProvider,
                              items: provider.state == ApiState.loading
                                  ? []
                                  : provider.categories,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                appProvider.recentlyViewed.isEmpty
                    ? SizedBox()
                    : ProductsList(
                      appProvider: appProvider,
                      products: appProvider.recentlyViewed
                          .map((e) => e.recentlyViewed)
                          .toList(),
                    ),
                const SizedBox(height: 20),
                Consumer<HomeProvider>(
                  builder: (context, provider, child) {
                    return ProductsList(
                      appProvider: appProvider,
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
                const SizedBox(height: 20),
                Consumer<HomeProvider>(
                  builder: (context, provider, child) {
                    return ProductsList(
                      appProvider: appProvider,
                      products: provider.products.skip(3).toList(),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}
