import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Página que exibe marcadores móveis em um mapa
class MovingMarkersPage extends StatefulWidget {
  static const String route = '/moving_markers';

  const MovingMarkersPage({super.key});

  @override
  MovingMarkersPageState createState() => MovingMarkersPageState();
}

class MovingMarkersPageState extends State<MovingMarkersPage> {
  Marker? _marker; // Marcador atualmente exibido no mapa
  late final Timer _timer; // Temporizador para atualização do marcador
  int _markerIndex = 0; // Índice do marcador na lista

  // Lista de marcadores fixos com coordenadas e widgets associados
  static const _markers = [
    Marker(
      width: 80,
      height: 80,
      point: LatLng(51.5, -0.09),
      child: FlutterLogo(),
    ),
    Marker(
      width: 80,
      height: 80,
      point: LatLng(53.3498, -6.2603),
      child: FlutterLogo(),
    ),
    Marker(
      width: 80,
      height: 80,
      point: LatLng(48.8566, 2.3522),
      child: FlutterLogo(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _marker = _markers[_markerIndex]; // Inicializa o marcador atual
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _marker = _markers[_markerIndex]; // Atualiza o marcador
        _markerIndex = (_markerIndex + 1) % _markers.length; // Avança para o próximo marcador
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel(); // Cancela o temporizador ao sair da página
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Moving Markers')),
      drawer: const MenuDrawer(MovingMarkersPage.route),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(51.5, -0.09),
          initialZoom: 5,
        ),
        children: [
          openStreetMapTileLayer, // Adiciona camada de mapa OpenStreetMap
          
          // Adiciona camada de marcadores, exibindo apenas o marcador atual
          MarkerLayer(markers: [_marker!]),
        ],
      ),
    );
  }
}

/**

Imports:

Importa os pacotes necessários para o Flutter, Flutter Map, e widgets personalizados.
Classe MovingMarkersPage:

Representa a página que exibe marcadores móveis em um mapa.
Construtor:

Declara a constante para a rota da página.
Método initState:

Inicializa o estado da página, configurando o marcador inicial e o temporizador para alternar entre marcadores.
Método dispose:

Descarta recursos ao sair da página, cancelando o temporizador.
Método build:

Constrói a interface da página usando o Flutter Map.
Adiciona camadas de mapa e marcadores, exibindo apenas o marcador atual.
Temporizador (Timer):

Atualiza o marcador a cada segundo, alternando entre os marcadores da lista _markers.
O código ilustra como criar uma página com marcadores móveis em um mapa, utilizando um temporizador para alternar entre diferentes marcadores pré-definidos.



 */
