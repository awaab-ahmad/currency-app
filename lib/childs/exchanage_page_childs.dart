import 'package:currency/stateManagement/currency_state.dart';
import 'package:currency/stateManagement/filtered_state.dart';
import 'package:currency/stateManagement/icons_state.dart';
import 'package:currency/stateManagement/popular_state.dart';
import 'package:currency/widgets/all_containers.dart';
import 'package:currency/widgets/text_field_style.dart';
import 'package:currency/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Container currencyNameWidget(
  double h,
  double w,
  BuildContext context,
  WidgetRef ref,
  TextEditingController tc,
) {
  final c = Theme.of(context).colorScheme;
  final pro = ref.watch(currencyState);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 08, vertical: 05),
    width: w * 1.0,
    decoration: BoxDecoration(
      color: c.primary,
      borderRadius: .circular(20),
      boxShadow: [
        BoxShadow(
          color: c.onPrimary,
          blurRadius: 4,
          spreadRadius: 1,
          offset: Offset(0, 2),
          blurStyle: .normal,
        ),
      ],
    ),
    child: Column(
      children: [
        const SizedBox(height: 05),
        Container(
          width: w * 1.0,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 03),
          decoration: BoxDecoration(
            borderRadius: .circular(20),
            color: c.secondary,
          ),
          child: Row(
            mainAxisAlignment: .start,
            children: [
              gText(pro.fromCurrFlg, c.surface, h * 0.035, FontWeight.w600),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                children: [
                  gText(pro.fromCurrNm, c.surface, 16, FontWeight.w600),
                  gText(pro.fromCurrSymbol, c.surface, 12, FontWeight.w600),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 08),
        TextField(
          keyboardType: .text,
          controller: tc,
          onChanged: (value) {
            ref.read(filterNotifier.notifier).onChangedFiltering(value);
            ref.read(filterNotifier.notifier).changingSortType(0);
          },
          style: textFieldStyle(c.surface, 12),
          decoration: InputDecoration(
            labelText: 'Search Currency',
            labelStyle: textFieldStyle(c.surface, 13),
            hintText: 'e.g. PKR or Pakistan',
            hintStyle: textFieldStyle(c.surface, 12),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 0,
            ),
            visualDensity: VisualDensity(vertical: 4),
            isDense: true,
            fillColor: c.secondary,
            focusedBorder: focusedBorder(c.onPrimary),
            enabledBorder: enabledBorder(c.onPrimary),
          ),
        ),
        const SizedBox(height: 5),
      ],
    ),
  );
}

AnimatedContainer popularRatesWidget(
  double h,
  double w,
  BuildContext context,
  WidgetRef ref,
) {
  final c = Theme.of(context).colorScheme;
  final pro = ref.watch(popuState);
  return AnimatedContainer(
    clipBehavior: .antiAlias,
    duration: Duration(milliseconds: 400),
    curve: Curves.fastOutSlowIn,
    width: w * 1.0,
    height: h * exchangeRatePopularHeight,
    decoration: BoxDecoration(color: c.primary, borderRadius: .circular(20)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 08),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 05,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: .circular(20),
                    color: c.secondary,
                  ),
                  child: gText('Popular rates', c.surface, 12, FontWeight.w600),
                ),
                Card(
                  color: c.secondary,
                  margin: const EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(borderRadius: .circular(50)),
                  child: IconButton(
                    onPressed: () {                     
                      heightChangingOfContainerPopularRates(ref);
                    },
                    visualDensity: VisualDensity(vertical: -4),
                    icon: Icon(
                      ref.watch(iconProvider),
                      size: h * 0.04,
                      color: c.surface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 05),
            popularRatesContainer(
              h,
              c.secondary,
              c.surface,
              pro.firstFlg,
              pro.firstPopu,
              pro.firstAmount,
              ref,
            ),
            popularRatesContainer(
              h,
              c.secondary,
              c.surface,
              pro.secondFlg,
              pro.secondPopu,
              pro.secondAmount, 
              ref,
            ),
            popularRatesContainer(
              h,
              c.secondary,
              c.surface,
              pro.thirdFlg,
              pro.thirdPopu,
              pro.thirdAmount,
              ref,
            ),
          ],
        ),
      ),
    ),
  );
}
