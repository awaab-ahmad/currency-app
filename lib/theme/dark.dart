import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final darkTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xFF0F172A),
  appBarTheme: AppBarTheme(
     systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: const Color(0x00000000),
      systemNavigationBarIconBrightness: .light,
      statusBarIconBrightness: .light,
      systemNavigationBarColor: const Color(0xFF0F172A),      
    ),
    scrolledUnderElevation: 0,
    elevation: 0,
    backgroundColor: const Color(0xFF0F172A),
    centerTitle: true,
    shape: RoundedRectangleBorder(borderRadius: .vertical(bottom: .circular(20))),   
  ),
  colorScheme: .fromSeed(
    seedColor: const Color(0x00000000),
    surface: const Color(0xFFE5E7EB),
    primary: const Color(0xFF1E293B),
    onPrimary: const Color(0xB32DD4BF),
    primaryContainer: const Color(0xFF0F172A),
    secondary: const Color(0xFF344156),
    onSecondary: const Color(0xFF7C9BFF),
    outline: const Color(0xFF7C9BFF),
    outlineVariant: const Color(0xFF7C9BFF) 
    )
);