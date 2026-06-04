import 'package:flutter/material.dart';

// ============================================================
//  WIDGET: BotonReto
// Botón para cumplir un reto. Se usa dentro de TarjetaReto.
//
// Uso:
// BotonReto(onPressed: () async => await _service.completarReto(...))
// ============================================================
class BotonReto extends StatelessWidget {
  final VoidCallback? onPressed; //  NO TOCAR — acción al presionar

  const BotonReto({
    super.key,
    required this.onPressed, //  NO TOCAR
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed, //  NO TOCAR
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF17803E), //  Color del botón
          foregroundColor: Colors.white, //  Color del texto
          elevation: 0, //  Sombra
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), //  Esquinas
          ),
        ),
        child: const Text('¡Cumplir reto!'), //  Cambien el texto
      ),
    );
  }
}
