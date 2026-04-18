import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeProviderIcon = StateProvider((ref) => 'images/brightness.png');
final themeProvider = StateProvider((ref) => ThemeMode.system);


// making the function for the working of the Theme

void changingThemeMode(WidgetRef ref) {
  final currentTheme = ref.read(themeProvider);
  if(currentTheme == ThemeMode.dark) {
    ref.read(themeProvider.notifier).state = ThemeMode.light;
    ref.read(themeProviderIcon.notifier).state = 'images/brightness.png';
  } else {
    ref.read(themeProvider.notifier).state = ThemeMode.dark;
    ref.read(themeProviderIcon.notifier).state = 'images/themes.png';
  }  
  if(kDebugMode) print('Running the function');
}
