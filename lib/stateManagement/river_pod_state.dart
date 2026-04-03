import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:world_countries/world_countries.dart';
import 'package:http/http.dart' as http;

final stateManagementClass = ChangeNotifierProvider((ref) => StManagement());

class StManagement extends ChangeNotifier {
  bool isLoading = false;
  String updatedAt = '';
  String firstCurrency = 'USD';
  String secondCurrency = 'PKR';
  String firstCurrencyFlag = WorldCountry.list
      .firstWhere((country) => country.code == 'USA')
      .emoji;

  String secondCurrencyFlag = WorldCountry.list
      .firstWhere((country) => country.code == 'PAK')
      .emoji;
  String firstCurrSymbolName = 'United States Dollar';
  String secondCurrSymbolName = 'Pakistani Rupee';

  // For Popular Rates (3)
  String firstPopuFlag = WorldCountry.list
      .firstWhere((c) => c.code == 'USA')
      .emoji;
  String secondPopuFlag = WorldCountry.list
      .firstWhere((c) => c.code == 'GBR')
      .emoji;
  String thirdPopuFlag = WorldCountry.list
      .firstWhere((c) => c.code == 'ITA')
      .emoji;
  String firstName = 'USD';
  String secondName = 'GBP';
  String thirdName = 'EUR';

  double firstPopuAmount = 0.0;
  double secondPopuAmount = 0.0;
  double thirdPopuAmount = 0.0;

  TextEditingController amountController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController exchangeController = TextEditingController();

  double convertedValue = 0.0;
  double oneCurrencyRate = 0.0;
  String formattedResult = '0';

  final worldCountries = WorldCountry.list.where((c) => c.independent).toList();
  // making the Filtered Results list

  List<WorldCountry> filteredList = WorldCountry.list
      .where((c) => c.independent)
      .toList();
  List<WorldCountry> exchangeFiltered = WorldCountry.list
      .where((c) => c.independent)
      .toList();

  dynamic dataFromWeb;

  List<Map<String, dynamic>> addedCurrencies = [];
  List<String> filterTypes = [
    'Alphabetical (A - Z)',
    'Alphabetical (Z - A)',
    'Exchange Rate  (Low - High)',
    'Exchange Rate (High - Low)',
  ];

  // now making the function for assigning From To currencies
  Future<void> assigningFromCurrency(
    String currencyToAssign,
    String flagToAssign,
    String symbolName,
  ) async {
    if (currencyToAssign == secondCurrency) {
      if (kDebugMode) print('Same Currencies');
      String temp = firstCurrency;
      String tempFlag = firstCurrencyFlag;
      String tempSymbol = firstCurrSymbolName;
      firstCurrency = secondCurrency;
      secondCurrency = temp;
      firstCurrencyFlag = secondCurrencyFlag;
      secondCurrencyFlag = tempFlag;
      firstCurrSymbolName = secondCurrSymbolName;
      secondCurrSymbolName = tempSymbol;
      amountController.clear();
      calculatingTheEnteredAmount();
      // changeOneCurrencyRate(currencyToAssign);
    } else {
      firstCurrencyFlag = flagToAssign;
      firstCurrSymbolName = symbolName;
      firstCurrency = currencyToAssign;
      amountController.clear();
      calculatingTheEnteredAmount();
    }
    notifyListeners();
  }

  void assigningToCurrency(
    String currencyToAssign,
    String flagToAssign,
    String symbolName,
  ) {
    if (currencyToAssign == firstCurrency) {
      if (kDebugMode) print('Same Currencies');
      String temp = secondCurrency;
      String tempFlag = secondCurrencyFlag;
      String tempSymbol = secondCurrSymbolName;
      secondCurrency = firstCurrency;
      firstCurrency = temp;
      secondCurrencyFlag = firstCurrencyFlag;
      firstCurrencyFlag = tempFlag;
      secondCurrSymbolName = firstCurrSymbolName;
      firstCurrSymbolName = tempSymbol;
      amountController.clear();
      // changeOneCurrencyRate(currencyToAssign);
      calculatingTheEnteredAmount();
    } else {
      secondCurrSymbolName = symbolName;
      secondCurrencyFlag = flagToAssign;
      secondCurrency = currencyToAssign;
      amountController.clear();
      calculatingTheEnteredAmount();
    }
    notifyListeners();
  }

  // making the function for adding the Currencies
  void addingCurrencies(String flag, String name) {
    if (addedCurrencies.length < 5) {
      bool alreadyPresent = false;
      // making the for loop for to avoid duplication
      for (int i = 0; i < addedCurrencies.length; i++) {
        if (addedCurrencies[i]['name'] == name) {
          if (kDebugMode) print('Already Present');
          alreadyPresent = true;
          break;
        } else {
          if (kDebugMode) print('Moving on the index');
        }
      }
      if (alreadyPresent == false) {
        if (amountController.text.trim().isNotEmpty) {
          double text = double.parse(amountController.text.trim());
          double result = (text * dataFromWeb['conversion_rates'][name]);
          addedCurrencies.add({'flag': flag, 'name': name, 'result': result});
        } else {
          addedCurrencies.add({'flag': flag, 'name': name, 'result': 0.00});
        }
      }
    } else {
      if (kDebugMode) print('Limit Reached');
    }
    notifyListeners();
  }

