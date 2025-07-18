import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
            body: ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemBuilder: (context, index) =>
                  AnimationConfiguration.staggeredList(
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
                            if (result == 'refresh') {
                              favoriteProvider.getFavoriteList();
                            }
                          },
                          child: FavoriteItem(
                            isEven: index % 2 == 0,
                            model: favoriteProvider.favoriteList[index],
                            onTap: () => favoriteProvider.removeToFavorite(
                              productId:
                                  favoriteProvider.favoriteList[index].id,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              separatorBuilder: (context, index) => SizedBox(height: 14),
              itemCount: favoriteProvider.favoriteList.length,
            ),
          );
        },
      ),
    );
  }
}
