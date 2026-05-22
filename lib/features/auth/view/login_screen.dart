import 'package:flutter/material.dart';
import '../../../data/services/auth_services.dart';
import '../widgets/google_sign_in_buttom.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  String? _errorMessage;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _errorMessage = null);
    try {
      final user = await _authService.signInWithGoogle();
      if (user == null) return; // Usuario canceló

      if (mounted) {
        // Navega a tu pantalla principal
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo / Ilustración
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 40,
                  color: Color(0xFF4285F4),
                ),
              ),

              const SizedBox(height: 32),

              // Título
              const Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              // Subtítulo
              const Text(
                'Inicia sesión con tu cuenta de Google\npara continuar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 2),

              // Botón de Google
              GoogleSignInButton(onPressed: _handleGoogleSignIn),

              // Mensaje de error
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

              const Spacer(),

              // Texto legal
              const Text(
                'Al continuar, aceptas nuestros\nTérminos de servicio y Política de privacidad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFFADB5BD),
                  height: 1.6,
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