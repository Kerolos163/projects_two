import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../../../../Core/api/api_state.dart';
import '../../../../../Core/constant/app_strings.dart';
import '../../../../../Core/constant/payment_methods.dart';
import '../../../../../Core/widgets/custom_text_form_field.dart';
import '../../data/model/payment_intent_input_model.dart';
import '../../logic/cart_provider.dart';
import '../../logic/stripe_payment_provider.dart';
import 'payment_method.dart';
import 'payment_text_button.dart';
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
                placeholder: AppStrings.enterYourAddress.tr(),
                controller: cartProvider.address,
                validator: (input) {
                  if (input == null || input.trim().isEmpty) {
                    return AppStrings.addressCannotBeEmpty.tr();
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
                    return AppStrings.cityCannotBeEmpty.tr();
                  }
                  return null;
                },
              ),

              CustomTextFormField(
                label: "Copon (Optional)",
                placeholder: "Enter your copon",
                controller: cartProvider.copon,
                validator: (input) {
                  if (input == "cpn10" ||
                      input == "cpn15" ||
                      input == "cpn20" ||
                      input == "cpn5" ||
                      input == null ||
                      input.trim().isEmpty) {
                    return null;
                  }
                  print(input);

                  return "invalid copon";
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
                        ? AppStrings.processing.tr()
                        : cartProvider.paymentMethodIndex == 0
                        ? AppStrings.payWithCard.tr()
                        : AppStrings.payCOD.tr(),
                    onPressed: stripeProvider.state == ApiState.loading
                        ? null
                        : () async {
                            if (!cartProvider.formKey.currentState!
                                .validate()) {
                              return; // ⛔ Don't proceed if form is invalid
                            }
                            final amount = (cartProvider.finalPrice * 100)
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
                                await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset(
                                          'assets/image/successfully-done.json',
                                          width: 300,
                                          height: 300,
                                          repeat: true,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          AppStrings.paymentSuccessful.tr(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pop(); // Close dialog
                                          Navigator.of(
                                            context,
                                          ).pop(); // Close bottom sheet
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        child: Text(
                                          AppStrings.okay.tr(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                await cartProvider.clearCart();
                              } else {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Lottie.asset(
                                          'assets/image/cross-mark.json',
                                          width: 150,
                                          height: 150,
                                          repeat: true,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          AppStrings.paymentFaild.tr(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(
                                            context,
                                          ).pop(); // Close dialog
                                          Navigator.of(
                                            context,
                                          ).pop(); // Close bottom sheet
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text(
                                          AppStrings.okay.tr(),
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            } else {
                              await cartProvider.addNewOrder(
                                paymentMethod: PaymentMethodsType.cod,
                              );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    AppStrings.paymentSuccessful.tr(),
                                  ),
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
