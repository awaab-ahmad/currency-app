import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final themeProviderIcon = StateProvider((ref) => 'images/brightness.png');
final themeProvider = StateProvider((ref) => ThemeMode.system);


// making the function for the working of the Theme

void changingThemeMode(WidgetRef ref) {
  ref
      .read(themeProvider.notifier)
      .update(
        (state) {
          if(state == ThemeMode.dark) {
            state = ThemeMode.light;
            ref.read(themeProviderIcon.notifier).update((state) => 'images/brightness.png');
          } else {
            state = ThemeMode.dark;
            ref.read(themeProviderIcon.notifier).update((state) => 'images/themes.png');
          }
          return state;
        }
      );  
  if(kDebugMode) print('Running the function');
}
