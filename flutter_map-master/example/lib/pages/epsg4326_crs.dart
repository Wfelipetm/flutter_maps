import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

class EPSG4326Page extends StatelessWidget {
  static const String route = '/crs_epsg4326';

  const EPSG4326Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EPSG4326')),
      drawer: const MenuDrawer(route),
      body: FlutterMap(
        options: const MapOptions(
          minZoom: 0,
          crs: Epsg4326(), // Define o CRS (Sistema de Referência de Coordenadas) como EPSG:4326
          initialCenter: LatLng(0, 0),
          initialZoom: 0,
        ),
        children: [
          TileLayer(
            wmsOptions: WMSTileLayerOptions(
              crs: const Epsg4326(), // Especifica o CRS para a camada WMS (Serviço de Mapa da Web)
              baseUrl: 'https://ows.mundialis.de/services/service?',
              layers: const ['TOPO-OSM-WMS'],
            ),
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
        ],
      ),
    );
  }
}


/**

Este código Flutter representa uma página em seu aplicativo que utiliza o pacote Flutter Map para exibir um mapa com um Sistema de Referência de Coordenadas (CRS) específico definido como EPSG:4326. Aqui está uma breve visão geral das partes importantes:

Epsg4326(): O CRS (Sistema de Referência de Coordenadas) é definido como EPSG:4326, comumente usado para coordenadas geográficas.

TileLayer: Esta é uma camada de azulejos no mapa, e ela utiliza uma camada WMS (Serviço de Mapa da Web) com opções especificadas, incluindo o CRS.

baseUrl: O URL base para a camada WMS.

layers: As camadas a serem exibidas do WMS.

userAgentPackageName: Um nome de pacote de agente do usuário para a camada de azulejos.

Essa página essencialmente exibe um mapa com um CRS específico e uma camada WMS sobre ele, fornecendo informações geográficas ao usuário.



 */
