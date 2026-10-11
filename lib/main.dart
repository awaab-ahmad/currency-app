import 'package:currency/View/screens/exchange_rate_page.dart';
import 'package:currency/View/theme/dark.dart';
import 'package:currency/View/theme/light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency/View/screens/currency_rate_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: const MainClass()));
}

class MainClass extends ConsumerWidget {
  const MainClass({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const CurrencyRatePage(),
    );
  }
}
