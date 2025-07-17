

import 'package:projects_two/Core/models/product_model.dart';
import 'package:projects_two/Core/models/user_model.dart';

class OrderModel {
   int? oId;
  final String custId;
  UserModel? cust;
  final String paymentMethod;
  final List<OrderProduct> products;
  final DateTime? date;
  final String status;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  OrderModel({
     this.oId,
    required this.custId,
    this.cust,
    this.paymentMethod = 'COD',
    required this.products,
    this.date,
    this.status = 'pending',
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      oId: json['oId'] ?? 0,
      custId: json['custId'],
      paymentMethod: json['paymentMethod'] ?? 'COD',
      products: (json['products'] as List)
          .map((p) => OrderProduct.fromJson(p))
          .toList(),
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      status: json['status'] ?? 'pending',
      id: json['_id'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oId': oId,
      'custId': custId,
      'paymentMethod': paymentMethod,
      'products': products.map((p) => p.toJson()).toList(),
      'date': date?.toIso8601String(),
      'status': status,
      '_id': id,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class OrderProduct {
  final String pId;
  ProductModel? product;
  final int quantity;

  OrderProduct({
    required this.pId,
    required this.quantity,
    this.product,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      pId: json['pId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pId': pId,
      'quantity': quantity,
    };
  }
}
