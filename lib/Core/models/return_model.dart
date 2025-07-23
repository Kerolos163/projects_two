import 'package:projects_two/Core/models/order_model.dart';
import 'package:projects_two/Core/models/product_model.dart';

class ReturnModel {
  String? id;
  final OrderModel? order;
  List<ProductModel>? products;
  String? status;


  ReturnModel({
    this.id,
    this.order,
    this.products,
    this.status = 'pending',
  });

  // factory ReturnModel.fromJson(Map<String, dynamic> json) {

  //   return ReturnModel(
  //     id: json['_id'],
  //     order: OrderModel.fromJson(json['orderId']),
  //     products: (json['products'] as List?)
  //         ?.map((p) => 
  //         ProductModel.fromJson(p['pId']))
  //         .toList(),
  //     status: json['status'] ?? 'pending',
  //   );
  // }
  
  // factory ReturnModel.fromJson(Map<String, dynamic> json) {
  //   return ReturnModel(
  //     id: json['_id'],
  //     order: OrderModel.fromJson(json['orderId']),
  //     products: (json['products'] as List?)
  //         ?.map((p) {
  //       final productJson = p['pId'];
  //       if (productJson is Map<String, dynamic>) {
  //         return ProductModel.fromJson(productJson);
  //       } else {
  //         // If only a String id is provided, create a minimal ProductModel with that id
  //         return ProductModel(
  //           id: productJson.toString(),
  //           title: '',
  //           slug: '',
  //           description: '',
  //           quantity: 0,
  //           sold: 0,
  //           price: 0,
  //           priceAfterDiscount: 0,
  //           colors: [],
  //           imageCover: '',
  //           images: [],
  //           category: const Category(id: '', name: '', categoryId: null),
  //           subCategories: [],
  //           ratingsAverage: '',
  //           ratingsQuantity: 0,
  //           createdAt: DateTime.now(),
  //           updatedAt: DateTime.now(),
  //         );
  //       }
  //     }).toList(),
  //
  //     status: json['status'] ?? 'pending',
  //   );
  // }
  factory ReturnModel.fromJson(Map<String, dynamic> json) {
  final order = OrderModel.fromJson(json['orderId']);

  // Get map of full product data from order
  final orderProductsMap = {
    for (var item in json['orderId']['products'])
      item['pId']['_id']: item['pId']
  };

  final returnProducts = (json['products'] as List?)?.map((p) {
    final pid = p['pId'];
    final fullProductJson = orderProductsMap[pid];
    return ProductModel.fromJson(fullProductJson);
  }).toList();

  return ReturnModel(
    id: json['_id'],
    order: order,
    products: returnProducts,
    status: json['status'] ?? 'pending',
  );
}

    final parsedId = json['_id']?.toString().trim();
    print('✅ Parsing ReturnModel with _id: $parsedId');
    return ReturnModel(
      id: json['_id']?.toString().trim(),


      order: json['orderId'] != null ? OrderModel.fromJson(json['orderId']) : null,
      products: (json['products'] as List<dynamic>?)
          ?.map((p) {
        final productJson = p['pId'];
        if (productJson is Map<String, dynamic>) {
          return ProductModel.fromJson(productJson);
        } else {
          return ProductModel(
            id: productJson.toString(),
            title: '',
            slug: '',
            description: '',
            quantity: 0,
            sold: 0,
            price: 0,
            priceAfterDiscount: 0,
            colors: [],
            imageCover: '',
            images: [],
            category: const Category(id: '', name: '', categoryId: null),
            subCategories: [],
            ratingsAverage: '',
            ratingsQuantity: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
        }
      })
          .toList(),
      status: json['status'] ?? 'pending',
    );
  }


}
