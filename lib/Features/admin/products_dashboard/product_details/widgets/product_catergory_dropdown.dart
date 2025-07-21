import 'package:flutter/material.dart';
import '../../viewmodel/products_dashboard_provider.dart';
import 'package:provider/provider.dart';

class ProductCategoryDropdowns extends StatefulWidget {
  final String? initialCategoryId;
  final String? initialSubCategoryId;
  final Function(String?) onCategoryChanged;
  final Function(String?) onSubCategoryChanged;

  const ProductCategoryDropdowns({
    super.key,
    required this.initialCategoryId,
    required this.initialSubCategoryId,
    required this.onCategoryChanged,
    required this.onSubCategoryChanged,
  });

  @override
  State<ProductCategoryDropdowns> createState() =>
      _ProductCategoryDropdownsState();
}

class _ProductCategoryDropdownsState extends State<ProductCategoryDropdowns> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final provider = context.read<ProductsDashboardProvider>();

      provider.getCategories().then((_) {
        final categoryId = widget.initialCategoryId;
        if (categoryId != null) {
          provider.getSubCategories(categoryId);
        }
      });

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsDashboardProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: widget.initialCategoryId,
              items: provider.categories
                  .map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (val) {
                widget.onCategoryChanged(val);
                if (val != null) {
                  provider.getSubCategories(val);
                }
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: widget.initialSubCategoryId,
              items: provider.subCategories
                  .map((e) => DropdownMenuItem(
                        value: e.id,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: widget.onSubCategoryChanged,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ],
        );
      },
    );
  }
}
