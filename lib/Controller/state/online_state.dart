import 'package:currency/Controller/state/added_curreny_state.dart';
import 'package:currency/Controller/state/currency_state.dart';
import 'package:currency/Controller/providers.dart';
import 'package:currency/Models/online_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// making the riverpod class

class OnlineState extends StateNotifier<DataFromWebsite> {
  final Ref ref;
  OnlineState(this.ref) : super(DataFromWebsite()) {
    ref.listen(currencyState, (previous, next) {});
    ref.listen(addedCurrenState, (previous, next) {});
  }

  Future<void> helperWorker(Function() popuAssigning) async {
    await gettingData();
    await popuAssigning();
  }

  // This is the function for getting stored web data
  void getDataFromWeb(dynamic data) {
    state = state.copyWith(dataFromWeb: data);
  }

  Future<void> gettingData() async {
    final rf = ref.read(currencyState);
    if (kDebugMode) print('One Currency Rate value: ${rf.oneCurrencyRate}');
    if (kDebugMode) print('To Curr: ${rf.toCurrNm}');
    try {
      state = state.copyWith(isLoading: true);
      final url =
          'https://v6.exchangerate-api.com/v6/f1efdd7a5c01a15577188d9a/latest/${rf.fromCurrNm}';
      final httpRequest = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 10));
      if (httpRequest.statusCode == 200) {
        state = state.copyWith(dataFromWeb: json.decode(httpRequest.body));
        if (kDebugMode) print('Data Received');
        rf.oneCurrencyRate = state.dataFromWeb['conversion_rates'][rf.toCurrNm];
        final dateTime = DateTime.now().toLocal();
        final val = DateFormat('MMMM dd, yyyy h:mm a').format(dateTime);
        ref.read(currencyState.notifier).assigningLastUpdated(val);
      } else {
        if (kDebugMode) print('Server Error');
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      if (kDebugMode) print('Internet Issue, Try again later');
      state = state.copyWith(isLoading: false);
    }
  }

  void oneCurrencyRateChanging(String countryCode) {
    final rf = ref.read(currencyState);
    rf.oneCurrencyRate =
        (state.dataFromWeb['conversion_rates'][countryCode] as num).toDouble();
  }

  // Making the function for the value conversion
  void gettingAmountCalculated(TextEditingController value) {
    if (kDebugMode) print('Data From Web: ${state.dataFromWeb}');
    final r = ref.read(currencyState);
    final numFormat = NumberFormat('#,##0.00');
    if (value.text.trim().isEmpty) {
      ref.read(currencyState.notifier).convertedZero();
    } else {
      double textValue = double.parse(value.text.trim());
      final result =
          (textValue * state.dataFromWeb['conversion_rates'][r.toCurrNm]);
      ref
          .read(currencyState.notifier)
          .convertedValueUpdate(numFormat.format(result));
    }
  }

  void addedCurrenciesCalculation(TextEditingController amount) {
    if (ref.read(addedCurrenState).addedCurrencies.isNotEmpty) {
      final rf = ref.read(addedCurrenState);
      if (kDebugMode) print('Currency Present');
      double text = amount.text.trim().isEmpty
          ? 0
          : double.parse(amount.text.trim());
      for (int i = 0; i < rf.addedCurrencies.length; i++) {
        String name = rf.addedCurrencies[i]['name'];
        double? result = (text * state.dataFromWeb['conversion_rates'][name]);
        ref
            .read(addedCurrenState.notifier)
            .calculatingCurrencyValues(i, result);
      }
    } else {
      if (kDebugMode) print('Currency Not Present');
    }
  }
}
