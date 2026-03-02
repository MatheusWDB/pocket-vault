import 'package:intl/intl.dart';

extension DoubleExtensions on double {
  String toCurrency({
    required String code,
    required String locale,
    bool showSymbol = true,
  }) {
   final formatter = showSymbol 
      ? NumberFormat.simpleCurrency(locale: locale, name: code)
      : NumberFormat.currency(locale: locale, symbol: '', name: code);

    return formatter.format(this).trim();
  }
}
