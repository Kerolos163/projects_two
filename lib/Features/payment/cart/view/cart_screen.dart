import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/Services/service_locator.dart';
import 'package:projects_two/Core/Theme/app_provider.dart';
import 'package:projects_two/Core/constant/app_colors.dart';
import 'package:projects_two/Features/payment/cart/logic/cart_provider.dart';
import 'package:projects_two/Features/payment/cart/logic/stripe_payment_provider.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/cart_haader.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/cart_item.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/payment_method_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<CartProvider>()..loadCartData(),
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Consumer<AppProvider>(
                  builder: (context, provider, child) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: CartHeader(
                        onMenuTap: () =>
                            provider.scaffoldKey.currentState?.openDrawer(),
                        onAvatarTap: () => provider.changeIndex(index: 4),
                      ),
                    );
                  },
                ),

                Expanded(
                  child: Consumer<CartProvider>(
                    builder: (context, provider, child) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: provider.cartItems.isEmpty
                            ? SizedBox(
                                height: 300.h,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.shopping_cart_outlined,
                                        size: 64,
                                        color: AppColors.grey400,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "Your cart is empty",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors.grey600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.all(16),
                                itemCount: provider.cartItems.length,
                                itemBuilder: (context, index) {
                                  final product = provider.cartItems[index];
                                  return CartItem(
                                    isEven: index.isEven,
                                    model: product,
                                    onIncrease: () {
                                      provider.increaseQuantity(product);
                                    },
                                    onDecrease: () {
                                      provider.decreaseQuantity(product);
                                    },
                                    onRemove: () {
                                      provider.removeFromCart(product);
                                    },
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ),

                Consumer<CartProvider>(
                  builder: (context, provider, child) =>
                      provider.cartItems.isNotEmpty
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: Offset(0, -5),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.grey600,
                                    ),
                                  ),
                                  Consumer<CartProvider>(
                                    builder: (context, provider, child) {
                                      return Text(
                                        '${provider.totalPrice.toStringAsFixed(2)} EGP',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 24),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                        ),
                                        context: context,
                                        builder: (_) => MultiProvider(
                                          providers: [
                                            ChangeNotifierProvider.value(
                                              value: Provider.of<CartProvider>(
                                                context,
                                                listen: false,
                                              ),
                                            ),
                                            ChangeNotifierProvider(
                                              create: (_) =>
                                                  StripePaymentProvider(),
                                            ),
                                          ],
                                          child:
                                              const PaymentMethodBottomSheet(),
                                        ),
                                      );
                                    },
                                    child: Text('Payment'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
