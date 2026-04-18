import 'package:currency/childs/currency_page_childs.dart';
import 'package:currency/childs/exchanage_page_childs.dart';
import 'package:currency/stateManagement/currency_state.dart';
import 'package:currency/stateManagement/filtered_state.dart';
import 'package:currency/stateManagement/online_state.dart';
import 'package:currency/widgets/bottom_sheets.dart';
import 'package:currency/widgets/button_styles.dart';
import 'package:currency/widgets/all_containers.dart';
import 'package:currency/widgets/text_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:world_countries/world_countries.dart';

class ExchangeRatePage extends ConsumerWidget {
  ExchangeRatePage({super.key});
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final c = Theme.of(context).colorScheme;
    final filterPro = ref.watch(filterNotifier);
    final currPro = ref.watch(currencyState);
    final onlinePro = ref.watch(onlineProvider);
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
              currencyNameWidget(h, w, context, ref, searchController),
              const SizedBox(height: 08),
              popularRatesWidget(h, w, context, ref),
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
                    itemCount: filterPro.filteredList.length,
                    itemBuilder: (context, index) {
                      final country = filterPro.filteredList[index];
                      final countryCode = country.currencies!.first.code;
                      final countryName = country.name;
                      dynamic api = onlinePro.dataFromWeb['conversion_rates'][countryCode]; 
                      dynamic result;                    
                      if(api != null) {
                        result = (1 / api);
                      } else {
                        result = 0;
                      }                                                                                           
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
                              '1 $countryCode = ${result.toStringAsFixed(3)} ${currPro.fromCurrNm}',
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
