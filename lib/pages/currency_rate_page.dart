import 'package:currency/childs/currency_page_childs.dart';
import 'package:currency/pages/exchange_rate_page.dart';
import 'package:currency/stateManagement/filtered_state.dart';
import 'package:currency/stateManagement/online_state.dart';
import 'package:currency/stateManagement/popular_state.dart';
import 'package:currency/stateManagement/shared_preferences.dart';
import 'package:currency/theme/theme_logic.dart';
import 'package:currency/widgets/bottom_sheets.dart';
import 'package:currency/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyRatePage extends ConsumerStatefulWidget {
  const CurrencyRatePage({super.key});

  @override
  ConsumerState<CurrencyRatePage> createState() => _CurrencyRatePage();
}

class _CurrencyRatePage extends ConsumerState<CurrencyRatePage> {
  static GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  TextEditingController srcController = TextEditingController();
  TextEditingController amtController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storageNotifier.notifier).helperOfAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final loading = ref.watch(onlineProvider.select((v) => v.isLoading));
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: loading
              ? Center(
                  child: SizedBox(
                    height: 25,
                    width: 25,
                    child: GlobalIndicator(c: c.surface),
                  ),
                )
              : SizedBox.shrink(),
          title: Text('Currency Exchange', style: t.titleLarge),
          toolbarHeight: sz.height * 0.06,
          actions: [
            IconButton(
              onPressed: () {
                changingThemeMode(ref);
              },
              padding: const EdgeInsets.all(0),
              icon: Image.asset(
                ref.watch(themeProviderIcon),
                color: c.surface,
                height: sz.height * 0.04,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          key: refreshKey,
          color: c.surface,
          backgroundColor: c.secondary,
          onRefresh: () {
            return ref.read(onlineProvider.notifier).helperWorker(() {
              ref.read(popuState.notifier).assigningValues();
            });
          },
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: .center,
                children: [
                  const SizedBox(height: 10),
                  const DateWidget(),
                  const SizedBox(height: 08),
                  CurrencyBox(tc: srcController, amount: amtController),
                  const SizedBox(height: 08),
                  ElevatedButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      ref
                          .read(filterNotifier.notifier)
                          .filteredListFilling(srcController);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        bottomSheet(
                          context: context,
                          child: AddCurrencySheet(
                            tc: srcController,
                            amount: amtController,
                          ),
                        );
                      });
                    },
                    style: outerButtonsStyle(
                      sz.width,
                      sz.height,
                      c.onSecondary,
                      c.outline,
                    ),
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Text('Add Currency', style: t.bodyLarge),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.add,
                          color: c.surface,
                          size: sz.height * 0.04,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 08),
                  const ResultBox(),
                  const SizedBox(height: 08),
                  const AddedCurrenciesBox(),
                  const SizedBox(height: 08),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ExchangeRatePage(),
                        ),
                      );
                      ref
                          .read(filterNotifier.notifier)
                          .filteredListFilling(srcController);
                    },
                    style: outerButtonsStyle(
                      sz.width,
                      sz.height,
                      c.onSecondary,
                      c.outline,
                    ),
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        Image.asset(
                          'images/currency.png',
                          height: sz.height * 0.04,
                          color: c.surface,
                        ),
                        const SizedBox(width: 10),
                        Text('View Exchange Rate', style: t.bodyLarge),
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

  static ButtonStyle outerButtonsStyle(
    double w,
    double h,
    Color c,
    Color borderC,
  ) {
    return ElevatedButton.styleFrom(
      elevation: 3,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
      fixedSize: Size(w * 1.0, h * 0.07),
      side: BorderSide(color: borderC, width: 1.5),
      backgroundColor: c,
    );
  }
}
