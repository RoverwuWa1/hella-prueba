import 'package:flutter/material.dart';

class GoogleSignInButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final String label;

  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.label = 'Continuar con Google',
  });

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: _isLoading ? null : _handlePress,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFDADADA)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF3C4043),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color(0xFF4285F4),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _GoogleLogo(),
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                      color: Color(0xFF3C4043),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Logo de Google dibujado con CustomPainter (sin assets externos)
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

    // Fondo blanco circular
    canvas.drawCircle(center, radius, Paint()..color = Colors.white);

    // Arcos de colores Google
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
    drawArc(-0.25 * pi, 1.1 * pi, const Color(0xFF4285F4)); // Azul
    drawArc(0.85 * pi, 0.55 * pi, const Color(0xFF34A853)); // Verde
    drawArc(1.4 * pi, 0.55 * pi, const Color(0xFFFBBC05));  // Amarillo
    drawArc(1.95 * pi, 0.4 * pi, const Color(0xFFEA4335)); // Rojo

    // Línea horizontal blanca (hueco del logo)
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