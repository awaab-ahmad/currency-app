import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:world_countries/world_countries.dart';

class FilteredListState {
  final List<WorldCountry> filteredList;

  FilteredListState({required this.filteredList});

  FilteredListState copyWith({List<WorldCountry>? filteredList}) {
    return FilteredListState(filteredList: filteredList ?? this.filteredList);
  }
}

// now making the variable of it
final filterNotifier = StateNotifierProvider((ref) => FilterPod());

class FilterPod extends StateNotifier<FilteredListState> {
  FilterPod()
    : super(
        FilteredListState(
          filteredList: WorldCountry.list.where((c) => c.independent).toList(),
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
}
