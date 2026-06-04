import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/banner_widget.dart';
import '../widgets/progres_tracker_widget.dart';
import '../../../data/services/challenges_services.dart';
import '../../../data/modules/challenge_module.dart';
import '../widgets/cuadro_retos.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChallengesService _service = ChallengesService();

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
        //Forzamos a que el contenido NO se centre automáticamente
        centerTitle: false,
        title: Row(
          //Alinea verticalmente el texto y la imagen al centro
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo2.png', width: 33),
            //El SizedBox va en medio de los dos para separarlos un poco
            const SizedBox(width: 10),
            Text(
              _getGreeting(), //saludo dinámico (NO TOCAR)
            ),
          ],
        ),
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
              child: FutureBuilder(
                future: _service.getChallengesConProgreso(user!.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final retos = snapshot.data as List<ChallengeModel>;

                  // 🔥 SOLO los que NO están completados
                  final pendientes = retos.where((r) => !r.completado).toList();

                  // 🎉 Si ya terminó todos
                  if (pendientes.isEmpty) {
                    return const Center(
                      child: Text("🎉 Ya completaste todos los retos"),
                    );
                  }

                  //  RETO ACTUAL (el primero pendiente)
                  final retoActual = pendientes.first;

                  return TarjetaReto(
                    reto: retoActual,
                    onCompletar: retoActual.activo
                        ? () async {
                            await _service.completarReto(
                              user.uid,
                              retoActual.id,
                            );
                          }
                        : null,
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
