// making the class type here
import 'dart:convert';
import 'package:currency/Controller/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_countries/world_countries.dart';

class Shared {}

class Storage extends StateNotifier<Shared> {
  final Ref ref;
  Storage(this.ref) : super(Shared()) {
    ref.listen(currencyState, (previous, next) {});
    ref.listen(onlineProvider, (previous, next) {});
    ref.listen(popuState, (previous, next) {});
    ref.listen(addedCurrenState, (previous, next) {});
  }

  // making the Helper who will handle almost all the stuff
  Future<void> helperOfAll() async {
    await gettingDataFromStorage();
    await ref.read(onlineProvider.notifier).gettingData();
    ref.read(popuState.notifier).assigningValues();
    await savingMainData();
    await webDataSaving();
  }

  // making the process of saving the data

  Future<void> savingMainData() async {
    final pref = await SharedPreferences.getInstance();
    final rf = ref.read(currencyState);
    pref.setString('updated', rf.lastUpdated);
    pref.setString('FromFlag', rf.fromCurrFlg);
    pref.setString('FromCurr', rf.fromCurrNm);
    pref.setString('FromCurrSym', rf.fromCurrSymbol);
    pref.setString('toCurrFlag', rf.toCurrFlg);
    pref.setString('toCurr', rf.toCurrNm);
    pref.setString('toCurrSym', rf.toCurrSymbol);
    pref.setDouble('oneRate', rf.oneCurrencyRate);
  }

  Future<void> webDataSaving() async {
    final pref = await SharedPreferences.getInstance();
    final rfData = ref.read(onlineProvider);
    final rfPopu = ref.read(popuState);
    // making the data saving into simple String
    final data = jsonEncode(rfData.dataFromWeb);
    pref.setString('dataFromWeb', data);
    pref.setDouble('popuOne', (rfPopu.firstAmount as num).toDouble());
    pref.setDouble('popuTwo', (rfPopu.secondAmount as num).toDouble());
    pref.setDouble('popuThree', (rfPopu.thirdAmount as num).toDouble());
  }

  Future<void> addedCurrenciesSaving() async {
    final pref = await SharedPreferences.getInstance();
    final rfCurr = ref.read(addedCurrenState);
    // now converting the addedCurrencies to simple string first
    final addedCurrString = jsonEncode(rfCurr.addedCurrencies);
    pref.setString('addedCurrencies', addedCurrString);
    if (kDebugMode) print('Saving this: $addedCurrString');
  }

  Future<void> gettingDataFromStorage() async {
    final pref = await SharedPreferences.getInstance();
    final rf = ref.read(currencyState.notifier);
    final rfOnline = ref.read(onlineProvider.notifier);
    final rfPopu = ref.read(popuState.notifier);
    final rfCurr = ref.read(addedCurrenState.notifier);
    rf.assigningLastUpdated(pref.getString('updated') ?? '--');
    rf.getDataFromStorage(
      pref.getString('FromFlag') ??
          WorldCountry.list.firstWhere((e) => e.code == 'USA').emoji,
      pref.getString('FromCurr') ?? 'USD',
      pref.getString('FromCurrSym') ?? 'United States Dollar',
      pref.getString('toCurrFlag') ??
          WorldCountry.list.firstWhere((e) => e.code == 'PAK').emoji,
      pref.getString('toCurr') ?? 'PKR',
      pref.getString('toCurrSym') ?? 'Pakistani Rupee',
      pref.getDouble('oneRate') ?? 0.0,
    );
    rfPopu.getPopu(
      pref.getDouble('popuOne') ?? 0.0,
      pref.getDouble('popuTwo') ?? 0.0,
      pref.getDouble('popuThree') ?? 0.0,
    );

    final value = pref.getString('dataFromWeb');
    if (value != null && value.isNotEmpty) {
      final convertedData = jsonDecode(value);
      rfOnline.getDataFromWeb(convertedData);
    } else {
      if (kDebugMode) print('Data From Web storage empty');
    }

    final valueAddedCurrencies = pref.getString('addedCurrencies');
    if (kDebugMode) print('Received first: $valueAddedCurrencies');
    if (valueAddedCurrencies != null && valueAddedCurrencies.isNotEmpty) {
      final conversion = (jsonDecode(valueAddedCurrencies) as List)
          .cast<Map<String, dynamic>>();
      if (kDebugMode) print(conversion.runtimeType);
      rfCurr.getAddedCurrencies(conversion);
    } else {
      if (kDebugMode) print('Storage added Curr emtpy');
    }
  }
}
