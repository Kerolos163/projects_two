import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/api/api_state.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Core/constant/payment_methods.dart';
import 'package:projects_two/Core/widgets/custom_text_form_field.dart';
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
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: cartProvider.formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.h),
              CustomTextFormField(
                label: AppStrings.address,
                placeholder: AppStrings.enterYourAddress,
                controller: cartProvider.address,
                validator: (input) {
                  if (input == null || input.trim().isEmpty) {
                    return "Address cannot be empty";
                  }
                  return null;
                },
              ),

              // const SizedBox(height: 16),
              CustomTextFormField(
                label: AppStrings.city.tr(),
                placeholder: AppStrings.enterYourCity.tr(),
                controller: cartProvider.city,
                validator: (input) {
                  if (input == null || input.trim().isEmpty) {
                    return "City cannot be empty";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
              PaymentMethods(
                onChanged: (int selectedIndex) {
                  cartProvider.paymentMethodIndex = selectedIndex;
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
                            if (!cartProvider.formKey.currentState!
                                .validate()) {
                              return; // ⛔ Don't proceed if form is invalid
                            }
                            final amount = (cartProvider.totalPrice * 100)
                                .toInt();
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
                                const SnackBar(
                                  content: Text('Payment Successful'),
                                ),
                              );
                              await cartProvider.clearCart();
                            }
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
