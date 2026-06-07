import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/banner_widget.dart';
import '../widgets/progres_tracker_widget.dart';
import '../../../data/services/challenges_services.dart';
import '../../../data/modules/challenge_module.dart';
import '../widgets/cuadro_retos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //  NO TOCAR — Servicio y estado
  final ChallengesService _service = ChallengesService();
  final User? user = FirebaseAuth.instance.currentUser;

  List<ChallengeModel> _retos = [];
  DateTime? _fechaDesbloqueo;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarRetos(); //  NO TOCAR
  }

  // ============================================================
  //  NO TOCAR — Carga los retos y la fecha de desbloqueo
  // ============================================================
  Future<void> _cargarRetos() async {
    final uid = user!.uid;

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
  }

  // ============================================================
  //  NO TOCAR — Marca un reto como completado y recarga
  // ============================================================
  Future<void> _completarReto(ChallengeModel reto) async {
    final uid = user!.uid;
    await _service.completarReto(uid, reto.id);
    await _cargarRetos();
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

  // ============================================================
  //  NO TOCAR — Lógica del saludo según hora del día
  // ============================================================
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ============================================================
    //  NO TOCAR — Datos del usuario desde Firebase
    // ============================================================
    final String firstName = user?.displayName?.split(' ').first ?? 'Usuario';
    // ============================================================

    //  NO TOCAR — Separa los retos
    final pendientes = _retos.where((r) => !r.completado).toList();
    final retoActual = pendientes.isNotEmpty ? pendientes.first : null;

    return Scaffold(
      // ============================================================
      //  BLOQUE 1 — AppBar
      // Pueden cambiar el título, color, agregar íconos, etc.
      // ============================================================
      appBar: AppBar(
        //Forzamos a que el contenido NO se centre automáticamente
        centerTitle: false,
        title: Row(
          //Alinea verticalmente el texto y la imagen al centro
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo2.png', width: 33),
            //El SizedBox va en medio de los dos para separarlos un poco
            const SizedBox(width: 10),
            Text(
              _getGreeting(), //saludo dinámico (NO TOCAR)
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          //  DISEÑO: Espaciado de la pantalla
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              //  BLOQUE 2 — Sección principal
              // Aquí va el contenido de bienvenida de la app.
              // ============================================================
              const SizedBox(height: 12),

              //  Aquí va el banner_widget (el cuadro de color verde grande)
              BannerWidget(firstName: firstName),

              const SizedBox(height: 24),

              //Barra de seguimiento
              const ProgressTracker(),
              const SizedBox(height: 24), // Un espacio después de la barra

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
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9), //  Color de fondo del banner
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
                          'Completaste el reto de hoy 🎉 El siguiente se desbloquea ${_formatearFechaDesbloqueo(_fechaDesbloqueo!)}', //  Cambien el texto
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

              // ============================================================
              //  BLOQUE 3 — Lista de contenido
              // Aquí va una lista, grid o lo que sea el core de la app.
              // Cambien el ícono, textos y colores de cada item.
              // ============================================================
              const Text(
                'Reto de hoy', //  Cambien este título
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              // ============================================================
              //  NO TOCAR — Loading, estados vacíos y tarjeta del reto
              // ============================================================
              if (_cargando)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00B477)),
                )
              else if (retoActual == null)
                const Center(
                  child: Text("🎉 Ya completaste todos los retos"),
                )
              else
                TarjetaReto(
                  reto: retoActual, //  NO TOCAR
                  onCompletar: retoActual.activo
                      ? () => _completarReto(retoActual)
                      : null,
                ),
              // ============================================================

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
