import 'package:currency/Controller/providers.dart';
import 'package:currency/Models/popular_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class PopularStateManager extends StateNotifier<PopularState> {
  final Ref ref;
  PopularStateManager(this.ref) : super(PopularState());

  void assigningValues() {
    if (kDebugMode) print('Values are going to get assigned');
    final rf = ref.read(onlineProvider);
    final api = rf.dataFromWeb['conversion_rates'];
    state = state.copyWith(
      firstAmount: (1 / api[state.firstPopu] as num).toDouble(),
      secondAmount: (1 / api[state.secondPopu] as num).toDouble(),
      thirdAmount: (1 / api[state.thirdPopu] as num).toDouble(),
    );
  }

  // This below function for getting the data from storage

  void getPopu(double p1, p2, p3) {
    state = state.copyWith(firstAmount: p1, secondAmount: p2, thirdAmount: p3);
  }
}
