import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Features/admin/products_dashboard/display_products/widgets/product_card.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../Core/constant/app_colors.dart';
import '../../../../../../../../Core/constant/app_strings.dart';
import '../../add_product/view/add_product_screen.dart';
import '../../viewmodel/products_dashboard_provider.dart';

class DashboardDisplayProductsScreen extends StatefulWidget {
  const DashboardDisplayProductsScreen({super.key});

  @override
  State<DashboardDisplayProductsScreen> createState() =>
      _DashboardDisplayProductsScreenState();
}

class _DashboardDisplayProductsScreenState
    extends State<DashboardDisplayProductsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsDashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        } else if (provider.products.isEmpty) {
          return Center(child: Text(AppStrings.noProducts.tr()));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppStrings.products.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            backgroundColor: AppColors.white,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        provider.getCategories();
                        return ChangeNotifierProvider.value(
                          value: provider,
                          child: const AddProductScreen(),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: provider.products.length,
              itemBuilder: (context, index) {
                final product = provider.products[index];
                return ProductCard(product: product, provider: provider);
              },
            ),
          ),
        );
      },
    );
  }
}
