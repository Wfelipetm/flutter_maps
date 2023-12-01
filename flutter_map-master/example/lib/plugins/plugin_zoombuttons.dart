// Importa os pacotes necessários do Flutter
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/plugins/zoombuttons_plugin_option.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Define um widget chamado PluginZoomButtons
class PluginZoomButtons extends StatelessWidget {
  // Rota associada a este widget
  static const String route = '/plugin_zoombuttons';

  // Construtor do widget
  const PluginZoomButtons({Key? key});

  // Método responsável por construir o widget
  @override
  Widget build(BuildContext context) {
    // Retorna um Scaffold, uma estrutura básica de tela do Material Design
    return Scaffold(
      // Barra de aplicativo com título
      appBar: AppBar(title: const Text('Zoom Buttons Plugin')),
      // Drawer (menu lateral) usando o MenuDrawer personalizado
      drawer: const MenuDrawer(PluginZoomButtons.route),
      // Corpo da tela com um mapa FlutterMap
      body: FlutterMap(
        // Configurações do mapa
        options: const MapOptions(
          initialCenter: LatLng(51.5, -0.09),  // Centro inicial do mapa
          initialZoom: 5,  // Nível de zoom inicial
        ),
        // Lista de filhos do mapa, incluindo uma camada de azulejos e os botões de zoom
        children: [
          openStreetMapTileLayer,  // Camada de azulejos OpenStreetMap
          // Widget FlutterMapZoomButtons, fornecendo botões de zoom
          const FlutterMapZoomButtons(
            minZoom: 4,           // Nível mínimo de zoom permitido
            maxZoom: 19,          // Nível máximo de zoom permitido
            mini: true,           // Botões de zoom como miniaturas
            padding: 10,          // Preenchimento ao redor dos botões
            alignment: Alignment.bottomRight,  // Alinhamento dos botões
          ),
        ],
      ),
    );
  }
}


/**

PluginZoomButtons: Este é um widget que representa uma página que exibe um mapa com a capacidade de usar botões de zoom, utilizando o plugin FlutterMapZoomButtons.

route: Uma constante que representa a rota associada a esta página.

Scaffold: Define a estrutura básica da tela, incluindo a barra de aplicativo, o drawer e o corpo da tela.

AppBar: A barra de aplicativo com um título específico.

MenuDrawer: Um drawer personalizado que fornece um menu lateral.

FlutterMap: Um widget que exibe um mapa. Este tem opções iniciais de centro e zoom, além de uma lista de filhos, que inclui uma camada de azulejos OpenStreetMap e os botões de zoom.

openStreetMapTileLayer: Uma camada de azulejos OpenStreetMap, que fornece os dados do mapa.

FlutterMapZoomButtons: Um widget que representa os botões de zoom, usando o plugin FlutterMapZoomButtons. Este é configurado com algumas opções, como níveis mínimo e máximo de zoom, botões em miniatura, preenchimento e alinhamento.

Esse código em particular cria uma página que exibe um mapa com a funcionalidade adicional de botões de zoom, proporcionando uma interação fácil e intuitiva com o mapa.


 */