import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:pocket_vault/utils/string_extensions.dart';

extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();

    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));

    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  String toShortDate(Locale locale, [bool day = true]) {
    if (day) {
      if (isToday) return 'Hoje';
      if (isYesterday) return 'Ontem';
    }

    return DateFormat.MMMd(locale.toString()).format(this).capitalize();
  }

  String toMonthYear(Locale locale) {
    return DateFormat.yMMM(locale.toString()).format(this).capitalize();
  }

  String toFullDateNumeric(Locale locale) {
    return DateFormat.yMd(locale.toString()).format(this);
  }

  DateTime addMonths(int monthsToAdd) {
    DateTime next = DateTime(year, month + monthsToAdd, day);

    if (next.day != day) {
      next = DateTime(year, month + monthsToAdd + 1, 0);
    }
    return next;
  }
}
