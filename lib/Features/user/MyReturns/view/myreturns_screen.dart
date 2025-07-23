import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Core/Services/preferences_manager.dart';
import '../../../../Core/api/api_end_points.dart';
import '../../../../Core/models/return_model.dart';
import '../../../../Core/constant/app_strings.dart';
import '../../../admin/orders_dashboard/service/orders_service.dart';
import '../../../../Core/utils/app_constants.dart';
import '../../../admin/orders_dashboard/viewmodel/orders_dashboard_provider.dart';
import '../../UserOrders/UserOrderDetails/view/user_order_details_screen.dart';
import '../returns_details/view/returned_details_screen.dart';

class UserReturnScreen extends StatefulWidget {
  const UserReturnScreen({super.key});

  @override
  State<UserReturnScreen> createState() => _UserReturnScreenState();
}

class _UserReturnScreenState extends State<UserReturnScreen> {
  List<ReturnModel> returnedProducts = [];
  bool isLoading = true;
  final OrderService orderService = OrderService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersDashboardProvider>().fetchReturnsForCurrentUser();
      _loadReturns();
    });
  }

  Future<void> _loadReturns() async {
    try {
      String? userInfo = PreferencesManager.getString(AppConstants.userInfo);
      if (userInfo == null) {
        throw Exception("User not logged in");
      }

      String userId = jsonDecode(userInfo)['id'];

      List<ReturnModel> returns = await orderService.getReturnsByUserId(userId);

      setState(() {
        returnedProducts = returns;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading returned products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.returned.tr()),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : returnedProducts.isEmpty
          ? Center(
        child: Text(
          "No returned products found",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      )
          : ListView.separated(
        itemCount: returnedProducts.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (context, index) {
          final returnItem = returnedProducts[index];
          final product = returnItem.order?.products.first.product;
          // 🔍 Debugging output
          print('Image URL: ${product?.imageCover}');
          print('Order: ${returnItem.order}');
          print('Order products: ${returnItem.order?.products}');
          print('Product object: ${returnItem.order?.products.first.product}');


          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product?.imageCover != null
                  ? Image.network(
                product?.imageCover != null
                    ? '${ApiEndPoints.baseUrl}${product!.imageCover}'
                    : "https://via.placeholder.com/50",
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : const SizedBox(
                width: 50,
                height: 50,
                child: Icon(Icons.image_not_supported),
              ),
            ),
            title: Text("${AppStrings.Return.tr()}:${returnItem.id ?? index}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${AppStrings.status.tr()}:"),
                const SizedBox(height: 4),
                _buildStatusBadge(returnItem.status ?? 'pending'),
              ],
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              if (returnItem.order != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserReturnedDetailsScreen(order: returnItem.order!, returnModel: returnItem,),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Order details not available")),
                );
              }
            },

          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'processing':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      case 'refunded':
        return Colors.orange;
      case 'returned':
        return Colors.orange;
      case 'pending':
      default:
        return Colors.grey;
    }
  }
}
