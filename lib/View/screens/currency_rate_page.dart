import 'package:currency/Controller/providers.dart';
import 'package:currency/View/screens/exchange_rate_page.dart';
import 'package:currency/View/widgets/bottom_sheets.dart';
import 'package:currency/View/widgets/date_widget.dart';
import 'package:currency/View/widgets/indicator.dart';
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

  static ButtonStyle outerButtonsStyle(double h, Color c, borderC) {
    return ElevatedButton.styleFrom(
      elevation: 3,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
      fixedSize: Size(double.maxFinite, h * 0.07),
      side: BorderSide(color: borderC, width: 1.5),
      backgroundColor: c,
    );
  }
}

class CurrencyBox extends ConsumerWidget {
  final TextEditingController tc;
  final TextEditingController amount;
  const CurrencyBox({super.key, required this.tc, required this.amount});

  static ButtonStyle currencyStyle(double w, double h, Color c) {
    return ElevatedButton.styleFrom(
      elevation: 3,
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
      fixedSize: Size(w * 0.37, h * 0.065),
      backgroundColor: c,
    );
  }

  static BoxShadow containerDesign(Color c) {
    return BoxShadow(
      color: c,
      blurRadius: 4,
      spreadRadius: 1,
      offset: Offset(0, 2),
      blurStyle: .normal,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sz = MediaQuery.sizeOf(context);
    final c = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final frmFlg = ref.watch(currencyState.select((v) => v.fromCurrFlg));
    final fromNm = ref.watch(currencyState.select((v) => v.fromCurrNm));
    final toFlg = ref.watch(currencyState.select((v) => v.toCurrFlg));
    final toNm = ref.watch(currencyState.select((v) => v.toCurrNm));
    final rate = ref.watch(currencyState.select((v) => v.oneCurrencyRate));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 08, vertical: 05),
      width: sz.width * 1.0,
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
            controller: amount,
            onChanged: (value) {
              ref.read(onlineProvider.notifier).gettingAmountCalculated(amount);
              ref
                  .read(onlineProvider.notifier)
                  .addedCurrenciesCalculation(amount);
            },
            style: t.bodyMedium,
            decoration: InputDecoration(
              labelText: 'Enter Amount',
              labelStyle: t.bodyLarge,
              hintText: 'e.g. 100',
              hintStyle: t.bodyMedium,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 0,
              ),
              visualDensity: const VisualDensity(vertical: 4),
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
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
                  ref.read(filterNotifier.notifier).filteredListFilling(tc);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    bottomSheet(
                      context: context,
                      child: CurrencyPickFrom(tc: tc, amount: amount),
                    );
                  });
                },
                style: currencyStyle(sz.width, sz.height, c.secondary),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text(frmFlg, style: t.displayLarge),
                    const SizedBox(width: 5),
                    Text(fromNm, style: t.titleLarge),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.arrow_drop_down,
                      color: c.surface,
                      size: sz.width * 0.1,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
                  ref.read(filterNotifier.notifier).filteredListFilling(tc);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    bottomSheet(
                      context: context,
                      child: CurrencyPickTo(tc: tc, amount: amount),
                    );
                  });
                },
                style: currencyStyle(sz.width, sz.height, c.secondary),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text(toFlg, style: t.displayLarge),
                    const SizedBox(width: 5),
                    Text(toNm, style: t.titleLarge),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.arrow_drop_down,
                      color: c.surface,
                      size: sz.width * 0.1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                '1 $fromNm = ${rate.toStringAsFixed(5)} $toNm',
                style: t.bodyLarge,
              ),
              IconButton(
                onPressed: () async {
                  ref.read(currencyState.notifier).helperSwappingReFetching(() {
                    ref.read(onlineProvider.notifier).helperWorker(() {
                      ref.read(popuState.notifier).assigningValues();
                    });
                  }, amount);
                },
                visualDensity: const VisualDensity(vertical: -4),
                padding: .zero,
                icon: Image.asset(
                  'images/alter.png',
                  height: sz.height * 0.033,
                  color: c.surface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultBox extends ConsumerWidget {
  const ResultBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final sz = MediaQuery.sizeOf(context);
    final t = Theme.of(context).textTheme;
    final currFlg = ref.watch(currencyState.select((v) => v.toCurrFlg));
    final currNm = ref.watch(currencyState.select((v) => v.toCurrNm));
    final result = ref.watch(currencyState.select((v) => v.convertedValue));
    return Container(
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(color: c.primary, borderRadius: .circular(20)),
      width: sz.width * 1.0,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: .circular(20)),
        margin: const EdgeInsets.all(10),
        color: c.secondary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Text(currFlg, style: t.displayLarge),
                  const SizedBox(width: 10),
                  Text(currNm, style: t.displayLarge),
                ],
              ),
              Text(result, style: t.displayLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class AddedCurrenciesBox extends ConsumerWidget {
  const AddedCurrenciesBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = Theme.of(context).colorScheme;
    final sz = MediaQuery.sizeOf(context);
    final t = Theme.of(context).textTheme;
    final lst = ref.watch(addedCurrenState.select((v) => v.addedCurrencies));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 08),
      height: sz.height * 0.3,
      width: sz.width * 1.0,
      decoration: BoxDecoration(color: c.primary, borderRadius: .circular(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .start,
            children: [
              Text('Added Currencies', style: t.bodyLarge),
              const Expanded(child: SizedBox()),
              Text('(${lst.length} / 5)', style: t.titleLarge),
              const Expanded(child: SizedBox()),
            ],
          ),
          Expanded(
            child: lst.isEmpty
                ? Center(
                    child: Text('No currencies added', style: t.bodyMedium),
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
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: ListView.builder(
                        key: ValueKey(lst.length),
                        itemCount: lst.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 03),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 1,
                            ),
                            width: sz.width * 1.0,
                            decoration: BoxDecoration(
                              color: c.secondary,
                              borderRadius: .circular(20),
                            ),
                            child: Row(
                              children: [
                                Text(lst[index]['flag'], style: t.displayLarge),
                                const SizedBox(width: 08),
                                Text(lst[index]['name'], style: t.bodyLarge),
                                const SizedBox(width: 08),
                                Expanded(
                                  child: SizedBox(
                                    height: 28,
                                    child: FittedBox(
                                      child: Text(
                                        '${lst[index]['result'].toStringAsFixed(2)}',
                                        style: t.bodyLarge,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 05),
                                IconButton(
                                  onPressed: () async {
                                    ref
                                        .read(addedCurrenState.notifier)
                                        .removingAddedCurrency(index);
                                    await ref
                                        .read(storageNotifier.notifier)
                                        .addedCurrenciesSaving();
                                  },
                                  visualDensity: VisualDensity(vertical: -2),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.delete,
                                    size: sz.height * 0.04,
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
}
