import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture_practise/core/app_pallet.dart';

class AppTheme {
  static OutlineInputBorder _border([Color color = Colors.transparent]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: color, width: 0),
      );

  static final darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.darkGreen,
    appBarTheme: AppBarTheme(
      backgroundColor: AppPallete.darkGreen,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPallete.lightGreen,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      hintStyle: TextStyle(color: AppPallete.hint),
      enabledBorder: _border(),
      focusedBorder: _border(Colors.transparent),
      errorStyle: TextStyle(color: AppPallete.error),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ).copyWith(
        // Градиентная заливка
        backgroundColor: MaterialStateProperty.resolveWith((states) => null),
        shadowColor: MaterialStateProperty.all(Colors.transparent),
      ),
    ),
  );
}
