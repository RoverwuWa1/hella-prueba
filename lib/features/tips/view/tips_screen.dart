import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ============================================================
      //  BLOQUE 1 — AppBar
      // Cambien el título, color, íconos, lo que necesiten.
      // ============================================================
      appBar: AppBar(
        title: const Text('Tips'),     //  Cambien el título
      ),

      body: Padding(

        //  DISEÑO: Espaciado general
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ============================================================
            //  BLOQUE 2 — Título de la sección
            // Cambien el texto y estilo según la app.
            // ============================================================
            const Text(
              'Sección informativa',  //  Cambien el título
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 8),

            // ============================================================
            //  BLOQUE 3 — Subtítulo o descripción
            // Texto de apoyo que explica de qué trata la sección.
            // ============================================================
            const Text(
              'Aquí va una descripción breve de esta sección.', //  Cambien el texto
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54, //  Color del subtítulo
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            //  BLOQUE 4 — Lista de contenido informativo
            // Aquí van los tips, artículos, tarjetas o lo que sea
            // el contenido de esta sección.
            // Cambien el ícono, textos, colores y forma de cada item.
            // Los datos reales vendrán de Firestore — por ahora son placeholders.
            // ============================================================
            const Text(
              'Contenido',            //  Cambien este título
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: 3,         //  Cambien la cantidad
                itemBuilder: (context, index) {
                  return const ListTile(
                    leading: Icon(Icons.info_outline), //  Cambien el ícono
                    title: Text('Tip'),                //  Cambien el texto
                    subtitle: Text('Descripción'),     //  Cambien la descripción
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}