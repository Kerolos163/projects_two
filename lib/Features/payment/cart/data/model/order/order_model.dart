class OrderModel {
  final int? oId;
  final String custId;
  final String paymentMethod;
  final List<OrderProduct> products;
  final String status;
  final DateTime? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
    this.oId,
    required this.custId,
    required this.paymentMethod,
    required this.products,
    required this.status,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      oId: json['oId'],
      custId: json['custId'],
      paymentMethod: json['paymentMethod'],
      products: (json['products'] as List)
          .map((item) => OrderProduct.fromJson(item))
          .toList(),
      status: json['status'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oId': oId,
      'custId': custId,
      'paymentMethod': paymentMethod,
      'products': products.map((e) => e.toJson()).toList(),
      'status': status,
      'date': date?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class OrderProduct {
  final String pId;
  final int quantity;

  OrderProduct({required this.pId, required this.quantity});

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(pId: json['pId'], quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    return {'pId': pId, 'quantity': quantity};
  }
}
