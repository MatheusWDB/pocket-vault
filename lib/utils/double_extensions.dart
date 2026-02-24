import 'package:intl/intl.dart';
import 'package:pocket_vault/enums/currency_symbol_enum.dart';

extension DoubleExtensions on double {
  String toCurrency(CurrencySymbolEnum currencyCode) {
    final formatter = NumberFormat.simpleCurrency(
      locale: currencyCode.locale,
      name: currencyCode.code,
    );
    return formatter.format(this);
  }
}
