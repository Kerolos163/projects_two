import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:projects_two/Core/api/api_service.dart';
import 'package:projects_two/Features/payment/cart/data/model/payment_intent_input_model.dart';
import 'package:projects_two/Features/payment/cart/data/model/payment_intent_model/payment_intent_model.dart';

import '../constant/secure_keys.dart';

class StripeService {
  final ApiService apiService = ApiService();

  // get paymentIntentInputModel => null;

  Future<PaymentIntentModel> createPaymentIntent(
    PaymentIntentInputModel paymentIntentInputModel,
  ) async {
    var response = await apiService.postStrip(
      url: 'https://api.stripe.com/v1/payment_intents',
      body: paymentIntentInputModel.toJson(),
      contentType: Headers.formUrlEncodedContentType,
      token: SecureKeys.stripSecretKey,
    );
    var paymentIntentModel = PaymentIntentModel.fromJson(response.data);
    return paymentIntentModel;
  }

  Future initPaymentSheet({required String paymentIntentClientSecret}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: 'Helmy',
      ),
    );
  }

  Future<bool> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true; // Payment succeeded
    } catch (e) {
      if (e is StripeException) {
        print('Stripe Exception: ${e.error.localizedMessage}');
      } else {
        print('Unknown error: $e');
      }
      return false; // Payment failed or cancelled
    }
  }

  Future<bool> makePayment({
    required PaymentIntentInputModel paymentIntentInputModel,
  }) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);
    await initPaymentSheet(
      paymentIntentClientSecret: paymentIntentModel.clientSecret!,
    );
    return await displayPaymentSheet();
  }
}
