import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/cuadro_retos.dart';
import '../../../data/services/challenges_services.dart';
import '../../../data/modules/challenge_module.dart';

// ============================================================
//  NO TOCAR — StatefulWidget para manejar estado de Firestore
// ============================================================
class ChallengesScreen extends StatefulWidget {
  const ChallengesScreen({super.key});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen> {
  //  NO TOCAR — Servicio y estado
  final ChallengesService _service = ChallengesService();
  List<ChallengeModel> _retos = [];
  DateTime? _fechaDesbloqueo;
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarRetos(); //  NO TOCAR
  }

  // ============================================================
  //  NO TOCAR — Carga los retos y la fecha de desbloqueo
  // ============================================================
  Future<void> _cargarRetos() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Carga retos y fecha de desbloqueo al mismo tiempo
      final resultados = await Future.wait([
        _service.getChallengesConProgreso(uid),
        _service.getUltimaFechaCompletado(uid),
      ]);

      final retos = resultados[0] as List<ChallengeModel>;
      final ultimaFecha = resultados[1] as DateTime?;
      final desbloqueo = _service.getFechaDesbloqueo(ultimaFecha);

      if (mounted) {
        setState(() {
          _retos = retos;
          _fechaDesbloqueo = desbloqueo;
          _cargando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _cargando = false;
        });
      }
    }
  }

  // ============================================================
  //  NO TOCAR — Marca un reto como completado y recarga
  // ============================================================
  Future<void> _completarReto(ChallengeModel reto) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await _service.completarReto(uid, reto.id);
      await _cargarRetos();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  // ============================================================
  //  NO TOCAR — Formatea la fecha de desbloqueo
  // Ej: "mañana a las 6:00 AM" o "el martes a las 6:00 AM"
  // ============================================================
  String _formatearFechaDesbloqueo(DateTime fecha) {
    final ahora = DateTime.now();
    final manana = DateTime(ahora.year, ahora.month, ahora.day + 1);
    final esManana =
        fecha.year == manana.year &&
        fecha.month == manana.month &&
        fecha.day == manana.day;

    if (esManana) return 'mañana a las 6:00 AM';

    const dias = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    final nombreDia = dias[fecha.weekday - 1];
    return 'el $nombreDia a las 6:00 AM';
  }
  // ============================================================

  @override
  Widget build(BuildContext context) {
    //  NO TOCAR — Separa los retos
    final completados = _retos.where((r) => r.completado).toList();
    final pendientes = _retos.where((r) => !r.completado).toList();

    return Scaffold(
      // ============================================================
      // BLOQUE 1 — AppBar
      //  Cambien el título, color, íconos, lo que necesiten.
      // ============================================================
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo2.png', width: 33),
            const SizedBox(width: 10),
            const Text('HELLA'), //  Cambien el título
          ],
        ),
      ),

      body: SingleChildScrollView(
        //  NO TOCAR — evita el overflow
        child: Padding(
          padding: const EdgeInsets.all(16), //  Espaciado de la pantalla
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // ========================================================
              // BLOQUE 2 — CONTENEDOR VERDE
              //  Cambien colores, textos y estilos libremente
              // ========================================================
              Container(
                width: double.infinity,
                height: 182,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 25, 190, 89),
                      Color(0xFF166D37),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Retos Diarios', //  Cambien el texto
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Comienza ahora y llena tu barra de progreso', //  Cambien el texto
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ========================================================
              //  NO TOCAR — Banner de desbloqueo
              // Solo aparece cuando el siguiente reto aún está bloqueado.
              // ========================================================
              if (_fechaDesbloqueo != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFE8F5E9,
                    ), //  Color de fondo del banner
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFB2DFCC), //  Color del borde
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Color(0xFF00B477), //  Color del ícono
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Completaste el reto de hoy 🎉 El siguiente se desbloquea ${_formatearFechaDesbloqueo(_fechaDesbloqueo!)}', // 🎨 Cambien el texto
                          style: const TextStyle(
                            fontSize: 13, //  Tamaño
                            color: Color(0xFF2E7D32), //  Color del texto
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ========================================================
              const SizedBox(height: 16),

              // ========================================================
              //  NO TOCAR — Loading y error
              // ========================================================
              if (_cargando)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00B477)),
                ),

              if (_error != null)
                Center(
                  child: Text(
                    'Error al cargar los retos',
                    style: TextStyle(color: Colors.red[400]),
                  ),
                ),

              // ========================================================
              if (!_cargando && _error == null) ...[
                // ========================================================
                // BLOQUE 3 — RETOS PENDIENTES
                //  Cambien el título y estilo.
                // ========================================================
                if (pendientes.isNotEmpty) ...[
                  const Text(
                    'Por cumplir', //  Cambien el título
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), //  NO TOCAR
                    itemCount: pendientes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final reto = pendientes[index];
                      return TarjetaReto(
                        reto: reto, //  NO TOCAR
                        onCompletar:
                            reto
                                .activo //  NO TOCAR
                            ? () => _completarReto(reto)
                            : null,
                      );
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // ========================================================
                // BLOQUE 4 — RETOS COMPLETADOS
                //  Cambien el título y estilo.
                // ========================================================
                if (completados.isNotEmpty) ...[
                  const Text(
                    'Cumplidos', //  Cambien el título
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), //  NO TOCAR
                    itemCount: completados.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final reto = completados[index];
                      return TarjetaReto(
                        reto: reto, //  NO TOCAR
                        onCompletar: null, //  NO TOCAR
                      );
                    },
                  ),
                ],
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

