import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Página que demonstra como redefinir programaticamente os TileLayers, descartando tiles em cache
class ResetTileLayerPage extends StatefulWidget {
  static const String route = '/reset_tilelayer';

  const ResetTileLayerPage({Key? key}) : super(key: key);

  @override
  ResetTileLayerPageState createState() => ResetTileLayerPageState();
}

class ResetTileLayerPageState extends State<ResetTileLayerPage> {
  // Um controlador de stream para notificar os TileLayers sobre a necessidade de redefinição
  final StreamController<void> resetController = StreamController.broadcast();

  // URLs de dois TileLayers diferentes
  static const layer1 = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const layer2 = 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png';

  // Toggle para alternar entre os dois TileLayers
  bool layerToggle = true;

  // Método para redefinir os TileLayers
  void _resetTiles() {
    // Inverte o valor do toggle para alternar entre os dois TileLayers
    setState(() {
      layerToggle = !layerToggle;
    });
    
    // Adiciona um evento à stream para notificar os TileLayers sobre a redefinição
    resetController.add(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TileLayer Reset')),
      drawer: const MenuDrawer(ResetTileLayerPage.route),
      body: Column(
        children: [
          // Descrição da funcionalidade da página
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 12),
            child: Text(
              'TileLayers can be programmatically reset, disposing of cached '
              'tiles',
            ),
          ),
          
          // Botão para acionar a redefinição dos TileLayers
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: TextButton.icon(
              onPressed: _resetTiles,
              label: const Text('Reset'),
              icon: const Icon(Icons.restart_alt),
            ),
          ),
          
          // Mapa exibindo TileLayers e um marcador
          Flexible(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(51.5, -0.09),
                initialZoom: 5,
              ),
              children: [
                // TileLayer que pode ser redefinido programaticamente
                TileLayer(
                  reset: resetController.stream,
                  urlTemplate: layerToggle ? layer1 : layer2,
                  subdomains: layerToggle ? const [] : const ['a', 'b', 'c'],
                  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                  tileProvider: CancellableNetworkTileProvider(),
                ),
                
                // Camada de marcador com um único marcador
                const MarkerLayer(
                  markers: [
                    Marker(
                      width: 80,
                      height: 80,
                      point: LatLng(51.5, -0.09),
                      child: FlutterLogo(),
                    ),
                  ],
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


ResetTileLayerPage e ResetTileLayerPageState: Esta é uma página Flutter que demonstra como redefinir programaticamente os TileLayers em um mapa Flutter. Ele estende StatefulWidget e State.

StreamController<void> resetController: Um controlador de stream que será usado para notificar os TileLayers sobre a necessidade de redefinição.

layer1 e layer2: URLs de dois TileLayers diferentes, usados para alternar entre eles.

layerToggle: Um bool usado para alternar entre os dois TileLayers.

_resetTiles(): Um método que inverte o valor de layerToggle e adiciona um evento à stream resetController, notificando os TileLayers sobre a necessidade de redefinição.

build(BuildContext context): O método responsável por construir a interface da página.

Descrição e Botão Reset: Um texto explicativo sobre a funcionalidade da página e um botão que, quando pressionado, aciona a redefinição dos TileLayers.

FlutterMap: Um widget que representa um mapa Flutter. Ele contém dois filhos: um TileLayer e uma MarkerLayer.

TileLayer: Um widget que representa uma camada de azulejos (tiles) no mapa. Ele é configurado para escutar a stream resetController para redefinir seus tiles quando notificado.

MarkerLayer: Uma camada que exibe marcadores no mapa. Neste caso, há um único marcador com o logotipo do Flutter.



 */