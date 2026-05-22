// =================================================================
//  WIDGET AuthGate
// =================================================================
//  Este widget actúa como un "guardián" de la autenticación.
//  Su única responsabilidad es decidir qué pantalla mostrar al usuario
//  basándose en su estado de autenticación (si ha iniciado sesión o no).
// =================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_services.dart';
import '../../features/auth/view/login_screen.dart';
import '../../core/widgets/bottom_navigation_bar.dart'; // Asegúrate que esta es tu pantalla principal

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // Instancia del servicio de autenticación para acceder al stream
    final AuthService authService = AuthService();

    // =================================================================
    //  STREAMBUILDER: EL CORAZÓN DEL AUTHGATE
    // =================================================================
    //  StreamBuilder se suscribe al stream 'authStateChanges' y se
    //  reconstruye cada vez que hay un nuevo evento (cambio en el
    //  estado de autenticación).
    // =================================================================
    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // --- ESTADO: ESPERANDO ---
        // Mientras Firebase está verificando el estado de autenticación,
        // se muestra una pantalla de carga.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _SplashScreen();
        }

        // --- ESTADO: ERROR ---
        // Si ocurre un error durante la verificación, se muestra
        // una pantalla de error genérica.
        if (snapshot.hasError) {
          return const _ErrorScreen();
        }

        // --- ESTADO: SIN SESIÓN ACTIVA ---
        // Si 'snapshot.hasData' es falso, significa que el stream
        // devolvió 'null', lo que indica que no hay un usuario
        // autenticado. Se muestra la pantalla de login.
        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreen();
        }

        // --- ESTADO: SESIÓN ACTIVA ---
        // Si 'snapshot.hasData' es verdadero y 'snapshot.data' no es null,
        // significa que hay un usuario autenticado. Se le da acceso a
        // la pantalla principal de la aplicación.
        return const MainScreen();
      },
    );
  }
}

// =================================================================
//  WIDGET PRIVADO: _SplashScreen
// =================================================================
//  Una pantalla de carga simple que se muestra mientras Firebase
//  inicializa y verifica el estado de autenticación del usuario.
// =================================================================
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8F9FA), // Un color de fondo claro y neutro
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFF4285F4), // Color de la marca Google
              strokeWidth: 2.5,
            ),
            SizedBox(height: 16),
            Text(
              'Cargando...',
              style: TextStyle(
                color: Color(0xFF6B7280), // Texto sutil
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
//  WIDGET PRIVADO: _ErrorScreen
// =================================================================
//  Una pantalla de error que se muestra si algo sale mal al
//  comunicarse con los servicios de Firebase.
// =================================================================
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
            Icon(Icons.error_outline, color: Color(0xFFE53935), size: 48), // Icono de error
            SizedBox(height: 16),
            Text(
              'Algo salió mal',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Por favor, reinicia la aplicación.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}
