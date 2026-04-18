// making the class type here

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class SharedPreferences {
  // making required variables
  ThemeMode? tm;
  String updatedAt;
  String? firstCurrencyFlag;
  String firstCurrency;
  String firstCurrencySymbolName;
  String? secondCurrencyFlag;
  String secondCurrency;
  String secondCurrencySymbolName;
  double oneCurrencyRate;
  List<Map<String, dynamic>> addedCurrencies;


  SharedPreferences({
    required this.tm,
    required this.updatedAt,
    required this.firstCurrencyFlag,
    required this.firstCurrency,
    required this.firstCurrencySymbolName,
    required this.secondCurrencyFlag,
    required this.secondCurrency,
    required this.secondCurrencySymbolName,
    required this.oneCurrencyRate,
    required this.addedCurrencies,
  });
}