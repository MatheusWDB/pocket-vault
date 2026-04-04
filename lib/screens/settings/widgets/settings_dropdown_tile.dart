import 'package:flutter/material.dart';

class SettingsDropdownTile<T> extends StatelessWidget {
  final String title;
  final T value;
  final List<T> values;
  final String Function(T) label;
  final void Function(T) onChanged;

  const SettingsDropdownTile({
    required this.title,
    required this.value,
    required this.values,
    required this.label,
    required this.onChanged,
    super.key,
  });

  void _onSelected(T? v) {
    if (v != null && v != value) {
      onChanged(v);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(title),
      trailing: DropdownMenu<T>(
        initialSelection: value,
        width: 140,
        onSelected: (v) => _onSelected(v),
        dropdownMenuEntries: values
            .map((v) => DropdownMenuEntry(value: v, label: label(v)))
            .toList(),
      ),
    );
  }
}
