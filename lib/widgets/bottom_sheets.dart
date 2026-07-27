import 'package:currency/stateManagement/added_curreny_state.dart';
import 'package:currency/stateManagement/currency_state.dart';
import 'package:currency/stateManagement/filtered_state.dart';
import 'package:currency/stateManagement/online_state.dart';
import 'package:currency/stateManagement/popular_state.dart';
import 'package:currency/stateManagement/shared_preferences.dart';
import 'package:currency/widgets/text_field_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:world_countries/world_countries.dart';

// making the bottomSheet Structure
Future bottomSheet({required BuildContext context, required Widget child}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    isDismissible: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: child,
    ),
  );
}

class CurrencyPickFrom extends ConsumerWidget {
  final TextEditingController tc;
  final TextEditingController amount;
  const CurrencyPickFrom({super.key, required this.tc, required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final sz = MediaQuery.sizeOf(context);
    final t = Theme.of(context).textTheme;
    final lst = ref.watch(filterNotifier.select((v) => v.filteredList));
    return Container(
      height: sz.height * 0.75,
      width: sz.width * 1.0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 08),
      decoration: BoxDecoration(
        color: c.primaryContainer,
        borderRadius: const .vertical(top: .circular(30)),
      ),
      child: Consumer(
        builder: (context, rf, child) {
          return Column(
            crossAxisAlignment: .start,
            children: [
              Center(
                child: SizedBox(
                  height: 07,
                  width: 70,
                  child: Card(margin: EdgeInsets.zero, color: c.surface),
                ),
              ),
              const SizedBox(height: 10),
              Text('Search Currency', style: t.bodyLarge),
              const SizedBox(height: 05),
              Text('Search By country or currency code', style: t.bodySmall),
              const SizedBox(height: 10),
              TextField(
                controller: tc,
                style: t.bodyMedium,
                onChanged: (value) {
                  ref.read(filterNotifier.notifier).onChangedFiltering(value);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 02,
                  ),
                  isDense: true,
                  visualDensity: VisualDensity(vertical: 4),
                  labelText: 'Search Currency',
                  labelStyle: t.bodyLarge,
                  hintText: 'e.g. PKR or Pakistan',
                  hintStyle: t.bodyMedium,
                  focusedBorder: focusedBorder(c.onPrimary),
                  enabledBorder: enabledBorder(c.onPrimary),
                  filled: true,
                  fillColor: c.secondary,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: lst.length,
                  itemBuilder: (context, index) {
                    final country = lst[index];
                    final countryCode = country.currencies!.first.code;
                    final countryName = country.name;
                    final currencyFlag = country.emoji;
                    final symbolName =
                        country.currencies!.first.internationalName;
                    return Column(
                      children: [
                        Material(
                          color: const Color(0x00000000),
                          child: ListTile(
                            onTap: () async {
                              if (ref.read(currencyState).fromCurrNm !=
                                  countryCode) {
                                ref
                                    .read(currencyState.notifier)
                                    .fromCurrencyChanging(
                                      currencyFlag,
                                      countryCode,
                                      symbolName,
                                      amount,
                                    );
                                Navigator.of(context).pop();
                                if (kDebugMode) print('Changed');
                                await ref
                                    .read(onlineProvider.notifier)
                                    .helperWorker(() {
                                      ref
                                          .read(popuState.notifier)
                                          .assigningValues();
                                    });
                                await ref
                                    .read(storageNotifier.notifier)
                                    .savingMainData();
                              } else {
                                Navigator.of(context).pop();
                                if (kDebugMode) print('Same One');
                              }
                            },
                            contentPadding: const .symmetric(horizontal: 10),
                            leading: Text(country.emoji, style: t.displayLarge),
                            title: Text(countryCode, style: t.bodyLarge),
                            subtitle: Text('$countryName', style: t.bodyMedium),
                            trailing: Text(
                              '${country.currencies!.first.symbol}',
                              style: t.titleLarge,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                          width: sz.width * 1.0,
                          child: Card(margin: .zero, color: c.outlineVariant),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CurrencyPickTo extends ConsumerWidget {
  final TextEditingController tc;
  final TextEditingController amount;
  const CurrencyPickTo({super.key, required this.tc, required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final sz = MediaQuery.sizeOf(context);
    final t = Theme.of(context).textTheme;
    final lst = ref.watch(filterNotifier.select((v) => v.filteredList));
    return Container(
      height: sz.height * 0.75,
      width: sz.width * 1.0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 08),
      decoration: BoxDecoration(
        color: c.primaryContainer,
        borderRadius: const .vertical(top: .circular(30)),
      ),
      child: Consumer(
        builder: (context, rf, child) {
          return Column(
            crossAxisAlignment: .start,
            children: [
              Center(
                child: SizedBox(
                  height: 07,
                  width: 70,
                  child: Card(margin: EdgeInsets.zero, color: c.surface),
                ),
              ),
              const SizedBox(height: 10),
              Text('Search Currency', style: t.bodyLarge),
              const SizedBox(height: 05),
              Text('Search By country or currency code', style: t.bodySmall),
              const SizedBox(height: 10),
              TextField(
                controller: tc,
                style: t.bodyMedium,
                onChanged: (value) {
                  ref.read(filterNotifier.notifier).onChangedFiltering(value);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 02,
                  ),
                  isDense: true,
                  visualDensity: const VisualDensity(vertical: 4),
                  labelText: 'Search Currency',
                  labelStyle: t.bodyLarge,
                  hintText: 'e.g. PKR or Pakistan',
                  hintStyle: t.bodyMedium,
                  focusedBorder: focusedBorder(c.onPrimary),
                  enabledBorder: enabledBorder(c.onPrimary),
                  filled: true,
                  fillColor: c.secondary,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: lst.length,
                  itemBuilder: (context, index) {
                    final country = lst[index];
                    final countryCode = country.currencies!.first.code;
                    final countryName = country.name;
                    final currencyFlag = country.emoji;
                    final symbolName =
                        country.currencies!.first.internationalName;
                    return Column(
                      children: [
                        Material(
                          color: const Color(0x00000000),
                          child: ListTile(
                            onTap: () async {
                              ref
                                  .read(currencyState.notifier)
                                  .toCurrencyChaning(
                                    currencyFlag,
                                    countryCode,
                                    symbolName,
                                    amount,
                                  );
                              Navigator.of(context).pop();
                              ref
                                  .read(onlineProvider.notifier)
                                  .oneCurrencyRateChanging(countryCode);
                              await ref
                                  .read(storageNotifier.notifier)
                                  .savingMainData();
                            },
                            contentPadding: const .symmetric(horizontal: 10),
                            leading: Text(country.emoji, style: t.displayLarge),
                            title: Text(countryCode, style: t.bodyLarge),
                            subtitle: Text('$countryName', style: t.bodyMedium),
                            trailing: Text(
                              '${country.currencies!.first.symbol}',
                              style: t.titleLarge,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                          width: sz.width * 1.0,
                          child: Card(margin: .zero, color: c.outlineVariant),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AddCurrencySheet extends ConsumerWidget {
  final TextEditingController tc;
  final TextEditingController amount;
  const AddCurrencySheet({super.key, required this.tc, required this.amount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sz = MediaQuery.sizeOf(context);
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final lst = ref.watch(filterNotifier.select((v) => v.filteredList));
    return Container(
      height: sz.height * 0.75,
      width: sz.width * 1.0,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 08),
      decoration: BoxDecoration(
        color: c.primaryContainer,
        borderRadius: const .vertical(top: .circular(30)),
      ),
      child: Consumer(
        builder: (context, rf, child) {
          return Column(
            crossAxisAlignment: .start,
            children: [
              Center(
                child: SizedBox(
                  height: 07,
                  width: 70,
                  child: Card(margin: EdgeInsets.zero, color: c.surface),
                ),
              ),
              const SizedBox(height: 10),
              Text('Choose Country', style: t.bodyLarge),
              const SizedBox(height: 05),
              Text('Search by country name or code', style: t.bodyMedium),
              const SizedBox(height: 10),
              TextField(
                controller: tc,
                onChanged: (value) {
                  rf.read(filterNotifier.notifier).onChangedFiltering(value);
                  if (kDebugMode) print(value);
                },
                style: t.bodyMedium,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 02,
                  ),
                  isDense: true,
                  visualDensity: VisualDensity(vertical: 4),
                  labelText: 'Search Currency',
                  labelStyle: t.bodyLarge,
                  hintText: 'e.g. pakistan',
                  hintStyle: t.bodyMedium,
                  focusedBorder: focusedBorder(c.onPrimary),
                  enabledBorder: enabledBorder(c.onPrimary),
                  filled: true,
                  fillColor: c.secondary,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: lst.length,
                  itemBuilder: (context, index) {
                    final country = lst[index];
                    final flag = country.emoji;
                    final currency = country.currencies!.first.code;
                    return Column(
                      children: [
                        Material(
                          color: const Color(0x00000000),
                          child: ListTile(
                            onTap: () async {
                              rf
                                  .read(addedCurrenState.notifier)
                                  .addingCurrencies(flag, currency, amount);
                              rf.read(currencyState.notifier).convertedZero();
                              Navigator.of(context).pop();
                              await rf
                                  .read(storageNotifier.notifier)
                                  .addedCurrenciesSaving();
                            },
                            contentPadding: const .symmetric(horizontal: 10),
                            leading: Text(flag, style: t.titleLarge),
                            title: Text(currency, style: t.bodyLarge),
                            subtitle: Text(
                              country.name.common,
                              style: t.bodyLarge,
                            ),
                            trailing: Text(
                              '${country.currencies!.first.symbol}',
                              style: t.titleLarge,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                          width: sz.width * 1.0,
                          child: Card(margin: .zero, color: c.outlineVariant),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FilteringSheet extends ConsumerWidget {
  const FilteringSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final sz = MediaQuery.sizeOf(context);
    final t = Theme.of(context).textTheme;
    final sortVal = ref.read(filterNotifier.select((v) => v.sortFilterValue));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 08),
      height: sz.height * 0.25,
      width: sz.width * 0.9,
      decoration: BoxDecoration(
        color: c.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Consumer(
        builder: (context, rf, child) => Column(
          children: [
            SizedBox(
              height: 07,
              width: 70,
              child: Card(margin: EdgeInsets.zero, color: c.surface),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text('Sort By', style: t.bodyLarge),
                Icon(
                  Icons.filter_alt_outlined,
                  color: c.surface,
                  size: sz.height * 0.045,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: rf.read(filterNotifier).sortFilter.length,
                itemBuilder: (context, index) {
                  final value = rf.read(filterNotifier).sortFilter[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
                      alignment: .centerLeft,
                      backgroundColor: c.primary,
                      side: BorderSide(
                        width: 1.8,
                        color: sortVal == index
                            ? c.surface
                            : const Color(0x00000000),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(20),
                      ),
                    ),
                    onPressed: () {
                      if (sortVal != index) {
                        rf
                            .read(filterNotifier.notifier)
                            .changingSortType(index);
                        rf.read(filterNotifier.notifier).filteringData();
                      } else {
                        if (kDebugMode) print('Same already');
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('${index + 1}: $value', style: t.bodyMedium),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
