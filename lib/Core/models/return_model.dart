import 'package:projects_two/Core/models/order_model.dart';
import 'package:projects_two/Core/models/product_model.dart';

class ReturnModel {
  String? id;
  OrderModel? order;
  List<ProductModel>? products;
  String? status;
  

  ReturnModel({
    this.id,
    this.order,
    this.products,
    this.status = 'pending',
  });

  factory ReturnModel.fromJson(Map<String, dynamic> json) {
    return ReturnModel(
      id: json['_id'],
      order: OrderModel.fromJson(json['orderId']),
      products: (json['products'] as List?)
          ?.map((p) => ProductModel.fromJson(p['pId']))
          .toList(),
      status: json['status'] ?? 'pending',
    );
  }
  
}