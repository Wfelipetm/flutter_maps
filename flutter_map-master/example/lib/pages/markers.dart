import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Página que demonstra o uso de marcadores no Flutter Map
class MarkerPage extends StatefulWidget {
  static const String route = '/markers';

  const MarkerPage({super.key});

  @override
  State<MarkerPage> createState() => _MarkerPageState();
}

class _MarkerPageState extends State<MarkerPage> {
  Alignment selectedAlignment = Alignment.topCenter; // Alinhamento padrão
  bool counterRotate = false; // Flag para rotação inversa

  // Mapa de valores de rotação para os respetivos alinhamentos
  static const alignments = {
    315: Alignment.topLeft,
    0: Alignment.topCenter,
    45: Alignment.topRight,
    270: Alignment.centerLeft,
    null: Alignment.center,
    90: Alignment.centerRight,
    225: Alignment.bottomLeft,
    180: Alignment.bottomCenter,
    135: Alignment.bottomRight,
  };

  // Lista de marcadores personalizados com pontos pré-definidos
  late final customMarkers = <Marker>[
    buildPin(const LatLng(51.51868093513547, -0.12835376940892318)),
    buildPin(const LatLng(53.33360293799854, -6.284001062079881)),
  ];

  // Método para construir um marcador personalizado
  Marker buildPin(LatLng point) => Marker(
        point: point,
        child: const Icon(Icons.location_pin, size: 60, color: Colors.black),
        width: 60,
        height: 60,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Markers')),
      drawer: const MenuDrawer(MarkerPage.route),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: 130,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: 9,
                    itemBuilder: (_, index) {
                      final deg = alignments.keys.elementAt(index);
                      final align = alignments.values.elementAt(index);

                      return IconButton.outlined(
                        onPressed: () =>
                            setState(() => selectedAlignment = align),
                        icon: Transform.rotate(
                          angle: deg == null ? 0 : deg * pi / 180,
                          child: Icon(
                            deg == null ? Icons.circle : Icons.arrow_upward,
                            color: selectedAlignment == align
                                ? Colors.green
                                : null,
                            size: deg == null ? 16 : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Tap the map to add markers!'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Counter-rotation'),
                        const SizedBox(width: 10),
                        Switch.adaptive(
                          value: counterRotate,
                          onChanged: (v) => setState(() => counterRotate = v),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(51.5, -0.09),
                initialZoom: 5,
                onTap: (_, p) => setState(() => customMarkers.add(buildPin(p))),
                interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                openStreetMapTileLayer, // Adiciona camada de mapa OpenStreetMap

                // Camada de marcadores pré-definidos
                MarkerLayer(
                  rotate: counterRotate,
                  markers: const [
                    Marker(
                      point: LatLng(47.18664724067855, -1.5436768515939427),
                      width: 64,
                      height: 64,
                      alignment: Alignment.centerLeft,
                      child: ColoredBox(
                        color: Colors.lightBlue,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text('-->'),
                        ),
                      ),
                    ),
                    Marker(
                      point: LatLng(47.18664724067855, -1.5436768515939427),
                      width: 64,
                      height: 64,
                      alignment: Alignment.centerRight,
                      child: ColoredBox(
                        color: Colors.pink,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text('<--'),
                        ),
                      ),
                    ),
                    Marker(
                      point: LatLng(47.18664724067855, -1.5436768515939427),
                      rotate: false,
                      child: ColoredBox(color: Colors.black),
                    ),
                  ],
                ),

                // Camada de marcadores personalizados
                MarkerLayer(
                  markers: customMarkers,
                  rotate: counterRotate,
                  alignment: selectedAlignment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/**

Imports:

Importa os pacotes necessários para o Flutter, Flutter Map, e widgets personalizados.
Classe MarkerPage:

Representa a página que demonstra o uso de marcadores no Flutter Map.
Construtor:

Declara a constante para a rota da página.
Método buildPin:

Método auxiliar para construir um marcador personalizado com base em coordenadas.
Método build:

Constrói a interface da página.
Adiciona uma grade de ícones para selecionar alinhamentos.
Adiciona controles para adicionar marcadores, girar e alinhar.
Lista alignments:

Mapeia valores de rotação para alinhamentos correspondentes.
Lista customMarkers:

Lista de marcadores personalizados com pontos pré-definidos.
Flutter Map:

Cria um mapa interativo com camadas de mapa, marcadores pré-definidos e personalizados.
Configura a interação do mapa para desativar o zoom duplo ao tocar duas vezes.
Adiciona camadas de marcadores com rotação e alinhamento.


 */