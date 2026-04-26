import 'package:flutter/material.dart';
import 'package:pocket_vault/l10n/app_localizations.dart';

abstract final class AppDialogs {
  /// Base — use quando os actions não se encaixam nos helpers abaixo.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    return showDialog<T>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
      ),
    );
  }

  /// Sim / Não — retorna true se confirmou, false se cancelou, null se fechou.
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    required String content,
    required String confirm,
    Color? confirmColor,
  }) {
    final t = AppLocalizations.of(context)!;
    return show<bool>(
      context: context,
      title: title,
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(t.cancel),
        ),
        FilledButton(
          style: confirmColor != null
              ? FilledButton.styleFrom(backgroundColor: confirmColor)
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirm),
        ),
      ],
    );
  }

  /// Três opções — Cancelar / opção A / opção B.
  /// Retorna true para B, false para A, null para Cancelar.
  static Future<bool?> choice({
    required BuildContext context,
    required String title,
    required String content,
    required String labelA,
    required String labelB,
  }) {
    final t = AppLocalizations.of(context)!;
    return show<bool>(
      context: context,
      title: title,
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(labelA),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(labelB),
        ),
      ],
    );
  }
}
