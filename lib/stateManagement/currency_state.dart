import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:world_countries/world_countries.dart';

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

// making the RiverPod class
final currencyState = StateNotifierProvider((ref) => CurrencyState());

class CurrencyState extends StateNotifier<CurrencyFromToSection> {
  CurrencyState()
    : super(
        CurrencyFromToSection(
          fromCurrFlg: WorldCountry.list
              .firstWhere((c) => c.code == 'USA')
              .emoji,
          toCurrFlg: WorldCountry.list.firstWhere((c) => c.code == 'PAK').emoji,
        ),
      ) {
    // ref.listen(onlineProvider, (previous, next) {});
  }

  // making the function for to change the Currency Types
  // for: From Currency
  void fromCurrencyChanging(String flg, String name, String symbol) {
    if (name == state.toCurrNm) {
      if (kDebugMode) print('same same');
      String tempFlg = state.fromCurrFlg;
      String tempName = state.fromCurrNm;
      String tempSymbol = state.fromCurrSymbol;
      state = state.copyWith(
        fromCurrFlg: state.toCurrFlg,
        fromCurrNm: state.toCurrNm,
        fromCurrSymbol: state.toCurrSymbol,
        toCurrFlg: tempFlg,
        toCurrNm: tempName,
        toCurrSymbol: tempSymbol,
      );
    } else {
      state = state.copyWith(
        fromCurrFlg: flg,
        fromCurrNm: name,
        fromCurrSymbol: symbol,
      );
    }
  }

  void toCurrencyChaning(String flg, String name, String symbol) {
    if (name == state.fromCurrNm) {
      if (kDebugMode) print('Same same');
      String tempFlg = state.toCurrFlg;
      String tempName = state.toCurrNm;
      String tempSymbol = state.toCurrSymbol;
      state = state.copyWith(
        toCurrFlg: state.fromCurrFlg,
        toCurrNm: state.fromCurrNm,
        toCurrSymbol: state.fromCurrSymbol,
        fromCurrFlg: tempFlg,
        fromCurrNm: tempName,
        fromCurrSymbol: tempSymbol,
      );
    } else {
      state = state.copyWith(
        toCurrFlg: flg,
        toCurrNm: name,
        toCurrSymbol: symbol,
      );
    }
  }

  void swapping() {
    String flg = state.toCurrFlg;
    String name = state.toCurrNm;
    String symbol = state.toCurrSymbol;
    state = state.copyWith(
      toCurrFlg: state.fromCurrFlg,
      toCurrNm: state.fromCurrNm,
      toCurrSymbol: state.fromCurrSymbol,
      fromCurrFlg: flg,
      fromCurrNm: name,
      fromCurrSymbol: symbol,
    );
  }

  // Making the helper Function
  void helperSwappingReFetching(Function() reFetch) async {
    swapping();
    await reFetch();
  }

  void convertedZero() {
    state = state.copyWith(convertedValue: '0');
  }

  void convertedValueUpdate(String value) {
    state = state.copyWith(convertedValue: value);
  }

  
}
