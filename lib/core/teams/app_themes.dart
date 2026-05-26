import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// =================================================================
//  COLORES DE LA APP
// =================================================================
//  Aquí van TODOS los colores que usen en la app.
//  La ventaja es que si quieren cambiar un color, solo lo cambian
//  aquí y se actualiza en toda la app automáticamente.
//
//  Ejemplo de uso en cualquier pantalla:
//  color: AppColors.primary
//  color: AppColors.background
// =================================================================
class AppColors {
  static const Color primary        = Color(0xFF00B477); //  Color principal
  static const Color primaryLight   = Color(0xFF00C381); //  Variante clara del principal
  static const Color background     = Color.fromARGB(255, 226, 237, 214); //  Fondo de pantallas
  static const Color surface        = Color(0xFFFFFFFF); //  Fondo de cards
  static const Color textPrimary    = Color(0xFF000000); //  Texto principal
  static const Color textSecondary  = Color(0xFF000000); //  Texto secundario
  static const Color error          = Color(0xFFE53935); //  NO TOCAR — errores
}

// =================================================================
//  TEMA GLOBAL DE LA APP
// =================================================================
//  Aquí se define cómo se ven los widgets en toda la app.
//  Una vez configurado, el AppBar, botones, cards y más
//  toman estos estilos automáticamente sin que tengan que
//  escribir colores o fuentes en cada pantalla.
//
//  Uso en main.dart:
//  theme: AppTheme.theme,
// =================================================================
class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary, //  NO TOCAR — solo cambien AppColors.primary
    ),

    scaffoldBackgroundColor: AppColors.background,

    // =============================================================
    //  TIPOGRAFÍA
    // =============================================================
    //  Lato → títulos y subtítulos
    //  Nunito → texto, descripciones, labels
    //
    //  Ejemplo de uso:
    //  style: Theme.of(context).textTheme.headlineMedium
    //  style: Theme.of(context).textTheme.bodyMedium
    // =============================================================
    textTheme: TextTheme(
      headlineLarge:  GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.bold,  color: AppColors.textPrimary),
      headlineMedium: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold,  color: AppColors.textPrimary),
      headlineSmall:  GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w600,  color: AppColors.textPrimary),
      bodyLarge:      GoogleFonts.nunito(fontSize: 16, color: AppColors.textPrimary),
      bodyMedium:     GoogleFonts.nunito(fontSize: 14, color: AppColors.textPrimary),
      bodySmall:      GoogleFonts.nunito(fontSize: 12, color: AppColors.textSecondary),
      labelLarge:     GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
    ),

    // =============================================================
    //  APPBAR
    // =============================================================
    //  Se aplica automáticamente a todos los AppBar de la app.
    //  Solo definan el title: en cada pantalla.
    // =============================================================
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background, //  Fondo del AppBar
      foregroundColor: AppColors.textPrimary, //  Color del texto e íconos
      elevation: 0,
      titleTextStyle: GoogleFonts.lato(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    ),

    // =============================================================
    //  BARRA DE NAVEGACIÓN INFERIOR
    // =============================================================
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,    //  Fondo de la barra
      indicatorColor: AppColors.primaryLight, //  Fondo del tab activo
    ),

    // =============================================================
    //  BOTÓN PRINCIPAL (ElevatedButton)
    // =============================================================
    //  Ejemplo de uso:
    //  ElevatedButton(onPressed: () {}, child: Text('Aceptar'))
    // =============================================================
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,  //  Color de fondo
        foregroundColor: Colors.white,        //  Color del texto
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), //  Esquinas
        ),
      ),
    ),

  );
}