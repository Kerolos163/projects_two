import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType type;
  final String hint;
  final bool enabled;
    final String? Function(String?)? validator;

  const CustomTextfield({
    super.key,
    required this.controller,
    this.type = TextInputType.text,
    required this.hint,
    this.enabled = true,
    this.validator
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
            controller: widget.controller,
            keyboardType: widget.type,
            enabled: widget.enabled,
            validator: widget.validator,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Colors.grey),
              filled: false, // ✅ don't fill background
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
            onChanged: (val) {
              setState(() {
                errorText = val.isEmpty ? 'Required' : null;
              });
            },
          ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              errorText!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
