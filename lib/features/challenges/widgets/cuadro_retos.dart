import 'package:flutter/material.dart';
import '../../../data/modules/challenge_module.dart';
import 'boton_retos.dart';

// ============================================================
//  WIDGET: TarjetaReto
// Tarjeta que muestra un reto con su estado y botón de cumplir.
//
// Uso en ChallengesScreen:
// TarjetaReto(
//   reto: reto,
//   onCompletar: () async => await _service.completarReto(uid, reto.id),
// )
// ============================================================
class TarjetaReto extends StatelessWidget {
  final ChallengeModel reto; //  NO TOCAR — datos del reto
  final VoidCallback? onCompletar; //  NO TOCAR — acción al completar

  const TarjetaReto({
    super.key,
    required this.reto, //  NO TOCAR
    this.onCompletar, //  NO TOCAR
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0), //  Espaciado interno
      decoration: BoxDecoration(
        color: Colors.white, //  Color de fondo
        borderRadius: BorderRadius.circular(16), //  Esquinas
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
        border: Border.all(
          color: const Color.fromARGB(255, 175, 241, 200), //  Color del borde
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          //  BLOQUE 1 — Ícono del reto
          // Cambien el color, tamaño y ícono.
          // ============================================================
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  reto
                      .completado //  NO TOCAR
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12), //  Esquinas del ícono
            ),
            child: Icon(
              reto
                      .completado //  NO TOCAR
                  ? Icons.check_rounded
                  : Icons.eco_outlined,
              color:
                  reto
                      .completado //  NO TOCAR
                  ? const Color(0xFF00B477)
                  : Colors.grey,
              size: 24, //  Tamaño del ícono
            ),
          ),

          const SizedBox(width: 12),

          // ============================================================
          //  BLOQUE 2 — Texto del reto
          // Cambien los estilos de texto.
          // El titulo y descripcion vienen del reto — no tocar.
          // ============================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Día ${reto.dia}', //  NO TOCAR
                  style: const TextStyle(
                    fontSize: 11, //  Tamaño
                    color: Color(0xFF00B477), //  Color
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  reto.titulo, //  NO TOCAR
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 4),

                Text(
                  reto.descripcion, //  NO TOCAR
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: 12),

                // ============================================================
                //  BLOQUE 3 — Botón / estado completado (NO TOCAR lógica)
                // Si el reto no está completado muestra el BotonReto.
                // Si ya está completado muestra un texto de confirmación.
                // ============================================================
                if (!reto.completado)
                  BotonReto(onPressed: onCompletar), //  NO TOCAR

                if (reto.completado)
                  const Text(
                    '✅ Reto completado', //  Cambien el texto
                    style: TextStyle(
                      color: Color(0xFF00B477), //  Color
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),

                // ============================================================
              ],
            ),
          ),
        ],
      ),
    );
  }
}

