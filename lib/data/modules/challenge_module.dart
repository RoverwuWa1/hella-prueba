import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================================
//  NO TOCAR — Modelo de datos de un Reto
// Esta clase define la estructura de un reto tal como
// viene de Firestore combinado con el progreso del usuario.
// ============================================================
class ChallengeModel {
  final String id; //  ID del documento en Firestore
  final int dia;
  final int puntos;
  final String titulo;
  final String descripcion;
  final bool completado; //  Viene del progreso del usuario

  const ChallengeModel({
    required this.id,
    required this.dia,
    required this.puntos,
    required this.titulo,
    required this.descripcion,
    this.completado = false, //  Por defecto no completado
  });

  // ============================================================
  //  NO TOCAR — Convierte un documento de Firestore a ChallengeModel
  // El campo completado se pasa por separado desde el progreso
  // del usuario — no viene del documento del reto.
  // ============================================================
  factory ChallengeModel.fromFirestore(
    DocumentSnapshot doc, {
    bool completado = false,
  }) {
    final data = doc.data() as Map<String, dynamic>;
    return ChallengeModel(
      id: doc.id,
      dia: (data['dia'] as num).toInt(),
      puntos: (data['puntos'] as num).toInt(),
      titulo: data['titulo'] as String,
      descripcion: data['descripcion'] as String,
      completado: completado,
    );
  }

  // ============================================================
  //  NO TOCAR — Crea una copia del modelo con completado cambiado
  // Se usa para actualizar el estado sin modificar el original.
  // ============================================================
  ChallengeModel copyWith({bool? completado}) {
    return ChallengeModel(
      id: id,
      dia: dia,
      puntos: puntos,
      titulo: titulo,
      descripcion: descripcion,
      completado: completado ?? this.completado,
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
    return 'ChallengeModel(id: $id, dia: $dia, titulo: $titulo, completado: $completado)';
  }
}
