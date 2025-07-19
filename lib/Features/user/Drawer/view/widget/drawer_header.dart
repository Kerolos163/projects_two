import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Core/Theme/app_provider.dart';
import '../../../../../Core/api/api_end_points.dart';
import '../../../../../Core/constant/image.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({super.key, required this.appProvider});
  final AppProvider appProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundImage: appProvider.image != null
              ? NetworkImage(
                  "${ApiEndPoints.baseUrl}uploads/${appProvider.image}",
                )
              : AssetImage(ImagePath.avatar),
        ),
        SizedBox(height: 12),
        Text(
          "${appProvider.getUser().fName} ${appProvider.getUser().lName}",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: 12),
      ],
    );
  }
}
