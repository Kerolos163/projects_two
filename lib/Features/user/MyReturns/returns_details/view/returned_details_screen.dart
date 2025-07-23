import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:projects_two/Core/api/api_end_points.dart';
import 'package:projects_two/Core/constant/app_colors.dart';
import 'package:projects_two/Core/constant/app_strings.dart';
import 'package:projects_two/Core/models/order_model.dart';
import 'package:projects_two/Core/models/return_model.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_label.dart';
import 'package:projects_two/Features/admin/products_dashboard/Shared_Components/Widgets/custom_textfield.dart';

class UserReturnedDetailsScreen extends StatefulWidget {
  final OrderModel order;
  final ReturnModel returnModel;

  const UserReturnedDetailsScreen({
    Key? key,
    required this.order,
    required this.returnModel,
  }) : super(key: key);

  @override
  State<UserReturnedDetailsScreen> createState() => _UserReturnedDetailsScreenState();
}

class _UserReturnedDetailsScreenState extends State<UserReturnedDetailsScreen> {
  late OrderModel currentOrder;
  late ReturnModel currentReturn;
  bool isCancelling = false;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    currentOrder = widget.order;
    currentReturn = widget.returnModel;
    _loadReturn();
  }

  Future<void> _loadReturn() async {
    if (currentReturn.id == null) {
      return;
    }
    final url = '${ApiEndPoints.baseUrl}returns/${currentReturn.id}';

    try {
      final resp = await dio.get(url);
      if (resp.statusCode == 200 && resp.data != null) {
        final json = resp.data as Map<String, dynamic>;

        setState(() {
          currentReturn = ReturnModel.fromJson(json);
        });
      } else {
      }
    } catch (e, stacktrace) {
      debugPrint(stacktrace.toString());
    }
  }

  Future<bool?> showConfirmCancelDialog() {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:Text(AppStrings.cancelconfirm.tr()),
        content: Text(AppStrings.confirmationtext.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child:Text(AppStrings.no.tr()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child:Text(AppStrings.yes.tr()),
          ),
        ],
      ),
    );
  }


  Future<void> cancelReturn(String returnId) async {
    if (returnId.isEmpty) {
      print('ERROR: Return ID is empty');
      return;
    }

    final dio = Dio();
    final url = 'http://10.0.2.2:5000/returns/${widget.returnModel.id}';

    try {

      final response = await dio.patch(
        url,
        data: {'status': 'cancelled'},
      );
      print(' Return cancelled successfully: ${response.data}');
    } on DioException catch (e) {
      print(' Error cancelling return: ${e.response?.statusCode} ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = currentOrder.date?.toLocal().toString().split('.').first ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.orderDetails.tr()), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            CustomLabel(text: AppStrings.orderId.tr()),
            CustomTextfield(
              controller: TextEditingController(text: currentOrder.oId.toString()),
              enabled: false,
              hint: '',
            ),
            CustomLabel(text: AppStrings.paymentMethod.tr()),
            CustomTextfield(
              controller: TextEditingController(text: currentOrder.paymentMethod),
              enabled: false,
              hint: '',
            ),
            CustomLabel(text: AppStrings.date.tr()),
            CustomTextfield(
              controller: TextEditingController(text: dateText),
              enabled: false,
              hint: '',
            ),
            CustomLabel(text: AppStrings.status.tr()),
            CustomTextfield(
              controller: TextEditingController(text: currentOrder.status),
              enabled: false,
              hint: '',
            ),
            const SizedBox(height: 24),
            Text(AppStrings.products.tr(), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...currentOrder.products.map((op) {
              final prod = op.product;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: prod?.imageCover != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '${ApiEndPoints.baseUrl}${prod!.imageCover}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.image_not_supported),
                  title: Text(
                    prod?.title.isNotEmpty == true ? prod!.title : 'Order: ${currentOrder.oId}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${AppStrings.quantity.tr()}: ${op.quantity}'),
                      if (widget.returnModel.status != null)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: () {
                              switch (widget.returnModel.status) {
                                case 'cancelled':
                                  return Colors.red;
                                case 'pending':
                                  return Colors.grey;
                                case 'fulfilled':
                                case 'returned':
                                case 'refunded':
                                  return Colors.green;
                                default:
                                  return Colors.black26;
                              }
                            }(),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.returnModel.status!.toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      // Status text below quantity
                      if (op.returnStatus != null && op.returnStatus != 'none')
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Builder(
                            builder: (_) {
                              String label;
                              Color color;

                              switch (op.returnStatus) {
                                case 'pending':
                                  label = AppStrings.returnPending.tr();
                                  color = Colors.orange;
                                  break;
                                case 'returned':
                                case 'fulfilled':
                                  label = AppStrings.returned.tr();
                                  color = Colors.green;
                                  break;
                                case 'cancelled':
                                case 'rejected':
                                  label = 'Cancelled';
                                  color = Colors.red;
                                  break;
                                default:
                                  label = 'Unknown';
                                  color = Colors.grey;
                              }

                              return Chip(
                                label: Text(
                                  label,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: color,
                                visualDensity: VisualDensity.compact,
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 32),
            if (widget.returnModel.status != 'cancelled')
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: isCancelling
                    ? null
                    : () async {
                  final id = widget.returnModel.id;
                  if (id == null || id.isEmpty) {
                    print('Error: returnModel id is null or empty');
                    return;
                  }

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(AppStrings.cancelconfirm.tr()),
                      content:  Text(AppStrings.confirmationtext.tr()),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child:Text(AppStrings.no.tr()),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child:Text(AppStrings.yes.tr()),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    setState(() => isCancelling = true);

                    try {
                      final url = 'http://10.0.2.2:5000/api/returns/${widget.returnModel.id}';
                      final response = await dio.patch(
                        url,
                        data: {'status': 'cancelled'},
                        options: Options(
                          headers: {'Content-Type': 'application/json'},
                        ),
                      );
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          title: Text(AppStrings.success.tr()),
                          content: Text(AppStrings.successcancelation.tr()),
                        ),
                      );
                      await Future.delayed(const Duration(seconds: 2));
                      if (mounted) Navigator.of(context).pop();
                    } catch (e) {
                      print('Error cancelling return: $e');
                    } finally {
                      setState(() => isCancelling = false);
                    }
                  }
                },
                child: isCancelling
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
                    : Text(
                  AppStrings.cancelreturns.tr(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),

            const SizedBox(height: 24),
            Center(
              child: Text(
                AppStrings.contactSupport.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

}