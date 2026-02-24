enum CurrencySymbolEnum {
  brl('BRL', 'R\$', 'pt_BR', 'Português (Brasil)', 2),
  usd('USD', '\$', 'en_US', 'English (USA)', 2),
  eur('EUR', '€', 'de_DE', 'Euro (Europa)', 2),
  gbp('GBP', '£', 'en_GB', 'Pound (UK)', 2),
  jpy('JPY', '¥', 'ja_JP', 'Yen (Japan)', 0);

  final String code;
  final String symbol;
  final String locale;
  final String displayName;
  final int decimalDigits;

  const CurrencySymbolEnum(
    this.code,
    this.symbol,
    this.locale,
    this.displayName,
    this.decimalDigits,
  );
}
