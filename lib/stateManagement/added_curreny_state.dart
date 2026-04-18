import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

class AddedCurrencies {
  List<Map<String, dynamic>> addedCurrencies;

  AddedCurrencies({required this.addedCurrencies});

  AddedCurrencies copyWith({List<Map<String, dynamic>>? addedCurrencies}) {
    return AddedCurrencies(
      addedCurrencies: addedCurrencies ?? this.addedCurrencies,
    );
  }
}

final addedCurrenState = StateNotifierProvider((ref) => AddedCurrenyState());

class AddedCurrenyState extends StateNotifier<AddedCurrencies> {
  AddedCurrenyState() : super(AddedCurrencies(addedCurrencies: []));

  // making the function for adding the currencies
  void addingCurrencies(String flag, String name, TextEditingController amount) {
    amount.clear();
      final lst = List<Map<String, dynamic>>.from(state.addedCurrencies);
    for(int i = 0; i < state.addedCurrencies.length; i++) {
      lst[i] = {
        ...lst[i],
        'result': 0
      };
    }
    state = state.copyWith(addedCurrencies: lst);
    final list = state.addedCurrencies;
    if (list.length < 5) {
      bool alreadyPresent = false;
      for (int i = 0; i < list.length; i++) {
        if (list[i]['name'] == name) {
          alreadyPresent = true;
          break;
        } else {
          if (kDebugMode) print('Moving on');
        }
      }
      if (alreadyPresent == false) {
        state = state.copyWith(
          addedCurrencies: [
            ...state.addedCurrencies,
            {'flag': flag, 'name': name, 'result': 0.00},
          ],
        );
      }
    }
  }

  // making function for removing
  void removingAddedCurrency(int index) {
    state = state.copyWith(
      addedCurrencies: List.from(state.addedCurrencies)..removeAt(index),
    );
  }

  void calculatingCurrencyValues(int index, double value) {
    final list = List<Map<String, dynamic>>.from(state.addedCurrencies);
    
  
    list[index] = {
      ...list[index],
      'result':value,
    };
    state = state.copyWith(addedCurrencies: list);
  }

  void calculatingZero(int index) {
    final list = List<Map<String, dynamic>>.from(state.addedCurrencies);
    list[index] = {
      ...list[index],
      'result': 0,
    };

    state = state.copyWith(addedCurrencies: list);
  }
}
