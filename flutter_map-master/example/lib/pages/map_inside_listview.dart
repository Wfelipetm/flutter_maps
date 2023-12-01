import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/plugins/zoombuttons_plugin_option.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Página que demonstra um mapa dentro de um ListView
class MapInsideListViewPage extends StatelessWidget {
  static const String route = '/map_inside_listview';

  const MapInsideListViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map inside ListView')),
      drawer: const MenuDrawer(MapInsideListViewPage.route),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            // Widget para exibir o mapa dentro de um contêiner com altura específica
            SizedBox(
              height: 300,
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(51.5, -0.09),
                  initialZoom: 5,
                ),
                children: [
                  openStreetMapTileLayer, // Adiciona camada de mapa OpenStreetMap
                  const FlutterMapZoomButtons(
                    minZoom: 4,
                    maxZoom: 19,
                    mini: true,
                    padding: 10,
                    alignment: Alignment.bottomLeft,
                  ),
                ],
              ),
            ),

            // Card informativo
            const Card(
              child: ListTile(
                  title: Text(
                      'Scrolling inside the map does not scroll the ListView')),
            ),

            const SizedBox(height: 500), // Espaço vazio para rolar a ListView

            // Outro card informativo
            const Card(child: ListTile(title: Text('look at that scrolling')))
          ],
        ),
      ),
    );
  }
}

/**

Imports:

Importa os pacotes necessários para o Flutter, Flutter Map, e widgets personalizados.
Classe MapInsideListViewPage:

Representa a página que demonstra um mapa dentro de um ListView.
Construtor:

Declara a constante para a rota da página.
Método build:

Constrói a interface da página.
Utiliza um ListView para organizar vários elementos verticalmente.
Flutter Map dentro de SizedBox:

Incorpora um mapa Flutter Map dentro de um contêiner com altura fixa de 300 pixels.
Configura opções do mapa, incluindo centro inicial e zoom.
Adiciona uma camada de mapa OpenStreetMap.
Adiciona botões de zoom personalizados ao canto inferior esquerdo.
Card informativo:

Adiciona um Card com um ListTile informando que rolar dentro do mapa não rolará o ListView.
SizedBox com altura de 500 pixels:

Adiciona um espaço vazio para permitir rolar o restante do ListView.
Outro card informativo:

Adiciona outro Card com um ListTile informativo.


 */