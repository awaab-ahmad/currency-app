class AddedCurrencies {
  List<Map<String, dynamic>> addedCurrencies;

  AddedCurrencies({required this.addedCurrencies});

  AddedCurrencies copyWith({List<Map<String, dynamic>>? addedCurrencies}) {
    return AddedCurrencies(
      addedCurrencies: addedCurrencies ?? this.addedCurrencies,
    );
  }
}
