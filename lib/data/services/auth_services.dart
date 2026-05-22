import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Stream del usuario actual ──────────────────────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Usuario actual ─────────────────────────────────────────────────────────
  User? get currentUser => _auth.currentUser;

  // ── Registro con email y contraseña ───────────────────────────────────────
  Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (displayName != null && displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName);
      }

      await _saveUserToFirestore(credential.user);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Login con email y contraseña ───────────────────────────────────────────
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential =
          await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _saveUserToFirestore(credential.user);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Login con Google ───────────────────────────────────────────────────────
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleAccount =
          await _googleSignIn.signIn();

      if (googleAccount == null) return null; // Usuario canceló

      final GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      await _saveUserToFirestore(userCredential.user);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Cerrar sesión ──────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  // ── Restablecer contraseña ─────────────────────────────────────────────────
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Eliminar cuenta ────────────────────────────────────────────────────────
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // ── Guardar / actualizar usuario en Firestore ──────────────────────────────
  Future<void> _saveUserToFirestore(User? user) async {
    if (user == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);

    await docRef.set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'lastSignIn': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    // Solo setea createdAt si el documento es nuevo
    final snapshot = await docRef.get();
    if (snapshot.data()?['createdAt'] == null) {
      await docRef.update({'createdAt': FieldValue.serverTimestamp()});
    }
  }

  // ── Manejo de errores de Firebase ──────────────────────────────────────────
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