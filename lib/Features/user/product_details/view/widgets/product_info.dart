import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../Core/constant/app_strings.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    super.key,
    required this.description,
    required this.categoryName,
  });
  final String description;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(description, style: TextStyle(fontSize: 16))),
        Text('${AppStrings.category.tr()}:  $categoryName'),
      ],
    );
  }
}
