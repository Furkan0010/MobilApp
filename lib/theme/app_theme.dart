import 'package:flutter/material.dart';

/// Uygulamanın renkleri ve genel teması.
class AppTheme {
  AppTheme._();

  // Sık kullanılan renkler
  static const Color primary = Colors.black;
  static const Color priceBlue = Color(0xFF0A66D8);
  static const Color mutedText = Color(0xFF8E8E93);
  static const Color lightGrey = Color(0xFFF2F2F4);
  static const Color border = Color(0xFFE8E8EA);

  // Köşe yuvarlaklıkları
  static const double radius = 12;
  static const double cardRadius = 16;

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(seedColor: primary).copyWith(
      primary: primary,
      onPrimary: Colors.white,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.white,

      // Üst bar: beyaz, gölgesiz
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      // Siyah, tam genişlik ana butonlar (Add to cart, Checkout)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // "‹ Back" gibi yazı butonları
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      // Açık gri, kenarlıksız arama kutusu
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGrey,
        hintStyle: const TextStyle(color: mutedText),
        prefixIconColor: mutedText,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide.none,
        ),
      ),

      // Ürün kartları
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(color: border),
        ),
      ),

      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
