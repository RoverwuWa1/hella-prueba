import 'package:flutter/material.dart';
import '../../../data/services/auth_services.dart';
import '../widgets/google_sign_in_buttom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// ============================================================
//  NO TOCAR — Lógica de autenticación
// ============================================================
class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  String? _errorMessage;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _errorMessage = null);
    try {
      final user = await _authService.signInWithGoogle();
      if (user == null) return;
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    }
  }
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  DISEÑO: Color de fondo
      backgroundColor: const Color(0xFFF1FBF3),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 95),

            // ============================================================
            //  BLOQUE 1 — Ícono y nombre de la app
            // Cambien el ícono, color, tamaño y nombre de la app.
            // ============================================================
            Image.asset('assets/images/logo1.png', width: 300),

            const SizedBox(height: 10),

            const Text(
              'Hella', //  Nombre de la app
              style: TextStyle(
                fontSize: 35, //  Tamaño
                fontWeight: FontWeight.bold, //  Peso
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Cuida el planeta, cambia tus hábitos', //  Subtítulo
              style: TextStyle(
                fontSize: 18, //  Tamaño
                color: Color.fromRGBO(76, 175, 80, 1), //  Color
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 60),

            // ============================================================
            //  BLOQUE 2 — Contenedor blanco
            // Cambien el tamaño, color, esquinas y padding.
            // ============================================================
            Container(
              width: 400, //  Ancho
              padding: const EdgeInsets.all(28.0), //  Espaciado interno
              decoration: BoxDecoration(
                color: Colors.white, //  Color de fondo
                borderRadius: BorderRadius.circular(20), //  Esquinas
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ============================================================
                  //  BLOQUE 3 — Título del contenedor
                  // Cambien el texto y estilo.
                  // ============================================================
                  const Text(
                    'Iniciar sesión', //  Cambien el texto
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24, //  Tamaño
                      fontWeight: FontWeight.bold, //  Peso
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Usa tu cuenta de Google para continuar', //  Cambien el texto
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13, //  Tamaño
                      color: Colors.black54, //  Color
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ============================================================
                  //  BLOQUE 4 — Botón de Google (NO TOCAR onPressed)
                  // Solo pueden cambiar el texto del label.
                  // El onPressed NO se toca — es la lógica de login.
                  // ============================================================
                  GoogleSignInButton(
                    onPressed: _handleGoogleSignIn, //  NO TOCAR
                    label: 'Continuar con Google', //  Pueden cambiar el texto
                  ),

                  // ============================================================
                  //  SOLO DESARROLLO — Quitar al ultimo de la app
                  // ============================================================
                  TextButton(
                    onPressed: () async {
                      await _authService.signInAnonymously();
                    },
                    child: const Text('Entrar como invitado (dev)'),
                  ),
                  // ============================================================

                  // ============================================================
                  //  BLOQUE 5 — Mensaje de error (NO TOCAR)
                  // Este bloque muestra errores si el login falla.
                  // No mover ni modificar nada aquí.
                  // ============================================================
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFFFCDD2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Color(0xFFE53935),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Color(0xFFE53935),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ============================================================
                  const SizedBox(height: 24),

                  // ============================================================
                  //  BLOQUE 6 — Texto legal
                  // Pueden cambiar el texto, estilo o quitarlo.
                  // ============================================================
                  const Text(
                    'Al continuar aceptas nuestros Términos y Política de privacidad',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11, //  Tamaño
                      color: Colors.black38, //  Color
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
