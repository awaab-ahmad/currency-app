import 'package:currency/stateManagement/river_pod_state.dart';
import 'package:currency/widgets/bottom_sheets.dart';
import 'package:currency/widgets/button_styles.dart';
import 'package:currency/widgets/text_field_style.dart';
import 'package:currency/widgets/all_containers.dart';
import 'package:currency/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Container updatedDateWidget(double h, double w, BuildContext context, WidgetRef ref) {
  final c = Theme.of(context).colorScheme;
  return Container(   
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 05),
    decoration: BoxDecoration(
      borderRadius: .circular(15),
      color: c.primary,
    ),
    height: h * 0.05,
    width: w * 1.0,
    child: Align(
      alignment: .centerLeft,
      child: gText(
        'Last Updated: ${ref.watch(stateManagementClass).updatedAt}',
        c.surface,
        10,
        FontWeight.w600,
      ),
    ),
  );
}

Container currencyFromToWidget(
  double h,
  double w,
  BuildContext context,
  WidgetRef ref,
  final provider,
) {
  final c = Theme.of(context).colorScheme;
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 08, vertical: 05),
    width: w * 1.0,
    decoration: BoxDecoration(
      color: c.primary,
      borderRadius: .circular(20),
      boxShadow: [containerDesign(c.onPrimary)],
    ),
    child: Column(
      children: [
        const SizedBox(height: 05),
        TextField(
          keyboardType: .number,
          controller: provider.amountController,
          onChanged: (value) {
            ref.read(stateManagementClass).calculatingTheEnteredAmount();
          },
          style: textFieldStyle(c.surface, 12),
          decoration: InputDecoration(
            labelText: 'Enter Amount',
            labelStyle: textFieldStyle(c.surface, 14),
            hintText: 'e.g. 100',
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
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(stateManagementClass).filteredListFilling();
                bottomSheet(
                  context: context,
                  child: currencyPickerFromSheet(h, w, context, ref),
                );
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                });
              },
              style: currencyStyle(w, h, c.secondary),
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  gText(
                    provider.firstCurrencyFlag,
                    c.surface,
                    h * 0.03,
                    FontWeight.w600,
                  ),
                  const SizedBox(width: 5),
                  gText(provider.firstCurrency, c.surface, 16, FontWeight.w700),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_drop_down, color: c.surface, size: w * 0.1),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(stateManagementClass).filteredListFilling();
                bottomSheet(
                  context: context,
                  child: currencyPickerToSheet(h, w, context, ref),
                );
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                });
              },
              style: currencyStyle(w, h, c.secondary),
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  gText(
                    provider.secondCurrencyFlag,
                    c.surface,
                    h * 0.03,
                    FontWeight.w600,
                  ),
                  const SizedBox(width: 5),
                  gText(
                    provider.secondCurrency,
                    c.surface,
                    16,
                    FontWeight.w700,
                  ),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_drop_down, color: c.surface, size: w * 0.1),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            gText(
              '1 ${provider.firstCurrency} = ${ref.watch(stateManagementClass).oneCurrencyRate.toStringAsFixed(5)} ${provider.secondCurrency}',
              c.surface,
              14,
              FontWeight.w600,
            ),
            IconButton(
              onPressed: () async {
                await ref.read(stateManagementClass).swapping();
              },
              visualDensity: VisualDensity(vertical: -4),
              padding: .zero,
              icon: Image.asset(
                'images/alter.png',
                height: h * 0.033,
                color: c.surface,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Container resultWidget(double h, double w, BuildContext context, final p) {
  final c = Theme.of(context).colorScheme;
  return Container(
    padding: EdgeInsets.all(0),
    decoration: BoxDecoration(color: c.primary, borderRadius: .circular(20)),
    width: w * 1.0,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
      margin: EdgeInsets.all(10),
      color: c.secondary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                gText(
                  p.secondCurrencyFlag,
                  c.surface,
                  h * 0.03,
                  FontWeight.w600,
                ),
                const SizedBox(width: 10),
                gText(p.secondCurrency, c.surface, 18, FontWeight.w600),
              ],
            ),
            gText(p.formattedResult, c.surface, 22, FontWeight.w700),
          ],
        ),
      ),
    ),
  );
}

Container addedCurrenciesWidget(
  double h,
  double w,
  BuildContext context,
  WidgetRef ref,
  final p,
) {
  final c = Theme.of(context).colorScheme;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 08),
    height: h * 0.3,
    width: w * 1.0,
    decoration: BoxDecoration(color: c.primary, borderRadius: .circular(20)),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: .start,
          children: [
            gText('Added Currencies', c.surface, 14, FontWeight.w600),
            const Expanded(child: SizedBox()),
            gText(
              '(${p.addedCurrencies.length} / 5)',
              c.surface,
              16,
              FontWeight.w700,
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
        Expanded(
          child: p.addedCurrencies.isEmpty
              ? Center(
                  child: gText(
                    'No currencies added',
                    c.surface,
                    12,
                    FontWeight.w600,
                  ),
                )
              : Card(
                  color: const Color(0x00000000),
                  shadowColor: const Color(0x00000000),
                  elevation: 0,
                  clipBehavior: .antiAlias,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, -0.2),
                          end: Offset(0, 0),
                        ).animate(animation),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: ListView.builder(
                      key: ValueKey(p.addedCurrencies.length),
                      itemCount: p.addedCurrencies.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 03),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 1,
                          ),
                          width: w * 1.0,
                          decoration: BoxDecoration(
                            color: c.secondary,
                            borderRadius: .circular(20),
                          ),
                          child: Row(
                            children: [
                              gText(
                                p.addedCurrencies[index]['flag'],
                                c.surface,
                                h * 0.03,
                                FontWeight.w600,
                              ),
                              const SizedBox(width: 08),
                              gText(
                                p.addedCurrencies[index]['name'],
                                c.surface,
                                14,
                                FontWeight.w600,
                              ),
                              const SizedBox(width: 08),
                              Expanded(
                                child: SizedBox(
                                  height: 28,
                                  child: FittedBox(
                                    child: gText(
                                      '${p.addedCurrencies[index]['result'].toStringAsFixed(2)}',
                                      c.surface,
                                      16,
                                      FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 05),
                              IconButton(
                                onPressed: () {
                                  ref
                                      .read(stateManagementClass)
                                      .removeCurrencies(index);
                                },
                                visualDensity: VisualDensity(vertical: -2),
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.delete,
                                  size: h * 0.04,
                                  color: c.outlineVariant,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}
