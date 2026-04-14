import 'package:pocket_vault/l10n/app_localizations.dart';

enum CurrencySymbolEnum {
  brl('BRL', 'R\$', 'pt_BR', 2),
  usd('USD', '\$', 'en_US', 2),
  eur('EUR', '€', 'de_DE', 2),
  gbp('GBP', '£', 'en_GB', 2),
  jpy('JPY', '¥', 'ja_JP', 0);

  final String code;
  final String symbol;
  final String locale;
  final int decimalDigits;

  String displayName(AppLocalizations t) {
    return switch (this) {
      CurrencySymbolEnum.brl => t.langPtBr,
      CurrencySymbolEnum.usd => t.langEnUs,
      CurrencySymbolEnum.eur => t.currEuro,
      CurrencySymbolEnum.gbp => t.currPound,
      CurrencySymbolEnum.jpy => t.currYen,
    };
  }

  const CurrencySymbolEnum(
    this.code,
    this.symbol,
    this.locale,
    this.decimalDigits,
  );
}
