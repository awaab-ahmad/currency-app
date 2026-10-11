
import 'package:world_countries/world_countries.dart';

class PopularState {
  String firstFlg;
  String firstPopu;
  double firstAmount;
  String secondFlg;
  String secondPopu;
  double secondAmount;
  String thirdFlg;
  String thirdPopu;
  double thirdAmount;

  PopularState({
    String? firstFLg,
    String? secondFlg,
    String? thirdFlg,
    this.firstPopu = 'USD',
    this.secondPopu = 'GBP',
    this.thirdPopu = 'EUR',
    this.firstAmount = 0.0,
    this.secondAmount = 0.0,
    this.thirdAmount = 0.0,
  }) : firstFlg =
           firstFLg ??
           WorldCountry.list.firstWhere((c) => c.code == 'USA').emoji,
       secondFlg =
           secondFlg ??
           WorldCountry.list.firstWhere((c) => c.code == 'GBR').emoji,
       thirdFlg =
           thirdFlg ??
           WorldCountry.list.firstWhere((c) => c.code == 'ITA').emoji;

  PopularState copyWith({
    double? firstAmount,
    double? secondAmount,
    double? thirdAmount,
  }) {
    return PopularState(
      firstAmount: firstAmount ?? this.firstAmount,
      secondAmount: secondAmount ?? this.secondAmount,
      thirdAmount: thirdAmount ?? this.thirdAmount,
    );
  }
}