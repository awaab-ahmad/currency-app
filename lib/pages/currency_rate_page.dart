import 'package:currency/childs/currency_page_childs.dart';
import 'package:currency/pages/exchange_rate_page.dart';
import 'package:currency/stateManagement/river_pod_state.dart';
import 'package:currency/theme/theme_logic.dart';
import 'package:currency/widgets/bottom_sheets.dart';
import 'package:currency/widgets/button_styles.dart';
import 'package:currency/widgets/indicator.dart';
import 'package:currency/widgets/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyRatePage extends ConsumerStatefulWidget {
  const CurrencyRatePage({super.key});

  @override
  ConsumerState<CurrencyRatePage> createState() => _CurrencyRatePage();
}

class _CurrencyRatePage extends ConsumerState<CurrencyRatePage> {
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      changingThemeMode(ref);
      ref.read(stateManagementClass).currencyRateFetching();
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final c = Theme.of(context).colorScheme;
    final provider = ref.watch(stateManagementClass);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: ref.watch(stateManagementClass).isLoading == true
              ? Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: indicator(c.surface),
                  ),
                )
              : SizedBox.shrink(),
          title: gText('Currency Exchange', c.surface, 16, FontWeight.w600),
          toolbarHeight: h * 0.06,
          actions: [
            IconButton(
              onPressed: () {
                changingThemeMode(ref);
              },
              padding: const EdgeInsets.all(0),
              icon: Image.asset(
                ref.watch(themeProviderIcon),
                color: c.surface,
                height: h * 0.04,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          key: refreshKey,
          color: c.surface,
          backgroundColor: c.secondary,
          onRefresh: () {
            return ref.read(stateManagementClass).currencyRateFetching();
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  const SizedBox(height: 10),
                  updatedDateWidget(h, w, context, ref),
                  const SizedBox(height: 08),
                  currencyFromToWidget(h, w, context, ref, provider),
                  const SizedBox(height: 08),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(stateManagementClass).filteredListFilling();
                      bottomSheet(
                        context: context,
                        child: addCurrencySheet(
                          h,
                          w,
                          context,
                          ref,
                          provider.searchController,
                        ),
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      });
                    },
                    style: outerButtonsStyle(w, h, c.onSecondary, c.outline),
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        gText('Add Currency', c.surface, 14, FontWeight.w600),
                        const SizedBox(width: 10),
                        Icon(Icons.add, color: c.surface, size: h * 0.04),
                      ],
                    ),
                  ),
                  const SizedBox(height: 08),
                  resultWidget(h, w, context, provider),
                  const SizedBox(height: 08),
                  addedCurrenciesWidget(h, w, context, ref, provider),
                  const SizedBox(height: 08),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExchangeRatePage(),
                        ),
                      );
                      ref.read(stateManagementClass).filteredListFilling();
                      ref
                          .read(stateManagementClass)
                          .popularCurrenciesLocation();
                    },
                    style: outerButtonsStyle(w, h, c.onSecondary, c.outline),
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Image.asset(
                          'images/currency.png',
                          height: h * 0.04,
                          color: c.surface,
                        ),
                        const SizedBox(width: 10),
                        gText(
                          'View Exchange Rate',
                          c.surface,
                          14,
                          FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
