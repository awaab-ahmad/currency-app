import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: const Color(0x00000000),
      systemNavigationBarIconBrightness: .dark,
      statusBarIconBrightness: .dark,
      systemNavigationBarColor: const Color(0xFFF7F9FC),      
    ),
    scrolledUnderElevation: 0,
    elevation: 0,
    backgroundColor: const Color(0xFFF7F9FC),
    centerTitle: true,
    shape: RoundedRectangleBorder(borderRadius: .vertical(bottom: .circular(20))),   
  ),
  scaffoldBackgroundColor: const Color(0xFFF7F9FC),
  colorScheme: .fromSeed(
    seedColor: const Color(0x00000000),
    surface: const Color(0xFF1F2937),
    primary: const Color(0xFF00A8A8),
    primaryContainer: const Color(0xFFF7F9FC),
    onPrimary: const Color(0xB3919191),
    secondary: const Color(0xFFF9FAFB),
    onSecondary: const Color(0xFFE8EEFF),
    outline: const Color(0xFF000000),
    outlineVariant: const Color(0xFFA6A6A6)    
    ),
);