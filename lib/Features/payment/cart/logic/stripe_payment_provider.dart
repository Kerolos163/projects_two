import 'package:flutter/material.dart';
import '../../../../Core/Services/stripe_service.dart';
import '../../../../Core/api/api_state.dart';
import '../data/model/payment_intent_input_model.dart';

class StripePaymentProvider extends ChangeNotifier {
  String message = '';

  final StripeService _stripeService = StripeService();
  ApiState state = ApiState.initial;
  String? error;

  Future<void> makePayment(PaymentIntentInputModel inputModel) async {
    state = ApiState.loading;
    notifyListeners();

    try {
      bool result = await _stripeService.makePayment(
        paymentIntentInputModel: inputModel,
      );
      if (result) {
        state = ApiState.success;
      } else {
        error = 'Payment cancelled or failed';
        state = ApiState.error;
      }
    } catch (e) {
      error = e.toString();
      state = ApiState.error;
    }

    notifyListeners();
  }
}
