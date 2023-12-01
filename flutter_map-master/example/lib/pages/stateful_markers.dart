import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Página que exibe um mapa interativo com marcadores coloridos
class StatefulMarkersPage extends StatefulWidget {
  static const String route = '/stateful_markers';

  const StatefulMarkersPage({super.key});

  @override
  StatefulMarkersPageState createState() => StatefulMarkersPageState();
}

class _ColorMarker extends StatefulWidget {
  @override
  _ColorMarkerState createState() => _ColorMarkerState();
}

class _ColorMarkerState extends State<_ColorMarker> {
  // Mantém a cor do marcador
  late final Color color;

  @override
  void initState() {
    super.initState();
    // Inicializa a cor chamando _ColorGenerator.getColor()
    color = _ColorGenerator.getColor();
  }

  @override
  Widget build(BuildContext context) {
    // Retorna um contêiner colorido com a cor gerada aleatoriamente
    return Container(color: color);
  }
}

// Classe auxiliar para gerar cores aleatórias
class _ColorGenerator {
  // Lista de cores predefinidas
  static List<Color> colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.indigo,
    Colors.amber,
    Colors.black,
    Colors.white,
    Colors.brown,
    Colors.pink,
    Colors.cyan
  ];

  static final Random _random = Random();

  // Retorna uma cor aleatória da lista colorOptions
  static Color getColor() {
    return colorOptions[_random.nextInt(colorOptions.length)];
  }
}

class StatefulMarkersPageState extends State<StatefulMarkersPage> {
  // Lista de marcadores a serem exibidos no mapa
  late List<Marker> _markers;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    // Inicializa a lista de marcadores com 10 marcadores
    _markers = [];
    _addMarker('key1');
    _addMarker('key2');
    _addMarker('key3');
    _addMarker('key4');
    _addMarker('key5');
    _addMarker('key6');
    _addMarker('key7');
    _addMarker('key8');
    _addMarker('key9');
    _addMarker('key10');
  }

  // Adiciona um marcador à lista de marcadores
  void _addMarker(String key) {
    _markers.add(
      Marker(
        width: 40,
        height: 40,
        // Posiciona o marcador em coordenadas geográficas aleatórias
        point: LatLng(
            _random.nextDouble() * 10 + 48, _random.nextDouble() * 10 - 6),
        // Usa o widget _ColorMarker como conteúdo do marcador
        child: _ColorMarker(),
        key: ValueKey(key),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stateful Markers')),
      drawer: const MenuDrawer(StatefulMarkersPage.route),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(51.5, -0.09),
          initialZoom: 5,
        ),
        children: [
          // Adiciona camada de azulejos do OpenStreetMap
          openStreetMapTileLayer,
          // Adiciona uma camada de marcadores usando a lista _markers
          MarkerLayer(markers: _markers),
        ],
      ),
    );
  }
}



/**

Classe StatefulMarkersPage:

Esta é uma página de um aplicativo Flutter, representada por um StatefulWidget.
Ela exibe um mapa interativo usando o pacote flutter_map.
Possui uma lista _markers que armazena instâncias de Marker que serão exibidas no mapa.
Método initState:

É chamado quando o estado da página é inicializado.
Inicializa a lista _markers com 10 marcadores diferentes, cada um representado por uma instância de Marker.
Os marcadores são posicionados aleatoriamente na região de latitude 48 a 58 e longitude -6 a 4.
Método _addMarker(String key):

Adiciona um marcador à lista _markers.
Cada marcador possui uma chave única (ValueKey) e é representado por uma instância de Marker.
Os marcadores têm uma altura e largura de 40 unidades e são posicionados em coordenadas geográficas aleatórias.
Método build:

Constrói a interface do usuário da página.
Utiliza um Scaffold com uma AppBar e um Drawer para fornecer uma estrutura básica.
O corpo (body) contém um FlutterMap com uma camada de azulejos do OpenStreetMap (openStreetMapTileLayer) e uma camada de marcadores (MarkerLayer) que exibe os marcadores na lista _markers.
Classe _ColorMarker:

Um widget StatefulWidget que representa o conteúdo de cada marcador.
Cada _ColorMarker possui um estado _ColorMarkerState, que é inicializado com uma cor aleatória.
Classe _ColorMarkerState:

Armazena a cor do marcador.
No método initState, inicializa a cor chamando _ColorGenerator.getColor().
Classe _ColorGenerator:

Gera cores aleatórias para os marcadores.
Possui uma lista de cores predefinidas (colorOptions).
O método getColor retorna uma cor aleatória da lista.

 */