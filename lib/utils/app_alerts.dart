import 'package:alert_info/alert_info.dart';
import 'package:flutter/material.dart';

class AppAlerts {
  AppAlerts._();

  static void _show(
    BuildContext context,
    String message,
    TypeInfo type, {
    MessagePosition position = MessagePosition.top,
    double padding = 30.0,
    int duration = 3,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? actionColor,
    String? action,
    Function? actionCallback,
    IconData? icon,
  }) {
    if (!context.mounted) return;
    AlertInfo.show(
      context: context,
      text: message,
      typeInfo: type,
      position: position,
      padding: padding,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      iconColor: iconColor,
      actionColor: actionColor,
      action: action,
      actionCallback: actionCallback,
      icon: icon,
    );
  }

  static void success(
    BuildContext context,
    String message, {
    MessagePosition position = MessagePosition.top,
    double padding = 30.0,
    int duration = 3,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? actionColor,
    String? action,
    Function? actionCallback,
    IconData? icon,
  }) => _show(
    context,
    message,
    TypeInfo.success,
    position: position,
    padding: padding,
    duration: duration,
    backgroundColor: backgroundColor,
    textColor: textColor,
    iconColor: iconColor,
    actionColor: actionColor,
    action: action,
    actionCallback: actionCallback,
    icon: icon,
  );

  static void error(
    BuildContext context,
    String message, {
    MessagePosition position = MessagePosition.top,
    double padding = 30.0,
    int duration = 3,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? actionColor,
    String? action,
    Function? actionCallback,
    IconData? icon,
  }) => _show(
    context,
    message,
    TypeInfo.error,
    position: position,
    padding: padding,
    duration: duration,
    backgroundColor: backgroundColor,
    textColor: textColor,
    iconColor: iconColor,
    actionColor: actionColor,
    action: action,
    actionCallback: actionCallback,
    icon: icon,
  );

  static void warning(
    BuildContext context,
    String message, {
    MessagePosition position = MessagePosition.top,
    double padding = 30.0,
    int duration = 3,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? actionColor,
    String? action,
    Function? actionCallback,
    IconData? icon,
  }) => _show(
    context,
    message,
    TypeInfo.warning,
    position: position,
    padding: padding,
    duration: duration,
    backgroundColor: backgroundColor,
    textColor: textColor,
    iconColor: iconColor,
    actionColor: actionColor,
    action: action,
    actionCallback: actionCallback,
    icon: icon,
  );

  static void info(
    BuildContext context,
    String message, {
    MessagePosition position = MessagePosition.top,
    double padding = 30.0,
    int duration = 3,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    Color? actionColor,
    String? action,
    Function? actionCallback,
    IconData? icon,
  }) => _show(
    context,
    message,
    TypeInfo.info,
    position: position,
    padding: padding,
    duration: duration,
    backgroundColor: backgroundColor,
    textColor: textColor,
    iconColor: iconColor,
    actionColor: actionColor,
    action: action,
    actionCallback: actionCallback,
    icon: icon,
  );
}
