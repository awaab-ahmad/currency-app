import 'package:currency/stateManagement/currency_state.dart';
import 'package:currency/stateManagement/filtered_state.dart';
import 'package:currency/stateManagement/popular_state.dart';
import 'package:currency/widgets/text_field_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangePGCurrency extends ConsumerWidget {
  final TextEditingController tc;
  const ExchangePGCurrency({super.key, required this.tc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final sz = MediaQuery.sizeOf(context);
    final t = Theme.of(context).textTheme;
    final r = ref.read(currencyState);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 08, vertical: 05),
      width: sz.width * 1.0,
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
            width: sz.width * 1.0,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 03),
            decoration: BoxDecoration(
              borderRadius: .circular(20),
              color: c.secondary,
            ),
            child: Row(
              mainAxisAlignment: .start,
              children: [
                Text(r.fromCurrFlg, style: t.displayLarge),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .center,
                  children: [
                    Text(r.fromCurrNm, style: t.titleLarge),
                    SizedBox(
                      width: sz.width * 0.65,
                      child: Text(r.fromCurrSymbol, style: t.bodyLarge),
                    ),
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
            style: t.bodyMedium,
            decoration: InputDecoration(
              labelText: 'Search Currency',
              labelStyle: t.bodyLarge,
              hintText: 'e.g. PKR or Pakistan',
              hintStyle: t.bodyMedium,
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
}

class PopularRates extends ConsumerWidget {
  const PopularRates({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context).textTheme;
    final pro = ref.watch(popuState);
    final c = Theme.of(context).colorScheme;
    return ExpansionTile(
      clipBehavior: .antiAlias,
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
      collapsedShape: RoundedRectangleBorder(borderRadius: .circular(15)),
      tilePadding: const .symmetric(horizontal: 8),
      childrenPadding: const .symmetric(horizontal: 8),
      backgroundColor: c.primary,
      collapsedBackgroundColor: c.primary,
      iconColor: c.surface,
      collapsedIconColor: c.surface,
      title: Text('Popular Rates', style: t.bodyMedium),
      children: [
        RatesContainer(
          flg: pro.firstFlg,
          curr: pro.firstPopu,
          value: pro.firstAmount,
        ),
        RatesContainer(
          flg: pro.secondFlg,
          curr: pro.secondPopu,
          value: pro.secondAmount,
        ),
        RatesContainer(
          flg: pro.thirdFlg,
          curr: pro.thirdPopu,
          value: pro.thirdAmount,
        ),
      ],
    );
  }
}

class RatesContainer extends ConsumerWidget {
  final String flg;
  final String curr;
  final double value;
  const RatesContainer({
    super.key,
    required this.flg,
    required this.curr,
    required this.value,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final fromNm = ref.read(currencyState.select((v) => v.fromCurrNm));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 06),
      margin: const EdgeInsets.symmetric(vertical: 03),
      decoration: BoxDecoration(
        color: c.secondary,
        borderRadius: .circular(15),
      ),
      child: Row(
        children: [
          Text(flg, style: t.displayLarge),
          const SizedBox(width: 10),
          Text(
            '1 $curr = ${value.toStringAsFixed(3)} $fromNm',
            style: t.bodyMedium,
          ),
        ],
      ),
    );
  }
}
