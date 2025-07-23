import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../Core/constant/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../Core/Theme/app_provider.dart';
import '../../../../Core/api/api_state.dart';
import '../../../../Core/widgets/home_header.dart';
import '../../product_details/view/product_details.dart';
import '../viewmodel/product_provider.dart';
import 'widget/product_item.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        return provider.state == ApiState.loading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: RefreshIndicator(
                  onRefresh: () => provider.getProducts(),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Consumer<AppProvider>(
                          builder: (context, appProvider, _) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: HomeHeader(
                                onChanged: (value) => provider
                                    .searchedProductsByText(text: value),
                                onMenuTap: () => appProvider
                                    .scaffoldKey
                                    .currentState
                                    ?.openDrawer(),
                                onAvatarTap: () =>
                                    appProvider.changeIndex(index: 3),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${AppStrings.showingResults.tr()} ${provider.filterName}",
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                              ),
                              PopupMenuButton(
                                icon: Icon(Icons.sort),
                                onSelected: (value) async {
                                  if (!context.mounted) return;
                                  if (value == 'price') {
                                    await provider.getSortedProducts('price');
                                  } else if (value == 'rating') {
                                    await provider.getSortedProducts(
                                      '-ratingsAverage',
                                    );
                                  } else if (value == 'both') {
                                    await provider.getSortedProducts(
                                      'price,ratingsAverage',
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'price',
                                    child: Text(AppStrings.sortByPrice.tr()),
                                  ),
                                  PopupMenuItem(
                                    value: 'rating',
                                    child: Text(AppStrings.sortByRating.tr()),
                                  ),
                                  PopupMenuItem(
                                    value: 'both',
                                    child: Text(
                                      AppStrings.sortByPriceAndRating.tr(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 20,
                        ),
                        sliver: SliverMasonryGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childCount: provider.searchedProducts.isNotEmpty
                              ? provider.searchedProducts.length
                              : provider.subCategoryProducts.isNotEmpty
                              ? provider.subCategoryProducts.length
                              : provider.displayedProducts.length,
                          itemBuilder: (context, index) {
                            final product = provider.searchedProducts.isNotEmpty
                                ? provider.searchedProducts[index]
                                : provider.subCategoryProducts.isNotEmpty
                                ? provider.subCategoryProducts[index]
                                : provider.displayedProducts[index];
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 160),
                              columnCount: 2,
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: Consumer<AppProvider>(
                                    builder: (context, appProvider, child) {
                                      return GestureDetector(
                                        onTap: () async {
                                          appProvider.addRecentlyViewed(
                                            product: product,
                                          );
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetails(
                                                    product: product,
                                                  ),
                                            ),
                                          );
                                        },
                                        child: ProductItem(
                                          index: index,
                                          productModel: product,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
