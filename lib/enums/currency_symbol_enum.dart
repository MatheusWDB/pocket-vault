enum CurrencySymbolEnum {
  brl('BRL', 'R\$', 'Português (Brasil)'),
  usd('USD', '\$', 'English (USA)'),
  eur('EUR', '€', 'Euro (Europa)'),
  gbp('GBP', '£', 'Pound (UK)'),
  jpy('JPY', '¥', 'Yen (Japan)');

  final String code;
  final String symbol;
  final String displayName;

  const CurrencySymbolEnum(this.code, this.symbol, this.displayName);
}
