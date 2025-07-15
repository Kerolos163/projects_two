import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/cart_info_item.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/payment_method_bottom_sheet.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/total_price.dart';
import 'package:projects_two/core/widgets/app_text_button.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: SizedBox()),
          const OrderInfoItem(title: "Order Subtotal", value: "42.97\$"),
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
  }
}
