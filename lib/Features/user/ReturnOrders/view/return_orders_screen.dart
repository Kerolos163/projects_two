import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projects_two/Core/api/api_end_points.dart';
import 'package:projects_two/Core/models/order_model.dart';

import '../../../../Core/constant/app_colors.dart';
import '../../../../Core/constant/app_strings.dart';

class ReturnOrderScreen extends StatefulWidget {
  final OrderModel order;

  const ReturnOrderScreen({super.key, required this.order});

  @override
  State<ReturnOrderScreen> createState() => _ReturnOrderScreenState();
}

class _ReturnOrderScreenState extends State<ReturnOrderScreen> {
  final Set<String> selectedProductIds = {};

  Future<void> submitReturn() async {
    if (selectedProductIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.conditionreturn.tr())),
      );
      return;
    }

    final body = {
      "orderId": widget.order.id, // Use the correct MongoDB _id
      "products": selectedProductIds.map((id) => {"pId": id}).toList(),
    };

    try {
      print("Submitting return to: ${ApiEndPoints.baseUrl}api/returns");
      print("Request body: $body");

      final dio = Dio();

      final response = await dio.post(
        '${ApiEndPoints.baseUrl}api/returns',
        data: body,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ Clear selection and show confirmation
        setState(() {
          selectedProductIds.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppStrings.returnsubmitted.tr())),
        );
        Navigator.pop(context);
      } else {
        throw Exception("Failed to submit return");
      }
    } catch (e) {
      print("Return submit error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppStrings.error.tr()}: ${e.toString()}")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final products = widget.order.products;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.selectProductsToReturn.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
        Expanded(
        child: ListView.builder(
        itemCount: products.length,
          itemBuilder: (_, index) {
            final product = products[index].product;
            final productId = product?.id;

            if (productId == null) return const SizedBox();
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: product?.imageCover != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${ApiEndPoints.baseUrl}${product!.imageCover}',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(Icons.image_not_supported),
                title: Text(product?.title ?? "Unknown"),
                subtitle: Text("${AppStrings.quantity.tr()}: ${products[index].quantity}"),
                trailing: Checkbox(
                  value: selectedProductIds.contains(productId),
                  onChanged: (bool? selected) {
                    setState(() {
                      if (selected == true) {
                        selectedProductIds.add(productId);
                      } else {
                        selectedProductIds.remove(productId);
                      }
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
                   ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
      ),
               padding: const EdgeInsets.symmetric(
                vertical:18,
                 horizontal: 30
      ),
    ),
             onPressed: () {
                submitReturn();
                },
              icon: const Icon(
                Icons.assignment_return,
                color: AppColors.white,
              ),
              label: Text(
                AppStrings.submitreturn.tr(),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16.sp,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
