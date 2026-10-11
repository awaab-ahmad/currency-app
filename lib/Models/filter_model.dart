
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