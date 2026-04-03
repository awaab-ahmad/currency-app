import 'package:currency/stateManagement/river_pod_state.dart';
import 'package:currency/widgets/text_field_style.dart';
import 'package:currency/widgets/text_style.dart';
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

Container currencyPickerFromSheet(
  double h,
  double w,
  BuildContext context,
  WidgetRef ref,
) {
  final c = Theme.of(context).colorScheme;
  return Container(
    height: h * 0.75,
    width: w * 1.0,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 08),
    decoration: BoxDecoration(
      color: c.primaryContainer,
      borderRadius: .vertical(top: .circular(30)),
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
            gText('Search Currency', c.surface, 15, FontWeight.w500),
            const SizedBox(height: 05),
            gText(
              'Search By country or currency code',
              c.surface,
              11,
              FontWeight.w500,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: rf.watch(stateManagementClass).searchController,
              style: textFieldStyle(c.surface, 12),
              onChanged: (value) {
                rf.read(stateManagementClass).filteringResults(value);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 02,
                ),
                isDense: true,
                visualDensity: VisualDensity(vertical: 4),
                labelText: 'Search Currency',
                labelStyle: textFieldStyle(c.surface, 14),
                hintText: 'e.g. PKR or Pakistan',
                hintStyle: textFieldStyle(c.surface, 12),
                focusedBorder: focusedBorder(c.onPrimary),
                enabledBorder: enabledBorder(c.onPrimary),
                filled: true,
                fillColor: c.secondary,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: rf.watch(stateManagementClass).filteredList.length,
                itemBuilder: (context, index) {
                  final country = rf
                      .watch(stateManagementClass)
                      .filteredList[index];
                  final currencyISOCode =
                      country.currencies!.first.iso4217Letter;
                  final currencyFlag = country.emoji;
                  final symbolName =
                      country.currencies!.first.internationalName;
                  return Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          final r = ref.read(stateManagementClass);
                          if (kDebugMode) {
                            print(
                              'Currency Type: ${country.currencies!.first.internationalName}',
                            );
                          }
                          if (r.firstCurrency != currencyISOCode) {
                            r.assigningFromCurrency(
                              currencyISOCode,
                              currencyFlag,
                              symbolName,
                            );
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                            await r.currencyRateFetching();
                          } else {
                            if (kDebugMode) print('Same currency');
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                          }
                        },
                        contentPadding: .symmetric(horizontal: 10),
                        leading: gText(
                          country.emoji,
                          c.surface,
                          h * 0.03,
                          FontWeight.w600,
                        ),
                        title: gText(
                          country.currencies!.first.code,
                          c.surface,
                          14,
                          FontWeight.w700,
                        ),
                        subtitle: gText(
                          country.name.common,
                          c.surface,
                          12,
                          FontWeight.w600,
                        ),
                        trailing: gText(
                          '${country.currencies!.first.symbol}',
                          c.surface,
                          16,
                          FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                        width: w * 1.0,
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

Container currencyPickerToSheet(
  double h,
  double w,
  BuildContext context,
  WidgetRef ref,
) {
  final c = Theme.of(context).colorScheme;
  return Container(
    height: h * 0.75,
    width: w * 1.0,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 08),
    decoration: BoxDecoration(
      color: c.primaryContainer,
      borderRadius: .vertical(top: .circular(30)),
    ),
    child: Consumer(
      builder: (context, rf, child) => Column(
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
          gText('Search Currency', c.surface, 15, FontWeight.w500),
          const SizedBox(height: 05),
          gText(
            'Search By country or currency code',
            c.surface,
            11,
            FontWeight.w500,
          ),
          const SizedBox(height: 10),
          TextField(
            controller: rf.watch(stateManagementClass).searchController,
            onChanged: (value) {
              rf.read(stateManagementClass).filteringResults(value);
            },
            style: textFieldStyle(c.surface, 12),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 02,
              ),
              isDense: true,
              visualDensity: VisualDensity(vertical: 4),
              labelText: 'Search Currency',
              labelStyle: textFieldStyle(c.surface, 14),
              hintText: 'e.g. PKR or Pakistan',
              hintStyle: textFieldStyle(c.surface, 12),
              focusedBorder: focusedBorder(c.onPrimary),
              enabledBorder: enabledBorder(c.onPrimary),
              filled: true,
              fillColor: c.secondary,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: rf.watch(stateManagementClass).filteredList.length,
              itemBuilder: (context, index) {
                final country = ref
                    .watch(stateManagementClass)
                    .filteredList[index];
                final currencyType = country.currencies!.first.iso4217Letter;
                final currencyFlag = country.emoji;
                final symbolName = country.currencies!.first.internationalName;
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        ref
                            .read(stateManagementClass)
                            .assigningToCurrency(
                              currencyType,
                              currencyFlag,
                              symbolName,
                            );
                        ref
                            .read(stateManagementClass)
                            .changeOneCurrencyRate(currencyType);
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                      contentPadding: .symmetric(horizontal: 10),
                      leading: gText(
                        country.emoji,
                        c.surface,
                        h * 0.03,
                        FontWeight.w600,
                      ),
                      title: gText(
                        currencyType,
                        c.surface,
                        14,
                        FontWeight.w700,
                      ),
                      subtitle: gText(
                        country.name.common,
                        c.surface,
                        12,
                        FontWeight.w600,
                      ),
                      trailing: gText(
                        '${country.currencies!.first.symbol}',
                        c.surface,
                        16,
                        FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 3,
                      width: w * 1.0,
                      child: Card(margin: .zero, color: c.outlineVariant),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

// making the Bottom Sheet for add Currency
Container addCurrencySheet(
  double h,
  double w,
  BuildContext context,
  WidgetRef ref,
  TextEditingController searchController,
) {
  final c = Theme.of(context).colorScheme;
  return Container(
    height: h * 0.75,
    width: w * 1.0,
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 08),
    decoration: BoxDecoration(
      color: c.primaryContainer,
      borderRadius: .vertical(top: .circular(30)),
    ),
    child: Consumer(
      builder: (context, rf, child) {
        final state = rf.watch(stateManagementClass);
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
            gText('Choose Country', c.surface, 15, FontWeight.w500),
            const SizedBox(height: 05),
            gText(
              'Search by country name or code',
              c.surface,
              11,
              FontWeight.w500,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: searchController,
              onChanged: (value) {
                state.filteringResults(value);
                if (kDebugMode) print(value);
              },
              style: textFieldStyle(c.surface, 12),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 02,
                ),
                isDense: true,
                visualDensity: VisualDensity(vertical: 4),
                labelText: 'Search Currency',
                labelStyle: textFieldStyle(c.surface, 14),
                hintText: 'e.g. pakistan',
                hintStyle: textFieldStyle(c.surface, 12),
                focusedBorder: focusedBorder(c.onPrimary),
                enabledBorder: enabledBorder(c.onPrimary),
                filled: true,
                fillColor: c.secondary,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: ref.watch(stateManagementClass).filteredList.length,
                itemBuilder: (context, index) {
                  final country = ref
                      .watch(stateManagementClass)
                      .filteredList[index];
                  final flag = country.emoji;
                  final currency = country.currencies!.first.iso4217Letter;
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          ref
                              .read(stateManagementClass)
                              .addingCurrencies(flag, currency);
                          Navigator.of(context).pop();
                        },
                        contentPadding: .symmetric(horizontal: 10),
                        leading: gText(
                          flag,
                          c.surface,
                          h * 0.03,
                          FontWeight.w600,
                        ),
                        title: gText(currency, c.surface, 14, FontWeight.w700),
                        subtitle: gText(
                          country.name.common,
                          c.surface,
                          12,
                          FontWeight.w600,
                        ),
                        trailing: gText(
                          '${country.currencies!.first.symbol}',
                          c.surface,
                          16,
                          FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 3,
                        width: w * 1.0,
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

// making the final sheet of the Filters
Container filterSheet(double h, double w, BuildContext context, WidgetRef ref) {
  final c = Theme.of(context).colorScheme;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 08),
    height: h * 0.4,
    width: w * 0.9,
    decoration: BoxDecoration(
      color: c.primaryContainer,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
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
            gText('Sort By', c.surface, 14, FontWeight.w600),
            Icon(Icons.filter_alt_outlined, color: c.surface, size: h * 0.045),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: ref.watch(stateManagementClass).filterTypes.length,
            itemBuilder: (context, index) {
              final value = ref.read(stateManagementClass).filterTypes[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 05,
                ),
                margin: EdgeInsets.symmetric(vertical: 04),
                width: w * 1.0,
                height: h * 0.055,
                decoration: BoxDecoration(
                  color: c.outlineVariant,
                  borderRadius: .circular(12),
                ),
                child: Align(
                  alignment: .centerLeft,
                  child: gText(
                    '${index + 1}: $value',
                    c.surface,
                    12,
                    FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
