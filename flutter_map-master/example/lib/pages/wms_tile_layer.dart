// Importa os pacotes necessários do Flutter
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

// Define um widget chamado WMSLayerPage
class WMSLayerPage extends StatelessWidget {
  // Rota associada a este widget
  static const String route = '/wms_layer';

  // Construtor do widget
  const WMSLayerPage({Key? key});

  // Método responsável por construir o widget
  @override
  Widget build(BuildContext context) {
    // Retorna um Scaffold, uma estrutura básica de tela do Material Design
    return Scaffold(
      // Barra de aplicativo com título
      appBar: AppBar(title: const Text('WMS Layer')),
      // Drawer (menu lateral) usando o MenuDrawer personalizado
      drawer: const MenuDrawer(route),
      // Corpo da tela com um mapa FlutterMap
      body: FlutterMap(
        // Configurações do mapa
        options: const MapOptions(
          initialCenter: LatLng(42.58, 12.43),  // Centro inicial do mapa
          initialZoom: 6,  // Nível de zoom inicial
        ),
        // Lista de filhos do mapa, incluindo uma camada de azulejos WMS e atribuições ricas
        children: [
          // Camada de azulejos WMS (Web Map Service)
          TileLayer(
            // Opções para a camada WMS
            wmsOptions: WMSTileLayerOptions(
              baseUrl: 'https://{s}.s2maps-tiles.eu/wms/?',  // URL base do serviço WMS
              layers: const ['s2cloudless-2021_3857'],  // Camada específica do serviço WMS
            ),
            // Subdomínios para distribuição de carga
            subdomains: const ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'],
            // Nome do pacote do usuário para o agente do usuário
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          // Widget RichAttributionWidget, representando atribuições ricas exibidas no mapa
          RichAttributionWidget(
            // Duração inicial de exibição do popup de atribuição
            popupInitialDisplayDuration: const Duration(seconds: 5),
            // Lista de atribuições, cada uma representada por um TextSourceAttribution
            attributions: [
              // Atribuição de fonte de texto com URL clicável
              TextSourceAttribution(
                'Sentinel-2 cloudless - https://s2maps.eu by EOX IT Services GmbH',
                // Função de retorno de chamada para abrir a URL no navegador
                onTap: () => launchUrl(Uri.parse('https://s2maps.eu')),
              ),
              // Atribuição de fonte de texto simples
              const TextSourceAttribution(
                'Modified Copernicus Sentinel data 2021',
              ),
              // Atribuição de fonte de texto com URL clicável
              TextSourceAttribution(
                'Rendering: EOX::Maps',
                // Função de retorno de chamada para abrir a URL no navegador
                onTap: () => launchUrl(Uri.parse('https://maps.eox.at/')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


/**

WMSLayerPage: Este é um widget que representa uma página que exibe um mapa com uma camada de azulejos WMS (Web Map Service) e atribuições ricas.

route: Uma constante que representa a rota associada a esta página.

Scaffold: Define a estrutura básica da tela, incluindo a barra de aplicativo, o drawer e o corpo da tela.

AppBar: A barra de aplicativo com um título específico.

MenuDrawer: Um drawer personalizado que fornece um menu lateral.

FlutterMap: Um widget que exibe um mapa. Este tem opções iniciais de centro e zoom, além de uma lista de filhos, que inclui uma camada de azulejos WMS e atribuições ricas.

TileLayer: Uma camada de azulejos WMS configurada com opções específicas, como a URL base e a camada específica.

RichAttributionWidget: Um widget que exibe atribuições ricas no mapa, incluindo URLs clicáveis.

TextSourceAttribution: Um tipo de atribuição que inclui texto e uma URL clicável, com uma função de retorno de chamada para abrir a URL no navegador.

 */