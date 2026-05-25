// =================================================================
//  CLASE AuthService
// =================================================================
//  Esta clase maneja toda la lógica de autenticación con Firebase.
//  Incluye métodos para registrarse, iniciar sesión, cerrar sesión,
//  restablecer contraseña y eliminar cuenta.
// =================================================================

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  // Instancias de los servicios de Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =================================================================
  //  STREAM DEL ESTADO DE AUTENTICACIÓN
  // =================================================================
  //  Este stream notifica a la aplicación en tiempo real si el
  //  usuario ha iniciado o cerrado sesión. Es fundamental para
  //  redirigir al usuario a la pantalla correcta.
  // =================================================================
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // =================================================================
  //  OBTENER USUARIO ACTUAL
  // =================================================================
  //  Devuelve el objeto User de Firebase si hay una sesión activa,
  //  o null si no la hay.
  // =================================================================
  User? get currentUser => _auth.currentUser;

  // =================================================================
  //  REGISTRO CON EMAIL Y CONTRASEÑA
  // =================================================================
  Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      // Crea el usuario en Firebase Authentication
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(), // Elimina espacios en blanco
        password: password,
      );

      // Si se proporciona un nombre, lo actualiza en el perfil
      if (displayName != null && displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName);
      }

      // Guarda la información del usuario en Firestore
      await _saveUserToFirestore(credential.user);

      return credential;
    } on FirebaseAuthException catch (e) {
      // Maneja errores específicos de Firebase y lanza una excepción
      throw _handleAuthException(e);
    }
  }

  // =================================================================
  //  LOGIN CON EMAIL Y CONTRASEÑA
  // =================================================================
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Inicia sesión con las credenciales proporcionadas
      final UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Actualiza la información del usuario en Firestore
      await _saveUserToFirestore(credential.user);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // =================================================================
  //  LOGIN CON GOOGLE
  // =================================================================
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Abre el popup de inicio de sesión de Google
      final GoogleSignInAccount? googleAccount =
          await _googleSignIn.signIn();

      // Si el usuario cancela, retorna null
      if (googleAccount == null) return null;

      // Obtiene las credenciales de autenticación de Google
      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      // Crea una credencial de Firebase a partir de las de Google
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión en Firebase con la credencial
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Guarda/actualiza la información del usuario en Firestore
      await _saveUserToFirestore(userCredential.user);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }
  // Inicio de sesión anónimo — solo para desarrollo
  Future<UserCredential?> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // =================================================================
  //  CERRAR SESIÓN
  // =================================================================
  Future<void> signOut() async {
    // Cierra sesión tanto en Firebase como en Google
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // =================================================================
  //  RESTABLECER CONTRASEÑA
  // =================================================================
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      // Envía un email para restablecer la contraseña
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // =================================================================
  //  ELIMINAR CUENTA
  // =================================================================
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Elimina el documento del usuario en Firestore
      await _firestore.collection('users').doc(user.uid).delete();
      // Elimina la cuenta de Firebase Authentication
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // =================================================================
  //  GUARDAR USUARIO EN FIRESTORE (PRIVADO)
  // =================================================================
  //  Crea o actualiza un documento en la colección 'users' con
  //  la información del usuario.
  // =================================================================
  Future<void> _saveUserToFirestore(User? user) async {
    if (user == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);

    // Usa 'set' con 'merge: true' para crear o actualizar el documento
    await docRef.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'lastSignIn': FieldValue.serverTimestamp(), // Marca de tiempo de último login
    }, SetOptions(merge: true));

    // Si el documento es nuevo, añade la fecha de creación
    final snapshot = await docRef.get();
    if (snapshot.data()?['createdAt'] == null) {
      await docRef.update({'createdAt': FieldValue.serverTimestamp()});
    }
  }

  // =================================================================
  //  MANEJO DE ERRORES DE FIREBASE (PRIVADO)
  // =================================================================
  //  Traduce los códigos de error de FirebaseAuth a mensajes
  //  más amigables para el usuario.
  // =================================================================
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Este correo ya está registrado.';
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'user-not-found':
        return 'No existe una cuenta con este correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      case 'requires-recent-login':
        return 'Debes volver a iniciar sesión para realizar esta acción.';
      case 'network-request-failed':
        return 'Error de red. Verifica tu conexión.';
      default:
        return 'Error: ${e.message ?? 'Ocurrió un error inesperado.'}';
    }
  }
}
