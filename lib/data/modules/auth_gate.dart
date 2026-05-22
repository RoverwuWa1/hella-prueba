import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../../features/auth/view/login_screen.dart';
import '../../features/challenges/view/home_screen.dart'; // Cámbialo por tu pantalla principal

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // ── Esperando respuesta de Firebase ───────────────────────────────
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }

        // ── Error inesperado ───────────────────────────────────────────────
        if (snapshot.hasError) {
          return const _ErrorScreen();
        }

        // ── Sin sesión → Login ─────────────────────────────────────────────
        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreen();
        }

        // ── Con sesión → Home ──────────────────────────────────────────────
        return const HomeScreen();
      },
    );
  }
}

// ── Pantalla de carga mientras Firebase inicializa ─────────────────────────
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF4285F4),
              strokeWidth: 2.5,
            ),
            SizedBox(height: 16),
            Text(
              'Cargando...',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pantalla de error ──────────────────────────────────────────────────────
class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Color(0xFFE53935), size: 48),
            SizedBox(height: 16),
            Text(
              'Algo salió mal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Reinicia la aplicación',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}