import 'package:flutter/material.dart';

class TarjetaReto extends StatelessWidget {
  const TarjetaReto({
    super.key,
    required this.titulo,
    required this.descripcion,
  }); //Los required sirven para

  //Creamos las variables para el texto dentro de la tarjeta
  final String titulo;
  final String descripcion;

  @override
  Widget build(BuildContext context) {
    //CREAMOS TARJETA
    return Container(
      width: double.infinity, // Ocupa todo el ancho disponible
      height: 250, // fijo para cada tarjeta
      padding: const EdgeInsets.all(16.0), // Espaciado interno
      decoration: BoxDecoration(
        // Estilo de la tarjeta
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
        border: Border.all(
          color: const Color.fromARGB(
            255,
            175,
            241,
            200,
          ), // El color del borde (tu verde principal)
          width: 1.0, // El grosor del borde en píxeles
        ),
      ),

      //CONTENIDO DE LA TARJETA
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Alinea arriba en las esquinas
        children: [
          //CUADRITO VERDE CON ICONO
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), // Verde clarito de fondo
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(width: 12), // Espacio entre el cuadrado y el texto
          //Agregamos VARIABLES para agregar texto y descripcion del momento
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo, // variable de texto para el título
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall, // Usamos el estilo definido en el tema
                ),
                const SizedBox(height: 4),
                Text(
                  descripcion, // Tu variable de texto para la descripción
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
