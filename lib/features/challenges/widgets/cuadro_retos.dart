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
  final ChallengeModel reto;
  final VoidCallback? onCompletar;

  const TarjetaReto({super.key, required this.reto, this.onCompletar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0), //  Espaciado interno
      decoration: BoxDecoration(
        // ============================================================
        //  Color de fondo según estado del reto
        // Cambien los colores si quieren
        // ============================================================
        color: reto.completado
            ? const Color(0xFFF0FFF4) //  Verde muy claro si completado
            : Colors.white, //  Blanco si pendiente o bloqueado
        borderRadius: BorderRadius.circular(16), //  Esquinas
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
        border: Border.all(
          //  Color del borde según estado
          color: reto.completado
              ? const Color(0xFF00B477) //  Verde si completado
              : reto.activo
              ? const Color.fromARGB(
                  255,
                  175,
                  241,
                  200,
                ) //  Verde claro si activo
              : const Color(0xFFE0E0E0), //  Gris si bloqueado
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          //  BLOQUE 1 — Ícono del reto
          // Cambia según el estado — completado, activo o bloqueado
          // ============================================================
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  reto
                      .completado //  NO TOCAR — color según estado
                  ? const Color(0xFFE8F5E9)
                  : reto.activo
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12), //  Esquinas del ícono
            ),
            child: Icon(
              reto
                      .completado //  NO TOCAR — ícono según estado
                  ? Icons.check_rounded
                  : reto.activo
                  ? Icons.eco_outlined
                  : Icons.lock_outline_rounded,
              color:
                  reto
                      .completado //  NO TOCAR
                  ? const Color(0xFF00B477)
                  : reto.activo
                  ? const Color(0xFF00B477)
                  : const Color(0xFFB2DFCC), //  Gris verdecito si bloqueado
              size: 24, // Tamaño del ícono
            ),
          ),

          const SizedBox(width: 12),

          // ============================================================
          //  BLOQUE 2 — Texto del reto
          // Cambien los estilos de texto.
          // ============================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Día ${reto.dia}', //  NO TOCAR
                  style: TextStyle(
                    fontSize: 11, //  Tamaño
                    color:
                        reto.completado ||
                            reto
                                .activo //  NO TOCAR
                        ? const Color(0xFF00B477)
                        : const Color(
                            0xFFB2DFCC,
                          ), //  Gris verdecito si bloqueado
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  reto.titulo, //  NO TOCAR
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color:
                        reto.activo ||
                            reto
                                .completado //  NO TOCAR
                        ? null
                        : const Color(0xFFB0BEC5), //  Texto gris si bloqueado
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  reto.descripcion, //  NO TOCAR
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color:
                        reto.activo ||
                            reto
                                .completado //  NO TOCAR
                        ? null
                        : const Color(0xFFB0BEC5), //  Texto gris si bloqueado
                  ),
                ),

                const SizedBox(height: 12),

                // ============================================================
                //  BLOQUE 3 — Estado del botón (NO TOCAR lógica)
                // ============================================================

                // Reto completado — muestra texto de confirmación
                if (reto.completado)
                  const Text(
                    '✅ Reto completado', //  Cambien el texto
                    style: TextStyle(
                      color: Color(0xFF00B477), //  Color
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),

                // Reto activo — botón verde funcional
                if (!reto.completado && reto.activo)
                  BotonReto(onPressed: onCompletar), //  NO TOCAR
                // Reto bloqueado — botón gris verdecito deshabilitado
                if (!reto.completado && !reto.activo)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: null, //  NO TOCAR — deshabilitado
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFB2DFCC,
                        ), //  Gris verdecito
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), //  Esquinas
                        ),
                      ),
                      child: const Text('🔒 Bloqueado'), //  Cambien el texto
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
