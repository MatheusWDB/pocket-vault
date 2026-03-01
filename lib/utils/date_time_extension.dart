import 'package:intl/intl.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';
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

  String toHeaderFormat(CurrencySymbolEnum currency) {
    if (isToday) return 'Hoje';
    if (isYesterday) return 'Ontem';

    return DateFormat('dd MMM', currency.locale).format(this).capitalize();
  }
}
