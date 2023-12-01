// Importa os pacotes necessários do Flutter
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/pages/scale_layer_plugin_option.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Define um widget chamado PluginScaleBar
class PluginScaleBar extends StatelessWidget {
  // Rota associada a este widget
  static const String route = '/plugin_scalebar';

  // Construtor do widget
  const PluginScaleBar({Key? key});

  // Método responsável por construir o widget
  @override
  Widget build(BuildContext context) {
    // Retorna um Scaffold, uma estrutura básica de tela do Material Design
    return Scaffold(
      // Barra de aplicativo com título
      appBar: AppBar(title: const Text('Scale Bar Plugin')),
      // Drawer (menu lateral) usando o MenuDrawer personalizado
      drawer: const MenuDrawer(PluginScaleBar.route),
      // Corpo da tela com um mapa FlutterMap dentro de um Flexible
      body: Flexible(
        child: FlutterMap(
          // Configurações do mapa
          options: const MapOptions(
            initialCenter: LatLng(51.5, -0.09),  // Centro inicial do mapa
            initialZoom: 5,  // Nível de zoom inicial
          ),
          // Lista de filhos do mapa, incluindo uma camada de azulejos e a barra de escala
          children: [
            openStreetMapTileLayer,  // Camada de azulejos OpenStreetMap
            // Widget ScaleLayerWidget, representando a barra de escala
            ScaleLayerWidget(
              options: ScaleLayerPluginOption(
                lineColor: Colors.black,  // Cor da linha da barra de escala
                lineWidth: 3,  // Largura da linha da barra de escala
                textStyle: const TextStyle(color: Colors.black, fontSize: 14),  // Estilo do texto da barra de escala
                padding: const EdgeInsets.all(10),  // Preenchimento ao redor da barra de escala
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/**


PluginScaleBar: Este é um widget que representa uma página que exibe um mapa com uma barra de escala, utilizando o plugin ScaleLayerPlugin.

route: Uma constante que representa a rota associada a esta página.

Scaffold: Define a estrutura básica da tela, incluindo a barra de aplicativo, o drawer e o corpo da tela.

AppBar: A barra de aplicativo com um título específico.

MenuDrawer: Um drawer personalizado que fornece um menu lateral.

Flexible: Um widget flexível que permite que seu filho (o mapa FlutterMap) expanda para preencher o espaço disponível.

FlutterMap: Um widget que exibe um mapa. Este tem opções iniciais de centro e zoom, além de uma lista de filhos, que inclui uma camada de azulejos OpenStreetMap e a barra de escala.

openStreetMapTileLayer: Uma camada de azulejos OpenStreetMap, que fornece os dados do mapa.

ScaleLayerWidget: Um widget que representa a barra de escala usando o plugin ScaleLayerPlugin. Este é configurado com algumas opções, como cor da linha, largura da linha, estilo do texto e preenchimento.







 */