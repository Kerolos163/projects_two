import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../Core/Services/service_locator.dart';
import '../../../../Core/constant/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../Core/Theme/app_provider.dart';
import '../../../../Core/api/api_state.dart';
import '../../../../Core/widgets/home_header.dart';
import '../../../Profile/view/profile_screen.dart';
import '../../product_details/view/product_details.dart';
import '../viewmodel/product_provider.dart';
import 'widget/product_item.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, this.categoryName = ""});
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          getIt<ProductProvider>()..getProducts(keyword: categoryName),
      builder: (context, child) => Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return provider.state == ApiState.loading
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
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
                                onAvatarTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ProfileScreen(),
                                  ),
                                ),
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
                          child: Text(
                            "${AppStrings.showingResults.tr()} ${provider.filterName}",
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        sliver: SliverMasonryGrid.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childCount: provider.searchedProducts.isNotEmpty
                              ? provider.searchedProducts.length
                              : provider.displayedProducts.length,
                          itemBuilder: (context, index) {
                            final product = provider.searchedProducts.isNotEmpty
                                ? provider.searchedProducts[index]
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
                                        onTap: () {
                                          appProvider.addRecentlyViewed(
                                            product: product,
                                          );
                                          Navigator.push(
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
                );
        },
      ),
    );
  }
}
