import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Features/admin/categories_dashboard/Category_Details/View/category_details_screen.dart';
import 'package:projects_two/Features/admin/categories_dashboard/add_category/add_category_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../Core/constant/app_colors.dart';
import '../../../../../Core/constant/app_strings.dart';
import '../../viewmodel/categories_dashboard_provider.dart';

class DashboardDisplayCategoriesScreen extends StatefulWidget {
  const DashboardDisplayCategoriesScreen({super.key});

  @override
  State<DashboardDisplayCategoriesScreen> createState() =>
      _DashboardDisplayCategoriesScreenState();
}

class _DashboardDisplayCategoriesScreenState
    extends State<DashboardDisplayCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesDashboardProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppStrings.categories.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            centerTitle: true,
            backgroundColor: AppColors.white,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangeNotifierProvider.value(
                        value: provider,
                        child: AddCategoryScreen(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.categoriesWithSubs.isEmpty
              ? const Center(child: Text("List is empty"))
              : ListView.separated(
                  itemCount: provider.categoriesWithSubs.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final category = provider.categoriesWithSubs[index];

                    navigateToDetails() async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: provider,
                            child: CategoryDetailsScreen(category: category),
                          ),
                        ),
                      );
                      await provider.fetchCategoriesAndSubcategories();
                    }

                    return category.subcategories.isNotEmpty
                        ? ExpansionTile(
                            title: Text(
                              category.name,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            children: category.subcategories.map((sub) {
                              return ListTile(
                                title: Text(
                                  sub.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displayLarge,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                ),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ChangeNotifierProvider.value(
                                            value: provider,
                                            child: CategoryDetailsScreen(
                                              category: sub,
                                            ),
                                          ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          )
                        : ListTile(
                            title: Text(
                              category.name,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            trailing: const Icon(Icons.arrow_forward, size: 16),
                            onTap: navigateToDetails,
                          );
                  },
                ),
        );
      },
    );
  }
}
