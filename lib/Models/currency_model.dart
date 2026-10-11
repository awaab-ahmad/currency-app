
class CurrencyFromToSection {
  String lastUpdated;
  String fromCurrFlg;
  String fromCurrNm;
  String fromCurrSymbol;
  String toCurrFlg;
  String toCurrNm;
  String toCurrSymbol;
  double oneCurrencyRate;
  String convertedValue;

  CurrencyFromToSection({
    this.lastUpdated = '',
    this.fromCurrNm = 'USD',
    this.fromCurrSymbol = 'United States Dollar',
    this.toCurrNm = 'PKR',
    this.toCurrSymbol = 'Pakistani Rupee',
    this.oneCurrencyRate = 0.0,
    this.convertedValue = '0',
    required this.fromCurrFlg,
    required this.toCurrFlg,
  });

  CurrencyFromToSection copyWith({
    String? lastUpdated,
    String? fromCurrFlg,
    String? fromCurrNm,
    String? fromCurrSymbol,
    String? toCurrFlg,
    String? toCurrNm,
    String? toCurrSymbol,
    double? oneCurrencyRate,
    String? convertedValue,
  }) {
    return CurrencyFromToSection(
      lastUpdated: lastUpdated ?? this.lastUpdated,
      fromCurrFlg: fromCurrFlg ?? this.fromCurrFlg,
      fromCurrNm: fromCurrNm ?? this.fromCurrNm,
      fromCurrSymbol: fromCurrSymbol ?? this.fromCurrSymbol,
      toCurrFlg: toCurrFlg ?? this.toCurrFlg,
      toCurrNm: toCurrNm ?? this.toCurrNm,
      toCurrSymbol: toCurrSymbol ?? this.toCurrSymbol,
      oneCurrencyRate: oneCurrencyRate ?? this.oneCurrencyRate,
      convertedValue: convertedValue ?? this.convertedValue,
    );
  }
}