import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Página que exibe um mapa deslizante
class SlidingMapPage extends StatelessWidget {
  static const String route = '/sliding_map';
  // Definição das coordenadas da área visível no mapa
  static const northEast = LatLng(56.7378, 11.6644);
  static const southWest = LatLng(56.6877, 11.5089);

  const SlidingMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sliding Map')),
      drawer: const MenuDrawer(route),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'This is a map that can be panned smoothly when the '
              'boundaries are reached.',
            ),
          ),
          Flexible(
            child: FlutterMap(
              options: MapOptions(
                // Configurações iniciais do mapa
                initialCenter: const LatLng(56.704173, 11.543808),
                minZoom: 12,
                maxZoom: 14,
                initialZoom: 13,
                // Restringe o movimento da câmera para manter a área dentro dos limites definidos
                cameraConstraint: CameraConstraint.containCenter(
                  bounds: LatLngBounds(northEast, southWest),
                ),
              ),
              children: [
                // Adiciona uma camada de azulejos usando a imagem localizada no diretório 'assets'
                TileLayer(
                  tileProvider: AssetTileProvider(),
                  maxZoom: 14,
                  // URL do modelo de azulejo
                  urlTemplate: 'assets/map/anholt_osmbright/{z}/{x}/{y}.png',
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

SlidingMapPage: Classe que representa a página do mapa deslizante.
route: Rota usada para navegação.
northEast e southWest: Coordenadas que definem a área visível no mapa.
Scaffold: Estrutura básica da página com AppBar (barra superior), Drawer (menu lateral) e Body (corpo).
Column: Widget que organiza outros widgets em uma coluna vertical.
Descrição informativa: Uma mensagem informativa exibida acima do mapa.
Flexible e FlutterMap: Configurações e renderização do mapa com a capacidade de deslizar suavemente.
MapOptions: Configurações iniciais do mapa, incluindo centro, zoom mínimo/máximo e restrição de câmera.
TileLayer: Camada de azulejos do mapa usando um provedor de ativos.
AssetTileProvider: Provedor de azulejos que carrega imagens de ativos.
urlTemplate: URL do template para os azulejos do mapa.


 */
