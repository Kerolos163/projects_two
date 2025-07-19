// Tip model
typedef Tip = Map<String, dynamic>; // since it's empty object for now

// Automatic Payment Methods model
class AutomaticPaymentMethods {
  final bool? enabled;

  AutomaticPaymentMethods({this.enabled});

  factory AutomaticPaymentMethods.fromJson(Map<String, dynamic> json) =>
      AutomaticPaymentMethods(enabled: json['enabled'] as bool?);

  Map<String, dynamic> toJson() => {'enabled': enabled};
}

// Payment Method Options > Card
class PaymentMethodCard {
  final dynamic installments;
  final dynamic mandateOptions;
  final dynamic network;
  final String? requestThreeDSecure;

  PaymentMethodCard({
    this.installments,
    this.mandateOptions,
    this.network,
    this.requestThreeDSecure,
  });

  factory PaymentMethodCard.fromJson(Map<String, dynamic> json) =>
      PaymentMethodCard(
        installments: json['installments'],
        mandateOptions: json['mandate_options'],
        network: json['network'],
        requestThreeDSecure: json['request_three_d_secure'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'installments': installments,
    'mandate_options': mandateOptions,
    'network': network,
    'request_three_d_secure': requestThreeDSecure,
  };
}

// Payment Method Options > Link
class PaymentMethodLink {
  final dynamic persistentToken;

  PaymentMethodLink({this.persistentToken});

  factory PaymentMethodLink.fromJson(Map<String, dynamic> json) =>
      PaymentMethodLink(persistentToken: json['persistent_token']);

  Map<String, dynamic> toJson() => {'persistent_token': persistentToken};
}

// Wrapper for PaymentMethodOptions
class PaymentMethodOptions {
  final PaymentMethodCard? card;
  final PaymentMethodLink? link;

  PaymentMethodOptions({this.card, this.link});

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) =>
      PaymentMethodOptions(
        card: json['card'] != null
            ? PaymentMethodCard.fromJson(json['card'])
            : null,
        link: json['link'] != null
            ? PaymentMethodLink.fromJson(json['link'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'card': card?.toJson(),
    'link': link?.toJson(),
  };
}

// Amount Details
class AmountDetails {
  final Tip? tip;

  AmountDetails({this.tip});

  factory AmountDetails.fromJson(Map<String, dynamic> json) =>
      AmountDetails(tip: json['tip'] as Tip?);

  Map<String, dynamic> toJson() => {'tip': tip};
}

// Main PaymentIntent Model
class PaymentIntentModel {
  final String? id;
  final String? object;
  final int? amount;
  final int? amountCapturable;
  final AmountDetails? amountDetails;
  final int? amountReceived;
  final bool? livemode;
  final String? currency;
  final String? captureMethod;
  final String? clientSecret;
  final String? confirmationMethod;
  final int? created;
  final String? status;
  final AutomaticPaymentMethods? automaticPaymentMethods;
  final PaymentMethodOptions? paymentMethodOptions;
  final List<String>? paymentMethodTypes;

  PaymentIntentModel({
    this.id,
    this.object,
    this.amount,
    this.amountCapturable,
    this.amountDetails,
    this.amountReceived,
    this.livemode,
    this.currency,
    this.captureMethod,
    this.clientSecret,
    this.confirmationMethod,
    this.created,
    this.status,
    this.automaticPaymentMethods,
    this.paymentMethodOptions,
    this.paymentMethodTypes,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      PaymentIntentModel(
        id: json['id'] as String?,
        object: json['object'] as String?,
        amount: json['amount'] as int?,
        amountCapturable: json['amount_capturable'] as int?,
        amountDetails: json['amount_details'] != null
            ? AmountDetails.fromJson(json['amount_details'])
            : null,
        amountReceived: json['amount_received'] as int?,
        livemode: json['livemode'] as bool?,
        currency: json['currency'] as String?,
        captureMethod: json['capture_method'] as String?,
        clientSecret: json['client_secret'] as String?,
        confirmationMethod: json['confirmation_method'] as String?,
        created: json['created'] as int?,
        status: json['status'] as String?,
        automaticPaymentMethods: json['automatic_payment_methods'] != null
            ? AutomaticPaymentMethods.fromJson(
                json['automatic_payment_methods'],
              )
            : null,
        paymentMethodOptions: json['payment_method_options'] != null
            ? PaymentMethodOptions.fromJson(json['payment_method_options'])
            : null,
        paymentMethodTypes: (json['payment_method_types'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'object': object,
    'amount': amount,
    'amount_capturable': amountCapturable,
    'amount_details': amountDetails?.toJson(),
    'amount_received': amountReceived,
    'livemode': livemode,
    'currency': currency,
    'capture_method': captureMethod,
    'client_secret': clientSecret,
    'confirmation_method': confirmationMethod,
    'created': created,
    'status': status,
    'automatic_payment_methods': automaticPaymentMethods?.toJson(),
    'payment_method_options': paymentMethodOptions?.toJson(),
    'payment_method_types': paymentMethodTypes,
  };
}
