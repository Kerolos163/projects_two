import 'package:flutter/material.dart';
import 'package:projects_two/Core/Services/service_locator.dart';
import 'package:projects_two/Core/Theme/app_provider.dart';
import 'package:projects_two/Core/constant/app_colors.dart';
import 'package:projects_two/Features/payment/cart/logic/cart_provider.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/cart_haader.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/cart_info_item.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/cart_item.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/payment_method_bottom_sheet.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/total_price.dart';
import 'package:projects_two/core/widgets/app_text_button.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<CartProvider>()..loadCartData(),
      builder: (context, child) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: ListView(
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

                    Consumer<CartProvider>(
                      builder: (context, provider, child) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: provider.cartItems.isEmpty
                              ? Center(
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
                    const OrderInfoItem(
                      title: "Order Subtotal",
                      value: "42.97\$",
                    ),
                    const SizedBox(height: 3),
                    const OrderInfoItem(title: "Discount", value: "0\$"),
                    const SizedBox(height: 3),
                    const OrderInfoItem(title: "Sipping", value: "8\$"),
                    const Divider(
                      thickness: 2,
                      height: 34, //instead making sizedbox with height 17
                      color: Color(0xffc7c7c7),
                    ),
                    const TotalPrice(title: 'Total', value: r'$50.97'),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              AppTextButton(
                buttonText: "Complete Payment",
                onPressed: () => showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  context: context,
                  builder: (context) => const PaymentMethodBottomSheet(),
                  // builder: (context) => BlocProvider(
                  //       create: (context) =>
                  //           StripePaymentCubit(CheckoutRepoImpl()),
                  //       child: const PaymentMethodBottomSheet(),
                  //     ))
                  // Navigator.of(context).push(
                  // MaterialPageRoute(
                  //   builder: (context) => const PaymentDetailsScreen(),
                  // ),
                  // ),
                ),
              ),
              // CustomButton(
              //   title: 'Complete Payment',
              //   onTap: () => showModalBottomSheet(
              //     shape: const RoundedRectangleBorder(
              //       borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(16),
              //         topRight: Radius.circular(16),
              //       ),
              //     ),
              //     context: context,
              //     builder: (context) => BlocProvider(
              //       create: (context) => StripePaymentCubit(CheckoutRepoImpl()),
              //       child: const PaymentMethodBottomSheet(),
              //     ),
              //   ),
              //   // Navigator.of(context).push(
              //   // MaterialPageRoute(
              //   //   builder: (context) => const PaymentDetailsScreen(),
              //   // ),
              //   // ),
              // ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
