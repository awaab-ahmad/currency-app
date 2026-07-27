import 'package:currency/childs/currency_page_childs.dart';
import 'package:currency/childs/exchanage_page_childs.dart';
import 'package:currency/stateManagement/currency_state.dart';
import 'package:currency/stateManagement/filtered_state.dart';
import 'package:currency/stateManagement/online_state.dart';
import 'package:currency/widgets/bottom_sheets.dart';
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
