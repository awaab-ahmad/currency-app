import 'package:currency/Controller/providers.dart';
import 'package:currency/View/widgets/bottom_sheets.dart';
import 'package:currency/View/widgets/date_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangeRatePage extends ConsumerWidget {
  ExchangeRatePage({super.key});
  final TextEditingController srcController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final sz = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: c.surface,
              size: sz.height * 0.04,
            ),
          ),
          title: Text('Exchange Rate', style: t.titleLarge),
          toolbarHeight: sz.height * 0.06,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: .center,
            children: [
              const SizedBox(height: 10),
              const DateWidget(),
              const SizedBox(height: 08),
              ExchangePGCurrency(tc: srcController),
              const SizedBox(height: 08),
              const PopularRates(),
              const SizedBox(height: 08),
              const FilterLine(),
              const SizedBox(height: 05),
              const _AllExchangeRates(),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterLine extends StatelessWidget {
  const FilterLine({super.key});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        const ExchangeCurrCont(),
        ElevatedButton(
          style: filterButtonStyle(sz.width, sz.height, c.secondary),
          onPressed: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusManager.instance.primaryFocus?.unfocus();
            });
            showModalBottomSheet(
              backgroundColor: const Color(0x00000000),
              isDismissible: true,
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: const FilteringSheet(),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: .center,
            children: [
              Text('Filter By', style: t.bodyMedium),
              Icon(
                Icons.arrow_drop_down,
                color: c.surface,
                size: sz.height * 0.04,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static ButtonStyle filterButtonStyle(double w, double h, Color c) {
    return ElevatedButton.styleFrom(
      elevation: 3,
      padding: const EdgeInsets.symmetric(),
      backgroundColor: c,
      visualDensity: VisualDensity(vertical: -4),
      fixedSize: Size(w * 0.3, h * 0.05),
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
    );
  }
}

class ExchangeCurrCont extends StatelessWidget {
  const ExchangeCurrCont({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 05),
      decoration: BoxDecoration(
        color: c.secondary,
        borderRadius: .circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xB3919191),
            blurRadius: 0.5,
            spreadRadius: 0.5,
            blurStyle: .normal,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text('Currencies', style: t.bodyLarge),
    );
  }
}

class _AllExchangeRates extends ConsumerWidget {
  const _AllExchangeRates();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lst = ref.watch(filterNotifier.select((v) => v.filteredList));
    final data = ref.watch(onlineProvider.select((v) => v.dataFromWeb));
    final currNm = ref.watch(currencyState.select((v) => v.fromCurrNm));
    final t = Theme.of(context).textTheme;
    final c = Theme.of(context).colorScheme;
    final sz = MediaQuery.sizeOf(context);
    return Expanded(
      child: Card(
        margin: const EdgeInsets.all(0),
        clipBehavior: .antiAlias,
        color: const Color(0x00000000),
        elevation: 0,
        child: ListView.builder(
          itemCount: lst.length,
          itemBuilder: (context, index) {
            final country = lst[index];
            final countryCode = country.currencies!.first.code;
            final countryName = country.name;
            dynamic api = data['conversion_rates'][countryCode];
            dynamic result;
            if (api != null) {
              result = (1 / api);
            } else {
              result = 0;
            }
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: Text(country.emoji, style: t.displayLarge),
                  title: Text(
                    '1 $countryCode = ${result.toStringAsFixed(3)} $currNm',
                    style: t.bodyMedium,
                  ),
                  subtitle: Text(countryName.toString(), style: t.bodyMedium),
                ),
                SizedBox(
                  height: 3,
                  width: sz.width * 1.0,
                  child: Card(
                    color: c.outlineVariant,
                    margin: const EdgeInsets.all(0),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

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
