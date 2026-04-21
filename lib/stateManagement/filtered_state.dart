import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:world_countries/world_countries.dart';

class FilteredListState {
  final List<WorldCountry> filteredList;
  final List<String> sortFilter = [
    'Alphabetical (A - Z)',
    'Alphabetical (Z - A)',
  ];
  int sortFilterValue;

  FilteredListState({
    required this.filteredList,
    required this.sortFilterValue,
  });

  FilteredListState copyWith({
    List<WorldCountry>? filteredList,
    int? sortFilterValue,
  }) {
    return FilteredListState(
      filteredList: filteredList ?? this.filteredList,
      sortFilterValue: sortFilterValue ?? this.sortFilterValue,
    );
  }
}

// now making the variable of it
final filterNotifier = StateNotifierProvider((ref) => FilterPod());

class FilterPod extends StateNotifier<FilteredListState> {
  FilterPod()
    : super(
        FilteredListState(
          filteredList: WorldCountry.list.where((c) => c.independent).toList(),
          sortFilterValue: 0,
        ),
      );

  // filling filtered List
  void filteredListFilling(TextEditingController tc) {
    if (tc.text.trim().isNotEmpty) {
      tc.clear();
    }
    state = state.copyWith(
      filteredList: WorldCountry.list.where((c) => c.independent).toList(),
    );
  }

  // making the function of the TextField onChanged State
  void onChangedFiltering(String tc) {
    if (tc.trim().isEmpty) {
      state = state.copyWith(
        filteredList: WorldCountry.list.where((c) => c.independent).toList(),
      );
    } else {
      final query = tc.toLowerCase().trim();
      state = state.copyWith(
        filteredList: WorldCountry.list.where((e) {
          final countryName = e.name.toString().toLowerCase().contains(query);
          final code =
              e.currencies?.any((c) => c.code.toLowerCase().contains(query)) ??
              false;
          return countryName || code;
        }).toList(),
      );
    }
  }

  // making the function for changing the value of sortFilterIndex
  void changingSortType(int index) {
    state = state.copyWith(sortFilterValue: index);
    if (kDebugMode) print('New value is: ${state.sortFilterValue}');
  }

  // now making the working of the filtering of the values
  void filteringData() {
    final lst = List<WorldCountry>.from(state.filteredList);
    switch (state.sortFilterValue) {
      case 0:
        lst.sort((a, b) {
          return a.compareTo(b);
        });
        break;

      case 1:
        lst.sort((a, b) {
          return b.compareTo(a);
        });
        break;
    }

    state = state.copyWith(filteredList: lst);
  }
}
