import 'package:flutter/material.dart';

class GoogleSignInButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String label;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.label = 'Continuar con Google', //  Pueden cambiar el texto por defecto
  });

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

// ============================================================
//  NO TOCAR — Lógica del botón (loading, manejo del press)
// ============================================================
class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isLoading = false;

  Future<void> _handlePress() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    try {
      await widget.onPressed();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
// ============================================================

  @override
  Widget build(BuildContext context) {
    return SizedBox(

      //  DISEÑO: Cambia el ancho y alto del botón
      width: double.infinity,
      height: 52,

      child: OutlinedButton(

        onPressed: _isLoading ? null : _handlePress, //  NO TOCAR

        // ============================================================
        //  BLOQUE 1 — Estilo del botón
        // Aquí pueden cambiar el borde, color de fondo,
        // color del texto, esquinas redondeadas y sombra.
        // ============================================================
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black12),   //  Color del borde
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),        //  Esquinas redondeadas
          ),
          backgroundColor: Colors.white,                   //  Color de fondo
          foregroundColor: Colors.black87,                  //  Color del texto e ícono
          elevation: 0,                                     //  Sombra (0 = sin sombra)
        ),

        child: _isLoading

          // ============================================================
          //  BLOQUE 2 — Indicador de carga (NO TOCAR)
          // Se muestra automáticamente mientras el login está en proceso.
          // ============================================================
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFF4285F4),
              ),
            )
          // ============================================================

          // ============================================================
          //  BLOQUE 3 — Contenido del botón (logo + texto)
          // Pueden reorganizar, cambiar el espaciado o el estilo del texto.
          // El logo de Google NO se toca (ver abajo).
          // ============================================================
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _GoogleLogo(), //  NO TOCAR — logo oficial de Google
                const SizedBox(width: 12), //  Espacio entre logo y texto
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 15,          //  Tamaño del texto
                    fontWeight: FontWeight.w500, //  Peso del texto
                    color: Colors.black87, //  Color del texto
                  ),
                ),
              ],
            ),
        // ============================================================
      ),
    );
  }
}

// ============================================================
//  NO TOCAR — Logo oficial de Google
// Está dibujado con CustomPainter para no necesitar imágenes externas.
// Modificarlo puede violar las guías de marca de Google.
// ============================================================
class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(22, 22),
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final Offset center = Offset(w / 2, h / 2);
    final double radius = w / 2;

    canvas.drawCircle(center, radius, Paint()..color = Colors.white);

    final double strokeWidth = w * 0.18;
    final rect = Rect.fromCircle(center: center, radius: radius * 0.72);

    void drawArc(double start, double sweep, Color color) {
      canvas.drawArc(
        rect,
        start,
        sweep,
        false,
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }

    const double pi = 3.1415926535897932;
    drawArc(-0.25 * pi, 1.1 * pi, const Color(0xFF4285F4));
    drawArc(0.85 * pi, 0.55 * pi, const Color(0xFF34A853));
    drawArc(1.4 * pi, 0.55 * pi, const Color(0xFFFBBC05));
    drawArc(1.95 * pi, 0.4 * pi, const Color(0xFFEA4335));

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth * 0.9
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(center.dx + radius * 0.72, center.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
// ============================================================