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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(title),
      trailing: DropdownMenu<T>(
        initialSelection: value,
        width: 130,
        onSelected: (v) {
          if (v != null && v != value) {
            onChanged(v);
          }
        },
        dropdownMenuEntries: values
            .map((v) => DropdownMenuEntry(value: v, label: label(v)))
            .toList(),
      ),
    );
  }
}
