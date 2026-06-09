import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> temas = [
      {
        "titulo": "Plásticos de un solo uso",
        "categoria": "Residuos",
        "imagen":
            "https://images.unsplash.com/photo-1618477462146-050d2767eac4?w=1200",
        "descripcion":
            "Los plásticos de un solo uso son productos diseñados para utilizarse una sola vez antes de desecharse. Representan una de las principales fuentes de contaminación ambiental.",
        "efectos": [
          "Contaminación de océanos",
          "Daño a especies marinas",
          "Acumulación de residuos",
          "Microplásticos en alimentos",
        ],
        "icono": Icons.delete_outline,
      },
      {
        "titulo": "Emisiones de CO₂",
        "categoria": "Cambio Climático",
        "imagen":
            "https://images.unsplash.com/photo-1473448912268-2022ce9509d8?w=1200",
        "descripcion":
            "Las emisiones de dióxido de carbono son uno de los principales gases responsables del efecto invernadero y del calentamiento global.",
        "efectos": [
          "Aumento de temperatura",
          "Eventos climáticos extremos",
          "Derretimiento de glaciares",
          "Incremento del nivel del mar",
        ],
        "icono": Icons.cloud_outlined,
      },
      {
        "titulo": "Contaminación del Agua",
        "categoria": "Recursos Hídricos",
        "imagen":
            "https://images.unsplash.com/photo-1437482078695-73f5ca6c96e2?w=1200",
        "descripcion":
            "La contaminación del agua ocurre cuando sustancias dañinas llegan a ríos, lagos y océanos, afectando a los ecosistemas y a las personas.",
        "efectos": [
          "Muerte de especies acuáticas",
          "Menor disponibilidad de agua potable",
          "Problemas de salud",
          "Desequilibrio ecológico",
        ],
        "icono": Icons.water_drop_outlined,
      },
      {
        "titulo": "Deforestación",
        "categoria": "Bosques",
        "imagen":
            "https://images.unsplash.com/photo-1448375240586-882707db888b?w=1200",
        "descripcion":
            "La deforestación es la eliminación masiva de árboles y bosques, afectando la biodiversidad y el equilibrio climático.",
        "efectos": [
          "Pérdida de biodiversidad",
          "Erosión del suelo",
          "Mayor emisión de CO₂",
          "Alteración de ecosistemas",
        ],
        "icono": Icons.forest_outlined,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo2.png', width: 33),
            const SizedBox(width: 10),
            const Text('HELLA'),
          ],
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 180,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1DB954), Color(0xFF188038)],
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Hábitos que cuidan\nel planeta",
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Aprende sobre los principales problemas ambientales y cómo ayudar al planeta.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: temas.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),

                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.green.shade100,
                        child: Icon(
                          temas[index]["icono"],
                          color: Colors.green.shade700,
                        ),
                      ),

                      title: Text(
                        temas[index]["titulo"],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Text(temas[index]["categoria"]),

                      trailing: const Icon(Icons.arrow_forward_ios, size: 18),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InfoScreen(tema: temas[index]),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  final Map<String, dynamic> tema;

  const InfoScreen({super.key, required this.tema});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("EcoHábitos"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 4,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                child: Image.network(
                  tema["imagen"],
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tema["categoria"],
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      tema["titulo"],
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      tema["descripcion"],
                      style: const TextStyle(fontSize: 18, height: 1.6),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Efectos",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    ...tema["efectos"].map<Widget>(
                      (efecto) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.eco, color: Colors.green),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                efecto,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
