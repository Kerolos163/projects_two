import 'package:flutter/material.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/payment_method.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  const PaymentMethodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          PaymentMethods(),
          SizedBox(height: 32),
          // CustomButtonBlocConsumer(),
        ],
      ),
    );
  }
}
