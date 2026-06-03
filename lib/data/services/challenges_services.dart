import 'package:cloud_firestore/cloud_firestore.dart';
import '../modules/challenge_module.dart';

// ============================================================
//  NO TOCAR — Servicio de retos
// ============================================================
class ChallengesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============================================================
  //  NO TOCAR — Obtiene los 21 retos combinados con el progreso
  // del usuario. Calcula cuál es el siguiente reto disponible
  // según la regla de las 6:00 AM.
  // ============================================================
  Future<List<ChallengeModel>> getChallengesConProgreso(String uid) async {
    try {
      final retosSnapshot = await _firestore
          .collection('challenges')
          .orderBy('dia')
          .get();

      final progresoSnapshot = await _firestore
          .collection('usuarios')
          .doc(uid)
          .collection('progreso')
          .get();

      final progresoMap = {
        for (var doc in progresoSnapshot.docs)
          doc.id: (doc.data()['fechaCompletado'] as Timestamp?)?.toDate(),
      };

      DateTime? ultimaFechaCompletado;
      for (var doc in progresoSnapshot.docs) {
        final fecha = (doc.data()['fechaCompletado'] as Timestamp?)?.toDate();
        if (fecha != null) {
          if (ultimaFechaCompletado == null ||
              fecha.isAfter(ultimaFechaCompletado)) {
            ultimaFechaCompletado = fecha;
          }
        }
      }

      final bool siguienteDisponible = _esSiguienteDisponible(
        ultimaFechaCompletado,
      );
      final retosCompletados = progresoMap.length;

      final List<ChallengeModel> retos = [];
      for (int i = 0; i < retosSnapshot.docs.length; i++) {
        final doc = retosSnapshot.docs[i];
        final completado = progresoMap.containsKey(doc.id);
        final esSiguiente = i == retosCompletados;
        final activo = esSiguiente && siguienteDisponible;

        retos.add(
          ChallengeModel.fromFirestore(
            doc,
            completado: completado,
            activo: activo,
          ),
        );
      }

      return retos;
    } catch (e) {
      throw 'Error al obtener los retos: $e';
    }
  }

  // ============================================================
  //  NO TOCAR — Calcula si el siguiente reto está disponible
  // ============================================================
  bool _esSiguienteDisponible(DateTime? ultimaFechaCompletado) {
    if (ultimaFechaCompletado == null) return true;
    final ahora = DateTime.now();
    final diaSiguiente = DateTime(
      ultimaFechaCompletado.year,
      ultimaFechaCompletado.month,
      ultimaFechaCompletado.day + 1,
      6,
      0,
      0,
    );
    return ahora.isAfter(diaSiguiente);
  }

  // ============================================================
  //  NO TOCAR — Calcula cuándo se desbloquea el siguiente reto
  // Devuelve null si ya está disponible o no hay retos completados.
  // Devuelve la fecha de desbloqueo si todavía está bloqueado.
  //
  // Uso en ChallengesScreen:
  // final fechaDesbloqueo = _service.getFechaDesbloqueo(ultimaFecha);
  // Si es null → ya disponible
  // Si no es null → mostrar el banner con esa fecha
  // ============================================================
  DateTime? getFechaDesbloqueo(DateTime? ultimaFechaCompletado) {
    if (ultimaFechaCompletado == null) return null;

    final diaSiguiente = DateTime(
      ultimaFechaCompletado.year,
      ultimaFechaCompletado.month,
      ultimaFechaCompletado.day + 1,
      6,
      0,
      0,
    );

    // Si ya pasó la hora de desbloqueo → no hay banner
    if (DateTime.now().isAfter(diaSiguiente)) return null;

    // Si todavía no pasa → devuelve la fecha para mostrar en el banner
    return diaSiguiente;
  }

  // ============================================================
  //  NO TOCAR — Obtiene la fecha del último reto completado
  //
  // Uso en ChallengesScreen:
  // final ultima = await _service.getUltimaFechaCompletado(uid);
  // final fechaDesbloqueo = _service.getFechaDesbloqueo(ultima);
  // ============================================================
  Future<DateTime?> getUltimaFechaCompletado(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('usuarios')
          .doc(uid)
          .collection('progreso')
          .orderBy('fechaCompletado', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final fecha =
          (snapshot.docs.first.data()['fechaCompletado'] as Timestamp?)
              ?.toDate();
      return fecha;
    } catch (e) {
      throw 'Error al obtener la última fecha: $e';
    }
  }

  // ============================================================
  //  NO TOCAR — Marca un reto como completado en Firestore
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
  //  NO TOCAR — Obtiene el número de retos completados (0-21)
  // Uso para la barra de progreso: completados / 21
  // ============================================================
  Future<int> getProgreso(String uid) async {
    try {
      final snapshot = await _firestore
          .collection('usuarios')
          .doc(uid)
          .collection('progreso')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      throw 'Error al obtener el progreso: $e';
    }
  }
}

