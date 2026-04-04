import 'package:flutter/material.dart';

class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });

  void _onChanged(bool v) {
    if (v != value) {
      onChanged(v);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(title),
      trailing: Switch(value: value, onChanged: (v) => _onChanged(v)),
    );
  }
}
