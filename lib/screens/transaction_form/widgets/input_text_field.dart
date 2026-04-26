import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final TextInputType keyboardType;
  final Widget? sufixIcon;
  final CrossAxisAlignment crossAxisAlignment;
  final bool prefix;
  final Function(String)? onChanged;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;

  const InputTextField({
    required this.controller,
    this.label,
    this.hint,
    this.sufixIcon,
    this.onChanged,
    this.onTap,
    this.validator,
    this.focusNode,
    this.onFieldSubmitted,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.keyboardType = TextInputType.text,
    this.prefix = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (label != null)
          Text(label!, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            hintText: hint,
            suffixIcon: sufixIcon,
            prefixIcon: prefix ? const Icon(LucideIcons.tag, size: 20) : null,
          ),
          keyboardType: keyboardType,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          onTap: onTap,
          validator: validator,
        ),
      ],
    );
  }
}
