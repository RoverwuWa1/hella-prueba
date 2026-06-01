import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/banner_widget.dart';
import '../widgets/progres_tracker_widget.dart';

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
      // ============================================================
      //  BLOQUE 1 — AppBar
      // Pueden cambiar el título, color, agregar íconos, etc.
      // ============================================================
      appBar: AppBar(
        title: Text(_getGreeting()), //  NO TOCAR — saludo dinámico
      ),

      body: Padding(
        //  DISEÑO: Espaciado de la pantalla
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================================
            //  BLOQUE 2 — Sección principal
            // Aquí va el contenido de bienvenida de la app.
            // ============================================================
            const SizedBox(height: 12),

            //  Aquí va el banner_widget (el cuadro de color verde grande)
            BannerWidget(firstName: firstName),

            const SizedBox(height: 24),

            //Barra de seguimiento
            const ProgressTracker(),
            const SizedBox(height: 24), // Un espacio después de la barra
            // ============================================================
            //  BLOQUE 3 — Lista de contenido
            // Aquí va una lista, grid o lo que sea el core de la app.
            // Cambien el ícono, textos y colores de cada item.
            // ============================================================
            const Text(
              'Reto de hoy', //  Cambien este título
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: 3, //  Cambien la cantidad
                itemBuilder: (context, index) {
                  return const ListTile(
                    leading: Icon(Icons.circle_outlined), //  Cambien el ícono
                    title: Text('Item'), //  Cambien el texto
                    subtitle: Text('Descripción'), //  Cambien la descripción
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
