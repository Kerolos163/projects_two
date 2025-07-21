import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../../Core/api/api_state.dart';
import '../../../../Core/utils/delete_dialog.dart';
import 'widget/favorite_item.dart';
import '../../product_details/view/product_details.dart';
import 'package:provider/provider.dart';

import '../../../../Core/Services/service_locator.dart';
import '../../../../Core/constant/app_colors.dart';
import '../../../../Core/constant/app_strings.dart';
import '../viewmodel/favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavoriteProvider>(
      create: (context) => getIt<FavoriteProvider>()..getFavoriteList(),
      builder: (context, child) => Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.white,
              centerTitle: true,
              title: Text(
                AppStrings.favorites.tr(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            body: Builder(
              builder: (context) {
                final state = favoriteProvider.state;
                final list = favoriteProvider.favoriteList;
                if (state == ApiState.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state == ApiState.error) {
                  return Center(
                    child: Text(
                      'Something went wrong!',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: AppColors.red),
                    ),
                  );
                }

                if (list.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 100,
                          color: AppColors.secondary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favorites yet!',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: AppColors.secondary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start adding items to your favorites',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.secondary.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 160),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                  product: favoriteProvider.favoriteList[index],
                                ),
                              ),
                            );
                            log('result: $result');
                            if (result == 'refresh' && context.mounted) {
                              favoriteProvider.getFavoriteList();
                            }
                          },
                          child: FavoriteItem(
                            isEven: index % 2 == 0,
                            model: favoriteProvider.favoriteList[index],
                            onTap: () async {
                              final scaffoldMessenger = ScaffoldMessenger.of(
                                context,
                              );
                              final currentContext = context;
                              final removedItem =
                                  favoriteProvider.favoriteList[index];

                              final confirmed =
                                  await showDeleteConfirmationDialog(context);
                              if (confirmed != true) return;

                              final removedItemId = removedItem.id;
                              final snackBarKey =
                                  GlobalKey<ScaffoldMessengerState>();

                              favoriteProvider.favoriteList.removeAt(index);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!currentContext.mounted) return;

                                scaffoldMessenger
                                    .showSnackBar(
                                      SnackBar(
                                        key: snackBarKey,
                                        backgroundColor: AppColors.secondary,
                                        content: const Text(
                                          'Item removed from favorites.',
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          textColor: AppColors.white,
                                          onPressed: () async {
                                            await favoriteProvider
                                                .addToFavorite(
                                                  productId: removedItemId,
                                                );
                                            favoriteProvider.getFavoriteList();
                                          },
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        duration: const Duration(seconds: 5),
                                      ),
                                    );
                              });
                              await Future.delayed(
                                const Duration(milliseconds: 300),
                              );
                              await favoriteProvider.removeFromFavorite(
                                productId: removedItemId,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 14),
                  itemCount: favoriteProvider.favoriteList.length,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
