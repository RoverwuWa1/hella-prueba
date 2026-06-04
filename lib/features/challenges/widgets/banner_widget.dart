import 'package:flutter/material.dart';

// ============================================================
//  WIDGET: BannerWidget
// Banner principal de la HomeScreen con degradados y profundidad.
//
// Uso en home_screen.dart:
// BannerWidget(firstName: firstName),
// ============================================================
class BannerWidget extends StatelessWidget {
  final String firstName;

  const BannerWidget({
    super.key,
    required this.firstName, //  NO TOCAR — viene de Firebase
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180, //  Alto del banner

      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // ============================================================
            //  NO TOCAR — Capas de profundidad (brillo y sombra interna)
            // ============================================================

            // Brillo superior — efecto de luz viniendo de arriba
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 182,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF19BE59),
                      Color(0xFF166D37), // desvanece
                    ],
                  ),
                ),
              ),
            ),
            // ============================================================

            // ============================================================
            //  BLOQUE 1 — Contenido del banner
            // Cambien los textos y estilos según su app.
            // El firstName NO se toca — viene de Firebase.
            // ============================================================
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Hola, $firstName 👋', //  NO TOCAR
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13, //  Tamaño
                        color: Color(0xD1FFFFFF), //  Color
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Hábitos que cuidan\nel planeta', //  Cambien el texto
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21, // Tamaño
                        fontWeight: FontWeight.w800, //  Peso
                        color: Colors.white, //  Color
                        height: 1.25,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Completa pequeños retos diarios y construye un estilo de vida más sostenible.', //  Cambien el texto
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12, //  Tamaño
                        color: Color(0xBFFFFFFF), //  Color
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ============================================================
          ],
        ),
      ),
    );
  }
}
