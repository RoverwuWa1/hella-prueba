import 'package:flutter/material.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ============================================================
      //  BLOQUE 1 — AppBar
      // Cambien el título, color, íconos, lo que necesiten.
      // ============================================================
      appBar: AppBar(
        //Forzamos a que el contenido NO se centre automáticamente
        centerTitle: false,
        title: Row(
          //Alinea verticalmente el texto y la imagen al centro
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo2.png', width: 33),
            //El SizedBox va en medio de los dos para separarlos un poco
            const SizedBox(width: 10),
            const Text('HELLA'), //  Cambien el título
          ],
        ),
      ),

      body: SingleChildScrollView(
        // NO TOCAR – evita el overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================================
            // BLOQUE 1 - CONTENEDOR VERDE (Sin márgenes, toca los bordes)
            // ========================================================
            Container(
              width: double.infinity,
              color: const Color(
                0xFF1B8544,
              ), // Corregido el tono verde del diseño
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Retos Diarios',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Día 4 de 21 · 3 completados',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // ========================================================
            // BLOQUE 2 - CONTENIDO CON MARGEN (Todo lo demás va aquí dentro)
            // ========================================================
            Padding(
              padding: const EdgeInsets.all(
                16.0,
              ), // El diseño "Espaciado general" ahora solo afecta a esto
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECCIÓN: POR CUMPLIR ---
                  const Text(
                    'Por cumplir',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return const ListTile(
                        leading: Icon(Icons.radio_button_unchecked),
                        title: Text('Reto por cumplir'),
                        subtitle: Text('Descripción del reto'),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // --- SECCIÓN: CUMPLIDOS ---
                  const Text(
                    'Cumplidos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return const ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Reto cumplido'),
                        subtitle: Text('Descripción del reto'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
