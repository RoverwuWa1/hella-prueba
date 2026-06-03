import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/teams/app_themes.dart';
import '../../../data/services/challenges_services.dart';

class ProgressTracker extends StatefulWidget {
  const ProgressTracker({super.key});

  @override
  State<ProgressTracker> createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  // ============================================================
  //  NO TOCAR — Servicio y estado
  // ============================================================
  final ChallengesService _service = ChallengesService();
  int _contadorActual = 0;
  final int _contadorTotal = 21;

  @override
  void initState() {
    super.initState();
    _cargarProgreso(); //  NO TOCAR
  }

  // ============================================================
  // NO TOCAR — Obtiene el progreso real desde Firestore
  // ============================================================
  Future<void> _cargarProgreso() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final completados = await _service.getProgreso(uid);
      if (mounted) setState(() => _contadorActual = completados);
    } catch (e) {
      // Si falla, la barra se queda en 0
    }
  }
  // ============================================================

  @override
  Widget build(BuildContext context) {
    //  NO TOCAR — Calcula el progreso entre 0.0 y 1.0
    final double progreso = _contadorActual / _contadorTotal;

    // =================================================================
    //  DISEÑO DEL WIDGET
    //  Usamos un Container con sombra y bordes redondeados.
    // =================================================================
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ), //  Espaciado
      decoration: BoxDecoration(
        color: AppColors.surface, //  Fondo
        borderRadius: BorderRadius.circular(16), //  Esquinas
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1), //  Color sombra
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===========================================================
          //  FILA 1 — Título y contador
          //   Cambien los textos y estilos
          // ===========================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tu Progreso', //  Cambien el título
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17, //  Tamaño
                  color: AppColors.textPrimary, //  Color
                ),
              ),
              Text(
                '$_contadorActual / $_contadorTotal', //  NO TOCAR
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17, //  Tamaño
                  color: AppColors.primary, //  Color
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ===========================================================
          //  FILA 2 — Barra de progreso
          //   Cambien colores y altura de la barra
          // ===========================================================
          Stack(
            children: [
              // Base de la barra — fondo
              Container(
                height: 10, //  Alto de la barra
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.15,
                  ), //  Color del fondo
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Barra de progreso — avanza según retos completados
              LayoutBuilder(
                builder: (context, constraints) => Container(
                  height: 10, //  Alto de la barra
                  width: constraints.maxWidth * progreso, //  NO TOCAR
                  decoration: BoxDecoration(
                    color: AppColors.primary, //  Color del progreso
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

