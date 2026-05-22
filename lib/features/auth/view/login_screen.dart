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

      //  DISEÑO: Cambia el color de fondo de la pantalla
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(

          //  DISEÑO: Ajusta el espacio a los lados
          padding: const EdgeInsets.symmetric(horizontal: 32),

          child: Column(
            children: [

              const Spacer(),

              // ============================================================
              //  BLOQUE 1 — Logo o imagen de la app
              // Aquí va el logo, ícono o imagen principal de la app.
              // Se puede cambiar el ícono, poner una imagen, cambiar
              // el color o quitar el contenedor por completo.
              // ============================================================
              const Icon(
                Icons.lock_outline_rounded,
                size: 64,
                color: Colors.black,
              ),

              const SizedBox(height: 24),

              // ============================================================
              //  BLOQUE 2 — Títulos y textos de bienvenida
              // Cambien los textos, tamaños, colores y fuentes
              // según el estilo de la app.
              // ============================================================
              const Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Inicia sesión para continuar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const Spacer(),

              // ============================================================
              //  BLOQUE 3 — Botón de Google (NO TOCAR onPressed)
              // Solo pueden cambiar el texto del label si quieren.
              // El onPressed NO se toca — es la lógica de login.
              // ============================================================
              GoogleSignInButton(
                onPressed: _handleGoogleSignIn, //  NO TOCAR
                label: 'Continuar con Google',  //  Pueden cambiar el texto
              ),

              // ============================================================
              //  BLOQUE 4 — Mensaje de error (NO TOCAR)
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
                      const Icon(Icons.error_outline,
                          color: Color(0xFFE53935), size: 18),
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
              //  BLOQUE 5 — Texto legal
              // Pueden cambiar el texto, estilo o quitarlo si no lo necesitan.
              // ============================================================
              const Text(
                'Al continuar aceptas nuestros Términos y Política de privacidad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black38,
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}