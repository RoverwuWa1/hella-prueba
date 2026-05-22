import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Colores principales — cambien estos
  static const Color primary = Colors.black;
  static const Color background = Colors.white;

  static ThemeData get theme => ThemeData(
    colorSchemeSeed: primary,
    scaffoldBackgroundColor: background,

    // Estilo global del AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: Colors.black,
      elevation: 0,
    ),

    // Estilo global del NavigationBar
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: Colors.black12,
    ),
  );
}