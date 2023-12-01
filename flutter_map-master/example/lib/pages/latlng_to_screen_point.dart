import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Página que converte coordenadas LatLng para pontos na tela
class LatLngToScreenPointPage extends StatefulWidget {
  static const String route = '/latlng_to_screen_point';

  const LatLngToScreenPointPage({super.key});

  @override
  State<LatLngToScreenPointPage> createState() =>
      _LatLngToScreenPointPageState();
}

class _LatLngToScreenPointPageState extends State<LatLngToScreenPointPage> {
  static const double pointSize = 65;

  // Controlador do mapa
  final mapController = MapController();

  // Coordenadas da última posição tocada/clique
  LatLng? tappedCoords;

  // Ponto correspondente na tela da última posição tocada/clique
  Point<double>? tappedPoint;

  @override
  void initState() {
    super.initState();

    // Exibe um SnackBar após o primeiro frame ser desenhado
    SchedulerBinding.instance.addPostFrameCallback((_) =>
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tap/click to set coordinate')),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lat/Lng 🡒 Screen Point')),
      drawer: const MenuDrawer(LatLngToScreenPointPage.route),
      body: Stack(
        children: [
          // FlutterMap com opções específicas
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: const LatLng(51.5, -0.09),
              initialZoom: 11,
              interactionOptions: const InteractionOptions(
                flags: ~InteractiveFlag.doubleTapZoom,
              ),
              // Captura o toque/clique no mapa
              onTap: (_, latLng) {
                // Converte as coordenadas LatLng para ponto na tela
                final point =
                    mapController.camera.latLngToScreenPoint(tappedCoords = latLng);
                setState(() => tappedPoint = Point(point.x, point.y));
              },
            ),
            children: [
              openStreetMapTileLayer,
              // Exibe um marcador na última posição tocada/clique
              if (tappedCoords != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      width: pointSize,
                      height: pointSize,
                      point: tappedCoords!,
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
          // Exibe um ícone na tela na última posição tocada/clique
          if (tappedPoint != null)
            Positioned(
              left: tappedPoint!.x - 60 / 2,
              top: tappedPoint!.y - 60 / 2,
              child: const IgnorePointer(
                child: Icon(
                  Icons.center_focus_strong_outlined,
                  color: Colors.black,
                  size: 60,
                ),
              ),
            )
        ],
      ),
    );
  }
}
/**

Classe LatLngToScreenPointPage:

Representa a página que converte coordenadas LatLng para pontos na tela.
Construtor:

Declara a constante para a rota da página.
Método initState:

Inicializa o SnackBar para ser exibido após o primeiro frame ser desenhado.
Método build:

Constrói a interface da página.
Utiliza o Flutter Map para exibir um mapa interativo.
FlutterMap:

Utiliza o Flutter Map com opções específicas, incluindo a interação e um evento para capturar toques/cliques no mapa.
Evento onTap:

Converte as coordenadas LatLng para um ponto na tela.
Atualiza o estado para exibir um marcador na última posição tocada/clique.
Marcador (MarkerLayer):

Exibe um marcador na última posição tocada/clique.
Ícone (Icon):

Exibe um ícone na tela na última posição tocada/clique.
Posiciona o ícone com base nas coordenadas convertidas.
Conversão de Coordenadas (latLngToScreenPoint):

Utiliza o método latLngToScreenPoint do controlador do mapa para converter coordenadas LatLng para um ponto na tela.








 */