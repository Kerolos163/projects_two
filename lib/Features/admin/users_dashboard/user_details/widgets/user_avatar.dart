import 'package:flutter/material.dart';
import '../../../../../Core/api/api_end_points.dart';

class UserAvatar extends StatelessWidget {
  final String image;

  const UserAvatar({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    final valid = image.isNotEmpty;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: double.infinity,
        height: 200,
        child: valid
            ? Image.network(
                '${ApiEndPoints.baseUrl}uploads/$image',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 64, color: Colors.grey),
    );
  }
}
