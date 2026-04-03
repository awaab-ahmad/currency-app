import 'package:currency/childs/currency_page_childs.dart';
import 'package:currency/childs/exchanage_page_childs.dart';
import 'package:currency/stateManagement/river_pod_state.dart';
import 'package:currency/widgets/bottom_sheets.dart';
import 'package:currency/widgets/button_styles.dart';
import 'package:currency/widgets/all_containers.dart';
import 'package:currency/widgets/text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:world_countries/world_countries.dart';

final checkPackage = WorldCountry.list.where((c) => c.independent).toList();

class ExchangeRatePage extends ConsumerWidget {
  const ExchangeRatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final c = Theme.of(context).colorScheme;
    final p = ref.watch(stateManagementClass);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back, color: c.surface, size: h * 0.04),
          ),
          title: gText('Exchange Rate', c.surface, 16, FontWeight.w600),
          toolbarHeight: h * 0.06,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: .center,
            children: [
              const SizedBox(height: 10),
             updatedDateWidget(h, w, context, ref),
              const SizedBox(height: 08),
              currencyNameWidget(h, w, context, ref, p),
              const SizedBox(height: 08),
              popularRatesWidget(h, w, context, ref, p),
              const SizedBox(height: 08),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  currenciesContainer(h, c.surface, c.secondary),
                  ElevatedButton(
                    style: filterButtonStyle(w, h, c.secondary),
                    onPressed: () {
                      showModalBottomSheet(
                        backgroundColor: const Color(0x00000000),
                        isDismissible: true,
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: filterSheet(h, w, context, ref),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: .center,
                      children: [
                        gText('Filter By', c.surface, 13, FontWeight.w600),
                        Icon(
                          Icons.arrow_drop_down,
                          color: c.surface,
                          size: h * 0.04,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 05),
              Expanded(
                child: Card(
                  margin: const EdgeInsets.all(0),
                  clipBehavior: .antiAlias,
                  color: const Color(0x00000000),
                  elevation: 0,
                  child: ListView.builder(
                    itemCount: p.filteredList.length,
                    itemBuilder: (context, index) {
                      final country = p.filteredList[index];
                      final countryCode = country.currencies!.first.code;
                      final countryName = country.name;
                      final api = p.dataFromWeb;
                      final amount = api['conversion_rates'][countryCode];
                      if(kDebugMode) print(amount);
                      return Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            leading: gText(
                              country.emoji,
                              c.surface,
                              h * 0.035,
                              FontWeight.w600,
                            ),
                            title: gText(
                              '1 ${p.firstCurrency} = $amount $countryCode',
                              c.surface,
                              12,
                              FontWeight.w600,
                            ),
                            subtitle: gText(
                              countryName.toString(),
                              c.surface,
                              12,
                              FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                            width: w * 1.0,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