  // making the function for removing the currency
  void removeCurrencies(int index) {
    addedCurrencies.removeAt(index);
    notifyListeners();
  }

  void filteredListFilling() {
    if (searchController.text.trim().isNotEmpty) {
      searchController.clear();
    }
    filteredList = worldCountries;
  }

  void exchangeFilteredListFilling() {
    if (searchController.text.trim().isNotEmpty) {
      searchController.clear();
    }
    // exchangeFiltered = worldCountries.where();
  }

  void filteringResults(String t) {
    if (t.trim().isEmpty) {
      filteredList = worldCountries;
      notifyListeners();
    } else {
      final query = t.toLowerCase().trim();
      filteredList = worldCountries.where((e) {
        return e.name.toString().toLowerCase().contains(query) ||
            e.currencies!.first.code.toString().toLowerCase().contains(query);
      }).toList();
    }
    notifyListeners();
  }

  // making the function for the swapping button
  Future<void> swapping() async {
    String tempName = firstCurrency;
    String tempFlag = firstCurrencyFlag;
    String tempSymbolName = firstCurrSymbolName;

    firstCurrency = secondCurrency;
    firstCurrencyFlag = secondCurrencyFlag;
    firstCurrSymbolName = secondCurrSymbolName;

    secondCurrency = tempName;
    secondCurrencyFlag = tempFlag;
    secondCurrSymbolName = tempSymbolName;

    // if(kDebugMode) print(secondCurrency);
    await currencyRateFetching();
    changeOneCurrencyRate(secondCurrency);
    calculatingTheEnteredAmount();
    notifyListeners();
  }

  // making the function for getting the data
  Future<void> currencyRateFetching() async {
    dataFromWeb = '';
    try {
      isLoading = true;
      final url =
          'https://v6.exchangerate-api.com/v6/f1efdd7a5c01a15577188d9a/latest/$firstCurrency';
      final httpRequest = await http
          .get(Uri.parse(url))
          .timeout(Duration(seconds: 10));
      if (kDebugMode) print(httpRequest.statusCode);
      if (httpRequest.statusCode == 200) {
        dataFromWeb = json.decode(httpRequest.body);
        // now making the working of assigning to the oneCurrencyRate
        oneCurrencyRate = dataFromWeb['conversion_rates'][secondCurrency];
        if (kDebugMode) print(dataFromWeb);
        if (kDebugMode) print(oneCurrencyRate);
        final tm = DateTime.now().toLocal();
        updatedAt = DateFormat('MMMM dd yyyy h:mm a').format(tm);
      }
      isLoading = false;
    } catch (e) {
      if (kDebugMode) print('Network Error');
      isLoading = false;
    }
    notifyListeners();
  }

  // making a function that the oneCurrencyRate to change if secondCurrency Changes
  void changeOneCurrencyRate(String selectedCurrency) {
    oneCurrencyRate = (dataFromWeb['conversion_rates'][selectedCurrency] as num)
        .toDouble();
    notifyListeners();
  }

  // now making the function for the front page value conversion
  void calculatingTheEnteredAmount() {
    final shortForm = dataFromWeb['conversion_rates'];
    final formatType = NumberFormat('#,##0.00');
    if (amountController.text.trim().isEmpty) {
      convertedValue = 0.0;
      formattedResult = formatType.format(convertedValue);
    } else {
      double convertedText = double.parse(amountController.text.trim());
      convertedValue = (convertedText * shortForm[secondCurrency]);
      formattedResult = formatType.format(convertedValue);
    }
    addedCurrenciesCalculation();
    notifyListeners();
  }

  void addedCurrenciesCalculation() {
    final shortForm = dataFromWeb['conversion_rates'];
    if (addedCurrencies.isNotEmpty) {
      double convertedText = amountController.text.trim().isEmpty
          ? 0.0
          : double.parse(amountController.text.trim());
      for (int i = 0; i < addedCurrencies.length; i++) {
        addedCurrencies[i]['result'] =
            (convertedText * shortForm[addedCurrencies[i]['name']]);
      }
    } else {
      if (kDebugMode) print('No Currencies added');
    }
  }

  // making the function for the calculation of the popularCurrencies work
  void popularCurrenciesLocation() {
    double firstPopuMaking =
        (1 / (dataFromWeb['conversion_rates'][firstName]) as num).toDouble();
    double secondPopuMaking =
        (1 / (dataFromWeb['conversion_rates'][secondName]) as num).toDouble();
    double thirdPopuMaking =
        (1 / (dataFromWeb['conversion_rates'][thirdName]) as num).toDouble();
    firstPopuAmount = firstPopuMaking;
    secondPopuAmount = secondPopuMaking;
    thirdPopuAmount = thirdPopuMaking;
    notifyListeners();
  }

  // making the new function for the working overall
}
