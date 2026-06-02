import 'package:flutter/material.dart';
import '../widgets/cuadro_retos.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ============================================================
      //  BLOQUE 1 — AppBar
      // Cambien el título, color, íconos, lo que necesiten.
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
            const Text('HELLA'), //  Cambien el título
          ],
        ),
      ),

      body: SingleChildScrollView(
        // NO TOCAR – evita el overflow
        child: Padding(
          //  DISEÑO: Espaciado de la pantalla
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // ========================================================
              // BLOQUE 2 - CONTENEDOR VERDE
              // ========================================================
              Container(
                width: 380,
                height: 182,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B8544),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color:
                          Colors.black12, // Negro con 12% de opacidad ya listo
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  //Agregamos degradado horizontal
                  gradient: const LinearGradient(
                    begin: Alignment
                        .topLeft, //Degradado inicia en esquina izquierda
                    end: Alignment
                        .bottomRight, //termina en derecha con un verde mas oscuro
                    colors: [
                      //Colores para el degradado
                      Color.fromARGB(255, 25, 190, 89), // Verde claro arriba
                      Color(0xFF166D37), // Verde oscuro abajo
                    ],
                  ),
                ),

                //Hijos del container (El texto dentro del cuadro verde o otros elementos que quieran agregar)
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
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // ========================================================
              // BLOQUE 3 - CONTENIDO CON MARGEN ( Todos los retos van aqui)
              // ========================================================
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECCIÓN: POR CUMPLIR ---
                  const SizedBox(height: 12),
                  const TarjetaReto(
                    titulo: 'Lleva tu propia bolsa',
                    descripcion:
                        'Evita usar bolsas de plástico de un solo uso.',
                  ),

                  const SizedBox(height: 24),

                  // --- SECCIÓN: CUMPLIDOS ---
                  const Text(
                    'Cumplidos',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return const ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Reto cumplido'),
                        subtitle: Text('Descripción del reto'),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
