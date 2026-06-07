// =================================================================
//  PUNTO DE ENTRADA DE LA APLICACIÓN (main.dart)
// =================================================================
//  Este archivo es el corazón de la aplicación. Aquí es donde todo
//  comienza. La función 'main' se ejecuta primero.
// =================================================================

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Configuración de Firebase generada automáticamente
import 'data/modules/auth_gate.dart';   // Nuestro widget "guardián" de autenticación
import 'core/teams/app_themes.dart';

// =================================================================
//  FUNCIÓN main()
// =================================================================
//  La ejecución de la app comienza aquí. Es una función asíncrona
//  porque necesita esperar a que Firebase se inicialice.
// =================================================================
void main() async {
  // 1. Asegura que los bindings de Flutter estén inicializados.
  //    Es necesario si se van a realizar operaciones asíncronas
  //    antes de que la app se dibuje en pantalla.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa Firebase.
  //    Esta línea es CRUCIAL. Conecta la app con el proyecto de Firebase
  //    usando las configuraciones del archivo 'firebase_options.dart'.
  //    'await' pausa la ejecución hasta que la conexión se complete.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Lanza la aplicación.
  //    Una vez que Firebase está listo, 'runApp' infla el widget
  //    principal (MyApp) y lo muestra en la pantalla.
  runApp(const MyApp());
}

// =================================================================
//  WIDGET MyApp (Raíz de la aplicación)
// =================================================================
//  Este es el widget principal que contiene toda la aplicación.
//  Es un StatelessWidget porque su estado no cambia directamente.
// =================================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp es el widget que nos da la estructura básica de
    // una aplicación de Material Design (rutas, temas, etc.).
    return MaterialApp(
      title: 'Hella', // Título de la app
      debugShowCheckedModeBanner: false, // Oculta la cinta de "debug"
      theme: AppTheme.theme,
      // ===============================================================
      //  PUNTO DE ENTRADA DE LA UI: AuthGate
      // ===============================================================
      //  En lugar de poner directamente una pantalla de inicio,
      //  usamos nuestro AuthGate. Él se encargará de decidir si
      //  muestra la pantalla de Login o la pantalla principal (MainScreen)
      //  dependiendo del estado de autenticación del usuario.
      // ===============================================================
      home: const AuthGate(),
    );
  }
}
