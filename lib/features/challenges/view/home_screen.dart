import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // ============================================================
    //  NO TOCAR — Datos del usuario desde Firebase
    // ============================================================
    final User? user = FirebaseAuth.instance.currentUser;
    final String firstName = user?.displayName?.split(' ').first ?? 'Usuario';
    // ============================================================

    return Scaffold(

      //  DISEÑO: Color de fondo
      backgroundColor: Colors.white,

      // ============================================================
      //  BLOQUE 1 — AppBar
      // Pueden cambiar el título, color, agregar íconos, etc.
      // ============================================================
      appBar: AppBar(
        title: Text(_getGreeting()),  //  NO TOCAR — saludo dinámico
      ),

      body: Padding(

        // 🎨 DISEÑO: Espaciado de la pantalla
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ============================================================
            //  BLOQUE 2 — Saludo con nombre del usuario
            // Solo cambien los estilos. El texto firstName viene
            // de Firebase — no lo modifiquen.
            // ============================================================
            Text(
              'Hola, $firstName',   //  NO TOCAR — nombre de Firebase
              style: const TextStyle(
                fontSize: 22,       //  Tamaño
                fontWeight: FontWeight.bold, //  Peso
                color: Colors.black,         //  Color
              ),
            ),

            const SizedBox(height: 24),

            // ============================================================
            //  BLOQUE 3 — Sección principal
            // Aquí va el contenido más importante de la app.
            // Pueden poner cards, imágenes, banners, lo que necesiten.
            // ============================================================
            const Text(
              'Sección principal',    //  Cambien este título
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            //  Aquí va el contenido principal — reemplacen este Placeholder
            const Placeholder(
              fallbackHeight: 160,
              color: Colors.black12,
            ),

            const SizedBox(height: 24),

            // ============================================================
            //  BLOQUE 4 — Lista de contenido
            // Aquí va una lista, grid o lo que sea el core de la app.
            // Cambien el ícono, textos y colores de cada item.
            // ============================================================
            const Text(
              'Lista de contenido',   //  Cambien este título
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: 3, //  Cambien la cantidad
                itemBuilder: (context, index) {
                  return const ListTile(
                    leading: Icon(Icons.circle_outlined), //  Cambien el ícono
                    title: Text('Item'),                  //  Cambien el texto
                    subtitle: Text('Descripción'),        //  Cambien la descripción
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ============================================================
  //  NO TOCAR — Lógica del saludo según hora del día
  // ============================================================
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }
  // ============================================================
}