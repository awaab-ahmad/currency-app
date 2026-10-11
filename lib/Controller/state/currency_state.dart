import 'package:currency/Controller/state/added_curreny_state.dart';
import 'package:currency/Controller/providers.dart';
import 'package:currency/Models/currency_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:world_countries/world_countries.dart';
import 'package:flutter/material.dart';

// making the RiverPod class

class CurrencyState extends StateNotifier<CurrencyFromToSection> {
  final Ref ref;
  CurrencyState(this.ref)
    : super(
        CurrencyFromToSection(
          fromCurrFlg: WorldCountry.list
              .firstWhere((c) => c.code == 'USA')
              .emoji,
          toCurrFlg: WorldCountry.list.firstWhere((c) => c.code == 'PAK').emoji,
        ),
      );

  // making the function for to change the Currency Types
  // for: From Currency
  void fromCurrencyChanging(
    String flg,
    String name,
    String symbol,
    TextEditingController amount,
  ) {
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
    if (amount.text.trim().isNotEmpty) {
      final rf = ref.read(addedCurrenState.notifier);
      amount.clear();
      convertedZero();
      rf.clearingCurrResults();
    }
  }

  void toCurrencyChaning(
    String flg,
    String name,
    String symbol,
    TextEditingController amount,
  ) {
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
    if (amount.text.trim().isNotEmpty) {
      final rf = ref.read(addedCurrenState.notifier);
      amount.clear();
      convertedZero();
      rf.clearingCurrResults();
    }
  }

  void swapping(TextEditingController amount) {
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
    if (amount.text.trim().isNotEmpty) {
      amount.clear();
      convertedZero();
      final rf = ref.read(addedCurrenState.notifier);
      rf.clearingCurrResults();
    }
  }

  // Making the helper Function
  void helperSwappingReFetching(
    Function() reFetch,
    TextEditingController tc,
  ) async {
    swapping(tc);
    await reFetch();
  }

  void convertedZero() {
    state = state.copyWith(convertedValue: '0');
  }

  void convertedValueUpdate(String value) {
    state = state.copyWith(convertedValue: value);
  }

  // making the function for assigning the last updated
  // that is used in online state

  void assigningLastUpdated(String valToAssign) {
    state = state.copyWith(lastUpdated: valToAssign);
  }

  // This below function is for when the data is being
  // fetched from storage
  void getDataFromStorage(
    String fCrf,
    fCrN,
    fCrS,
    tCrf,
    tCrN,
    tCrS,
    double oneRate,
  ) {
    state = state.copyWith(
      fromCurrFlg: fCrf,
      fromCurrNm: fCrN,
      fromCurrSymbol: fCrS,
      toCurrFlg: tCrf,
      toCurrNm: tCrN,
      toCurrSymbol: tCrS,
      oneCurrencyRate: oneRate,
    );
  }
}
