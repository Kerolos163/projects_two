import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../Core/constant/app_colors.dart';


class CustomImagePicker extends StatefulWidget {
  final ValueChanged<File> onImageSelected;

  const CustomImagePicker({super.key, required this.onImageSelected});

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  final _picker = ImagePicker();
  File? _image;

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
      widget.onImageSelected(_image!); // ✅ Notify parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: const [6, 4],
      color: AppColors.secondary,
      strokeWidth: 1.5,
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      child: GestureDetector(
        onTap: pickImage,
        child: Container(
          height: 232,
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          alignment: Alignment.center,
          child: _image == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add image", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text("Tap to add an image",
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    const Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey),
                    const SizedBox(height: 8),
                  ],
                )
              : Image.file(_image!, width: 150, height: 150, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
