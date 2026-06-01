import 'package:flutter/material.dart';
import '../../../core/teams/app_themes.dart';

class ProgressTracker extends StatefulWidget {
  const ProgressTracker({super.key});

  @override
  State<ProgressTracker> createState() => _ProgressTrackerState();
}

class _ProgressTrackerState extends State<ProgressTracker> {
  // =================================================================
  //  ESTADO DEL WIDGET
  //  Aquí guardamos el valor actual y el total.
  //  Por ahora, el valor actual es fijo, pero está listo para cambiar.
  // =================================================================
  final int _contadorActual =
      7; // <- CAMBIA ESTE NÚMERO PARA PROBAR (de 0 a 21)
  final int _contadorTotal = 21;

  @override
  Widget build(BuildContext context) {
    // Calculamos el progreso como un valor entre 0.0 y 1.0
    final double progreso = _contadorActual / _contadorTotal;

    // =================================================================
    //  DISEÑO DEL WIDGET
    //  Usamos un Container con sombra y bordes redondeados para
    //  hacerlo más llamativo.
    // =================================================================
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface, // Color de fondo (blanco)
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===========================================================
          //  FILA 1: Título y contador (Ej: "Tu Progreso" y "7 / 21")
          // ===========================================================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tu Progreso', // Título de la barra
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '$_contadorActual / $_contadorTotal', // Contador
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: AppColors.primary, // Color verde para destacar
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ===========================================================
          //  FILA 2: La barra de progreso visual
          //  Usamos un Stack para poner una barra sobre otra.
          // ===========================================================
          Stack(
            children: [
              // La base de la barra (el fondo grisáceo)
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // La barra de progreso que avanza
              LayoutBuilder(
                builder: (context, constraints) => Container(
                  height: 10,
                  width:
                      constraints.maxWidth *
                      progreso, // Ancho proporcional al progreso
                  decoration: BoxDecoration(
                    color: AppColors.primary, // Color de la barra (verde)
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
