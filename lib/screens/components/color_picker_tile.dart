// lib/screens/components/color_picker_tile.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';

class ColorPickerTile extends StatelessWidget {
  final Color? selectedColor;
  final bool enabled;
  final ValueChanged<Color?> onColorChanged;

  const ColorPickerTile({
    required this.selectedColor,
    required this.onColorChanged,
    this.enabled = true,
    super.key,
  });

  void _changeColor(BuildContext context, Color? c) {
    onColorChanged(c);
    Navigator.pop(context);
  }

  Future<void> _onTap(BuildContext context, AppLocalizations t) async {
    Color current = selectedColor ?? Colors.red[50]!;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.chooseColor),
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: current,
            onColorChanged: (c) => current = c,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _changeColor(context, null),
            child: Text(t.reset),
          ),
          TextButton(
            onPressed: () => _changeColor(context, current),
            child: Text(t.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return ListTile(
      enabled: enabled,
      contentPadding: EdgeInsets.zero,
      title: Text(t.categoryColor),
      subtitle: selectedColor != null
          ? Text(selectedColor!.toHexString())
          : null,
      trailing: Icon(LucideIcons.palette, color: selectedColor),
      onTap: enabled ? () => _onTap(context, t) : null,
    );
  }
}
