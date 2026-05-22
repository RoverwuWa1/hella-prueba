import 'package:flutter/material.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      //  DISEÑO: Color de fondo
      backgroundColor: Colors.white,

      // ============================================================
      //  BLOQUE 1 — AppBar
      // Cambien el título, color, íconos, lo que necesiten.
      // ============================================================
      appBar: AppBar(
        title: const Text('Retos'),    //  Cambien el título
        backgroundColor: Colors.white, //  Color del AppBar
        foregroundColor: Colors.black, //  Color del texto e íconos
        elevation: 0,
      ),

      body: Padding(

        //  DISEÑO: Espaciado general
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ============================================================
            //  BLOQUE 2 — Retos por cumplir
            // Lista de retos que el usuario aún no ha completado.
            // Cambien el ícono, textos, colores y forma de cada item.
            // Los datos reales vendrán de Firestore — por ahora son placeholders.
            // ============================================================
            const Text(
              'Por cumplir',          //  Cambien el título
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,           //  Cambien la cantidad de placeholders
              itemBuilder: (context, index) {
                return const ListTile(
                  leading: Icon(Icons.radio_button_unchecked), //  Ícono de pendiente
                  title: Text('Reto por cumplir'),             //  Nombre del reto
                  subtitle: Text('Descripción del reto'),      //  Descripción
                );
              },
            ),

            const SizedBox(height: 24),

            // ============================================================
            //  BLOQUE 3 — Retos cumplidos
            // Lista de retos que el usuario ya completó.
            // Cambien el ícono, textos, colores y forma de cada item.
            // ============================================================
            const Text(
              'Cumplidos',            //  Cambien el título
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,           //  Cambien la cantidad de placeholders
              itemBuilder: (context, index) {
                return const ListTile(
                  leading: Icon(Icons.check_circle_outline), //  Ícono de cumplido
                  title: Text('Reto cumplido'),              //  Nombre del reto
                  subtitle: Text('Descripción del reto'),    //  Descripción
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}