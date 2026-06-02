import 'package:cloud_firestore/cloud_firestore.dart';
import '../modules/challenge_module.dart';

// ============================================================
//  NO TOCAR — Servicio de retos
// Maneja toda la comunicación con Firestore:
// - Obtener los 21 retos con el progreso del usuario
// - Marcar un reto como completado
// ============================================================
class ChallengesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================================
  //  NO TOCAR — Obtiene los 21 retos combinados con el progreso
  // del usuario. Devuelve cada reto con su estado completado/pendiente.
  //
  // Uso en ChallengesScreen:
  // final retos = await _service.getChallengesConProgreso(uid);
  // ============================================================
  Future<List<ChallengeModel>> getChallengesConProgreso(String uid) async {
    try {
      // 1. Trae los 21 retos de la colección challenges
      final retosSnapshot = await _firestore
          .collection('challenges')
          .orderBy('dia')
          .get();

      // 2. Trae el progreso del usuario
      final progresoSnapshot = await _firestore
          .collection('usuarios')
          .doc(uid)
          .collection('progreso')
          .get();

      // 3. Convierte el progreso en un mapa para búsqueda rápida
      final progresoMap = {for (var doc in progresoSnapshot.docs) doc.id: true};

      // 4. Combina los retos con el progreso del usuario
      return retosSnapshot.docs.map((doc) {
        final completado = progresoMap.containsKey(doc.id);
        return ChallengeModel.fromFirestore(doc, completado: completado);
      }).toList();
    } catch (e) {
      throw 'Error al obtener los retos: $e';
    }
  }

  // ============================================================
  //  NO TOCAR — Marca un reto como completado en Firestore
  // Guarda el reto en usuarios/{uid}/progreso/{idReto}
  // Cada reto vale 1 punto — el progreso es retosCompletados/21
  //
  // Uso:
  // await _service.completarReto(uid, reto.id);
  // ============================================================
  Future<void> completarReto(String uid, String idReto) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(uid)
          .collection('progreso')
          .doc(idReto)
          .set({
            'completado': true,
            'fechaCompletado': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw 'Error al completar el reto: $e';
    }
  }

  // ============================================================
  //  NO TOCAR — Obtiene el progreso total del usuario
  // Devuelve cuántos retos ha completado (0-21)
  //
  // Uso para la barra de progreso:
  // final completados = await _service.getProgreso(uid);
  // double progreso = completados / 21;
  // ============================================================
  Future<int> getProgreso(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('usuarios')
          .doc(uid)
          .collection('progreso')
          .get();

      return snapshot.docs.length; // número de retos completados
    } catch (e) {
      throw 'Error al obtener el progreso: $e';
    }
  }
}

