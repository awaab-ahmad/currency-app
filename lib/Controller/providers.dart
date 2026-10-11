import 'package:currency/Controller/state/added_curreny_state.dart';
import 'package:currency/Controller/state/currency_state.dart';
import 'package:currency/Controller/state/filtered_state.dart';
import 'package:currency/Controller/state/online_state.dart';
import 'package:currency/Controller/state/popular_state.dart';
import 'package:currency/Controller/state/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final addedCurrenState = StateNotifierProvider((ref) => AddedCurrenyState());
final currencyState = StateNotifierProvider((ref) => CurrencyState(ref));
final filterNotifier = StateNotifierProvider((ref) => FilterPod());
final iconProvider = StateProvider((ref) => Icons.keyboard_arrow_down);
final onlineProvider = StateNotifierProvider((ref) => OnlineState(ref));
final storageNotifier = StateNotifierProvider<Storage, Shared>(
  (ref) => Storage(ref),
);
final popuState = StateNotifierProvider((ref) => PopularStateManager(ref));
