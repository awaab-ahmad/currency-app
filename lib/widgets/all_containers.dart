import 'package:currency/stateManagement/river_pod_state.dart';
import 'package:currency/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

BoxShadow containerDesign(Color c) {
  return BoxShadow(
    color: c,
    blurRadius: 4,
    spreadRadius: 1,
    offset: Offset(0, 2),
    blurStyle: .normal,
  );
}


Container popularRatesContainer(
  double h,
  Color c,
  Color textc,
  String flag, 
  String cType,
  double result,
  WidgetRef ref
) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 06),
    margin: const EdgeInsets.symmetric(vertical: 03),
    decoration: BoxDecoration(color: c, borderRadius: .circular(15)),
    child: Row(
      children: [
        gText(flag, c, h * 0.025, FontWeight.w600),
        const SizedBox(width: 10),
        gText(
          '1 $cType = ${result.toStringAsFixed(3)} ${ref.watch(stateManagementClass).firstCurrency}',
          textc,
          12,
          FontWeight.w600,
        ),
      ],
    ),
  );
}

Container currenciesContainer(double h, Color textc, Color c) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 05),
    decoration: BoxDecoration(
      color: c, 
      borderRadius: .circular(20),
      boxShadow: [
        BoxShadow(
            color: const Color(0xB3919191),
            blurRadius: 0.5,
            spreadRadius: 0.5,
            blurStyle: .normal,
            offset: Offset(0, 2)
        )
      ],
    ),
    child: gText('Currencies', textc, 14, FontWeight.w600)
  );
}
