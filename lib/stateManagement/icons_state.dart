import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final iconProvider = StateProvider((ref) => Icons.keyboard_arrow_down);
double exchangeRatePopularHeight = 0.08;
final iconBoolLogic = StateProvider((ref) => false);

// now making its required things

void heightChangingOfContainerPopularRates(WidgetRef ref) {
    ref.read(iconBoolLogic.notifier).update((state) => !state);
    if(ref.watch(iconBoolLogic) == true) {
      exchangeRatePopularHeight = 0.28;
      ref.read(iconProvider.notifier).update((st) => Icons.keyboard_arrow_up);
    } else {
      exchangeRatePopularHeight = 0.08;
      ref.read(iconProvider.notifier).update((st) => Icons.keyboard_arrow_down);
    }  
}
