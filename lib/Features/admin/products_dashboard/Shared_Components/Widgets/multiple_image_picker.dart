import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projects_two/Core/constant/app_colors.dart';

class MultiImagePickerWidget extends StatefulWidget {
  final ValueChanged<List<File>> onImagesSelected;

  const MultiImagePickerWidget({super.key, required this.onImagesSelected});

  @override
  State<MultiImagePickerWidget> createState() => _MultiImagePickerWidgetState();
}

class _MultiImagePickerWidgetState extends State<MultiImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];

  Future<void> pickImages() async {
    final pickedList = await _picker.pickMultiImage();
    if (pickedList.isNotEmpty) {
      setState(() {
        _images = pickedList.map((xfile) => File(xfile.path)).toList();
      });
      widget.onImagesSelected(_images);
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
        onTap: pickImages,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: _images.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add images", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text("Tap to select multiple images",
                        style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 8),
                    const Icon(Icons.collections_outlined, size: 40, color: Colors.grey),
                  ],
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _images.map((img) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(img, width: 80, height: 80, fit: BoxFit.cover),
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }
}
