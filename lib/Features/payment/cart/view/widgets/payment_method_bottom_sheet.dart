import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_state.dart';
import 'package:projects_two/Core/constant/payment_methods.dart';
import 'package:projects_two/Features/payment/cart/data/model/payment_intent_input_model.dart';
import 'package:projects_two/Features/payment/cart/logic/cart_provider.dart';
import 'package:projects_two/Features/payment/cart/logic/stripe_payment_provider.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/payment_method.dart';
import 'package:projects_two/Features/payment/cart/view/widgets/payment_text_button.dart';
import 'package:provider/provider.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  const PaymentMethodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final stripeProvider = Provider.of<StripePaymentProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          PaymentMethods(
            onChanged: (int selectedIndex) {
              cartProvider.paymentMethodIndex = selectedIndex;
              print(cartProvider.paymentMethodIndex);
            },
          ),
          const SizedBox(height: 32),
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              return PaymentTextButton(
                buttonText: stripeProvider.state == ApiState.loading
                    ? "Processing..."
                    : cartProvider.paymentMethodIndex == 0
                    ? "Pay with card"
                    : "Pay COD",
                onPressed: stripeProvider.state == ApiState.loading
                    ? null
                    : () async {
                        final amount = (cartProvider.totalPrice * 100).toInt();
                        final inputModel = PaymentIntentInputModel(
                          amount: amount,
                          currency: 'EGP',
                        );

                        if (cartProvider.paymentMethodIndex == 0) {
                          await stripeProvider.makePayment(inputModel);

                          if (stripeProvider.state == ApiState.success) {
                            await cartProvider.addNewOrder(
                              paymentMethod: PaymentMethodsType.card,
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Payment Successful'),
                              ),
                            );
                            await cartProvider.clearCart();
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Payment Failed: ${stripeProvider.error}',
                                ),
                              ),
                            );
                          }
                        } else {
                          await cartProvider.addNewOrder(
                            paymentMethod: PaymentMethodsType.cod,
                          );
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Payment Successful')),
                          );
                          await cartProvider.clearCart();
                        }
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}
