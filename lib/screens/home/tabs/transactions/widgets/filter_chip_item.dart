import 'package:flutter/material.dart';

class FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isSelectable;
  final Function(bool)? onSelected;
  final VoidCallback? onDeleted;

  const FilterChipItem({
    required this.isSelected,
    required this.isSelectable,
    required this.label,
    this.onSelected,
    this.onDeleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      selected: isSelected,
      onSelected: isSelectable ? onSelected : (bool value) {},
      onDeleted: onDeleted,
      showCheckmark: false,
      selectedColor: Colors.blueAccent.withValues(alpha: 0.2),
      checkmarkColor: Colors.blueAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
