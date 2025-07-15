import 'package:flutter/material.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/payment_method_item.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  final List<String> paymentMethodsItems = [
    'assets/image/card.svg',
    'assets/image/paypal.svg',
  ];

  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62,
      child: ListView.builder(
        itemCount: paymentMethodsItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              activeIndex = index;
              setState(() {});
            },
            child: PaymentMethodItem(
              isActive: activeIndex == index,
              image: paymentMethodsItems[index],
            ),
          ),
        ),
      ),
    );
  }
}
