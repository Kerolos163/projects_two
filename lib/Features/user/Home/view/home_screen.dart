import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../Core/constant/app_strings.dart';
import 'widget/category_list_view.dart';
import 'widget/container_products.dart';
import 'widget/products_list.dart';
import '../viewmodel/home_provider.dart';
import 'package:provider/provider.dart';

import '../../../../Core/Theme/app_provider.dart';
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
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Consumer<HomeProvider>(
          builder: (context, homeProvider, child) {
            return Scaffold(
              body: RefreshIndicator(
                onRefresh: () => homeProvider.loadHomeData(),
                child: ListView(
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.allFeatured.tr(),
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.sort),
                            onSelected: (value) {
                              if (value == 'price') {
                                homeProvider.getSortedProducts('price');
                              } else if (value == 'rating') {
                                homeProvider.getSortedProducts(
                                  'ratingsAverage',
                                );
                              } else if (value == 'both') {
                                homeProvider.getSortedProducts(
                                  'price,ratingsAverage',
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'price',
                                child: Text('Sort by Price'),
                              ),
                              PopupMenuItem(
                                value: 'rating',
                                child: Text('Sort by Rating'),
                              ),
                              PopupMenuItem(
                                value: 'both',
                                child: Text('Sort by Price & Rating'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Consumer<AppProvider>(
                          builder: (context, appProvider, child) {
                            return CategoryListView(
                              appProvider: appProvider,
                              items: homeProvider.categories,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    appProvider.recentlyViewed.isEmpty
                        ? SizedBox()
                        : ProductsList(
                          showRatings: false,
                            title: AppStrings.recentlyViewed.tr(),
                            appProvider: appProvider,
                            products: appProvider.recentlyViewed
                                .map((e) => e.recentlyViewed)
                                .toList()
                                .reversed
                                .toList(),
                          ),
                    const SizedBox(height: 20),
                    homeProvider.trandingProducts.isEmpty
                        ? SizedBox()
                        : ProductsList(
                            title: AppStrings.trendingProduct.tr(),
                            appProvider: appProvider,
                            products: homeProvider.trandingProducts,
                          ),
                    const SizedBox(height: 20),
                    homeProvider.bestSellersProducts.isEmpty
                        ? SizedBox()
                        : ProductsList(
                            title: AppStrings.bestSellers.tr(),
                            appProvider: appProvider,
                            products: homeProvider.bestSellersProducts,
                          ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ProductContainer(
                        btntext: AppStrings.viewAll.tr(),
                        colorr: AppColors.primary,
                        textt: AppStrings.otherProducts.tr(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ProductsList(
                      title: "",
                      appProvider: appProvider,
                      products: homeProvider.products.take(4).toList(),
                    ),
                    const SizedBox(height: 20),

                    ProductsList(
                      title: "",
                      appProvider: appProvider,
                      products: homeProvider.products.skip(3).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
