import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================================
//  NO TOCAR — Modelo de datos de un Reto
// ============================================================
class ChallengeModel {
  final String id;
  final int dia;
  final int puntos;
  final String titulo;
  final String descripcion;
  final bool completado;
  final bool activo; //  true = botón disponible, false = bloqueado

  const ChallengeModel({
    required this.id,
    required this.dia,
    required this.puntos,
    required this.titulo,
    required this.descripcion,
    this.completado = false,
    this.activo = false, //  por defecto bloqueado
  });

  // ============================================================
  //  NO TOCAR — Convierte un documento de Firestore a ChallengeModel
  // ============================================================
  factory ChallengeModel.fromFirestore(
    DocumentSnapshot doc, {
    bool completado = false,
    bool activo = false,
  }) {
    final data = doc.data() as Map<String, dynamic>;
    return ChallengeModel(
      id: doc.id,
      dia: (data['dia'] as num).toInt(),
      puntos: (data['puntos'] as num).toInt(),
      titulo: data['titulo'] as String,
      descripcion: data['descripcion'] as String,
      completado: completado,
      activo: activo,
    );
  }

  // ============================================================
  //  NO TOCAR — Crea una copia con campos modificados
  // ============================================================
  ChallengeModel copyWith({bool? completado, bool? activo}) {
    return ChallengeModel(
      id: id,
      dia: dia,
      puntos: puntos,
      titulo: titulo,
      descripcion: descripcion,
      completado: completado ?? this.completado,
      activo: activo ?? this.activo,
    );
  }

  // ============================================================
  //  NO TOCAR — Convierte a Map para Firestore
  // ============================================================
  Map<String, dynamic> toMap() {
    return {
      'dia': dia,
      'puntos': puntos,
      'titulo': titulo,
      'descripcion': descripcion,
    };
  }

  @override
  String toString() {
    return 'ChallengeModel(id: $id, dia: $dia, titulo: $titulo, completado: $completado, activo: $activo)';
  }
}
