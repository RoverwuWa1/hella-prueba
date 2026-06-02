import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/cuadro_retos.dart';
import '../../../data/services/challenges_services.dart';
import '../../../data/modules/challenge_module.dart';

// ============================================================
//  NO TOCAR — Convertida a StatefulWidget para manejar
// el estado de carga y la lista de retos de Firestore.
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
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarRetos(); //  NO TOCAR — carga los retos al abrir la pantalla
  }

  // ============================================================
  //  NO TOCAR — Carga los retos desde Firestore
  // ============================================================
  Future<void> _cargarRetos() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final retos = await _service.getChallengesConProgreso(uid);
      if (mounted) {
        setState(() {
          _retos = retos;
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
  //  NO TOCAR — Marca un reto como completado
  // ============================================================
  Future<void> _completarReto(ChallengeModel reto) async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await _service.completarReto(uid, reto.id);
      await _cargarRetos(); // recarga la lista actualizada
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
  // ============================================================

  @override
  Widget build(BuildContext context) {
    //  NO TOCAR — Separa los retos en dos listas
    final porCumplir = _retos.where((r) => !r.completado).toList();
    final cumplidos = _retos.where((r) => r.completado).toList();

    return Scaffold(
      // ============================================================
      //  BLOQUE 1 — AppBar
      // Cambien el título, color, íconos, lo que necesiten.
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
                      'Retos Diarios',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Comienza ahora y llena tu barra de progreso',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ========================================================
              //  NO TOCAR — Estados de carga y error
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

              // ========================================================
              // BLOQUE 3 — RETOS POR CUMPLIR
              //  Cambien el título y estilo. Las tarjetas son TarjetaReto.
              // ========================================================
              if (!_cargando && _error == null) ...[
                if (porCumplir.isNotEmpty) ...[
                  const Text(
                    'Por cumplir', //  Cambien el título
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), //  NO TOCAR
                    itemCount: porCumplir.length, //  NO TOCAR
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final reto = porCumplir[index];
                      return TarjetaReto(
                        reto: reto, //  NO TOCAR
                        onCompletar: () => _completarReto(reto), //  NO TOCAR
                      );
                    },
                  ),
                ],

                const SizedBox(height: 24),

                // ========================================================
                // BLOQUE 4 — RETOS CUMPLIDOS
                //  Cambien el título y estilo.
                // ========================================================
                if (cumplidos.isNotEmpty) ...[
                  const Text(
                    'Cumplidos', //  Cambien el título
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), //  NO TOCAR
                    itemCount: cumplidos.length, //  NO TOCAR
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final reto = cumplidos[index];
                      return TarjetaReto(
                        reto: reto, //  NO TOCAR
                        onCompletar: null, //  NO TOCAR — ya completado
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

