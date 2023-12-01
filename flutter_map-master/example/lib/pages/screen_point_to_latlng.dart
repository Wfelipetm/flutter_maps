import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Página que demonstra a conversão de ponto de tela para coordenadas LatLng no mapa
class ScreenPointToLatLngPage extends StatefulWidget {
  static const String route = '/screen_point_to_latlng';

  const ScreenPointToLatLngPage({super.key});

  @override
  PointToLatlngPage createState() => PointToLatlngPage();
}

class PointToLatlngPage extends State<ScreenPointToLatLngPage> {
  static const double pointSize = 65;
  static const double pointY = 250;

  // Controlador do mapa
  final mapController = MapController();

  // Coordenadas LatLng resultantes da conversão
  LatLng? latLng;

  @override
  void initState() {
    super.initState();
    // Atualiza as coordenadas após o primeiro quadro ser desenhado
    WidgetsBinding.instance.addPostFrameCallback((_) => updatePoint(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior do aplicativo
      appBar: AppBar(title: const Text('Screen Point 🡒 Lat/Lng')),
      // Menu lateral da aplicação
      drawer: const MenuDrawer(ScreenPointToLatLngPage.route),
      body: Stack(
        children: [
          // Mapa Flutter
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              // Callback chamado quando a posição do mapa muda
              onPositionChanged: (_, __) => updatePoint(context),
              // Centro inicial do mapa
              initialCenter: const LatLng(51.5, -0.09),
              // Zoom inicial do mapa
              initialZoom: 5,
              // Zoom mínimo do mapa
              minZoom: 3,
            ),
            children: [
              openStreetMapTileLayer,
              // Camada de marcador exibindo o ponto convertido
              if (latLng != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: pointSize,
                      height: pointSize,
                      point: latLng!,
                      child: const Icon(
                        Icons.circle,
                        size: 10,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
            ],
          ),
          // Marcador centralizado no ponto convertido
          Positioned(
            top: pointY - pointSize / 2,
            left: _getPointX(context) - pointSize / 2,
            child: const IgnorePointer(
              child: Icon(
                Icons.center_focus_strong_outlined,
                size: pointSize,
                color: Colors.black,
              ),
            ),
          ),
          // Exibição das coordenadas convertidas
          Positioned(
            top: pointY + pointSize / 2 + 6,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Text(
                '(${latLng?.latitude.toStringAsFixed(3)},${latLng?.longitude.toStringAsFixed(3)})',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // Atualiza as coordenadas convertidas com base na posição do ponto central
  void updatePoint(BuildContext context) => setState(() =>
      latLng = mapController.camera.pointToLatLng(Point(_getPointX(context), pointY)));

  // Obtém a coordenada X do ponto central na tela
  double _getPointX(BuildContext context) =>
      MediaQuery.sizeOf(context).width / 2;
}


/**

Este código representa uma página Flutter que demonstra a conversão de um ponto na tela para coordenadas LatLng no mapa. Vamos destacar alguns pontos-chave:

Controlador do Mapa (MapController): É utilizado para interagir e controlar o mapa.

Atualização das Coordenadas: As coordenadas são atualizadas quando a posição do mapa muda, garantindo que o ponto central seja preciso.

Camada de Marcador: Um marcador é exibido na camada de marcadores do mapa para representar o ponto convertido.

Exibição das Coordenadas: As coordenadas convertidas são exibidas abaixo do marcador.

Centralização no Ponto Convertido: Um ícone de mira (marcador) é centralizado no ponto convertido para destacá-lo na tela.

 */