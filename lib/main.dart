import 'package:currency/theme/dark.dart';
import 'package:currency/theme/light.dart';
import 'package:currency/theme/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency/pages/currency_rate_page.dart';

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
      themeMode: ref.watch(themeProvider),
      home: const CurrencyRatePage(),
    );
  }
}
