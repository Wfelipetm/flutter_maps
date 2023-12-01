import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Número máximo de círculos a serem gerados
const maxCirclesCount = 20000;

/// Nesta página, [maxCirclesCount] círculos são gerados aleatoriamente
/// pela Europa, e você pode limitá-los com um controle deslizante
///
/// Dessa forma, você pode testar o desempenho do mapa com muitos círculos
class ManyCirclesPage extends StatefulWidget {
  static const String route = '/many_circles';

  const ManyCirclesPage({super.key});

  @override
  ManyCirclesPageState createState() => ManyCirclesPageState();
}

class ManyCirclesPageState extends State<ManyCirclesPage> {
  // Função para gerar um número aleatório dentro de um intervalo
  double doubleInRange(Random source, num start, num end) =>
      source.nextDouble() * (end - start) + start;

  // Lista de todos os círculos gerados
  List<CircleMarker> allCircles = [];

  // Valor inicial do controle deslizante
  int _sliderVal = maxCirclesCount ~/ 10;

  @override
  void initState() {
    super.initState();
    // Microtarefa para gerar os círculos após o primeiro frame ser desenhado
    Future.microtask(() {
      final r = Random();
      // Loop para gerar os círculos
      for (var x = 0; x < maxCirclesCount; x++) {
        allCircles.add(
          CircleMarker(
            point: LatLng(
              doubleInRange(r, 37, 55),
              doubleInRange(r, -9, 30),
            ),
            color: Colors.red,
            radius: 5,
          ),
        );
      }
      // Atualiza o estado para reconstruir a interface
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('A lot of circles')),
      drawer: const MenuDrawer(ManyCirclesPage.route),
      body: Column(
        children: [
          // Controle deslizante para limitar a quantidade de círculos exibidos
          Slider(
            min: 0,
            max: maxCirclesCount.toDouble(),
            divisions: maxCirclesCount ~/ 500,
            label: 'Circles',
            value: _sliderVal.toDouble(),
            onChanged: (newVal) {
              // Atualiza o valor do controle deslizante e reconstrói a interface
              _sliderVal = newVal.toInt();
              setState(() {});
            },
          ),
          // Exibe o número de círculos atualmente exibidos
          Text('$_sliderVal circles'),
          Flexible(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(50, 20),
                initialZoom: 5,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.all - InteractiveFlag.rotate,
                ),
              ),
              children: [
                openStreetMapTileLayer,
                // Camada de círculos, limitada pelo valor do controle deslizante
                CircleLayer(
                    circles: allCircles.sublist(
                        0, min(allCircles.length, _sliderVal))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
