import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Página que exibe polilinhas em um mapa
class PolylinePage extends StatefulWidget {
  static const String route = '/polyline';

  const PolylinePage({Key? key}) : super(key: key);

  @override
  State<PolylinePage> createState() => _PolylinePageState();
}

class _PolylinePageState extends State<PolylinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior da página
      appBar: AppBar(title: const Text('Polylines')),
      // Menu lateral da página
      drawer: const MenuDrawer(PolylinePage.route),
      // Corpo da página
      body: FlutterMap(
        // Configurações do mapa
        options: const MapOptions(
          initialCenter: LatLng(51.5, -0.09), // Centro inicial do mapa
          initialZoom: 5, // Nível de zoom inicial
        ),
        children: [
          openStreetMapTileLayer, // Adiciona a camada de tiles do OpenStreetMap
          PolylineLayer(
            polylines: [
              // Define uma polilinha roxa com três pontos
              Polyline(
                points: [
                  const LatLng(51.5, -0.09),
                  const LatLng(53.3498, -6.2603),
                  const LatLng(48.8566, 2.3522),
                ],
                strokeWidth: 4,          // Largura da linha
                color: Colors.purple,    // Cor da linha
              ),
              // Define uma polilinha com um gradiente de cores
              Polyline(
                points: [
                  const LatLng(55.5, -0.09),
                  const LatLng(54.3498, -6.2603),
                  const LatLng(52.8566, 2.3522),
                ],
                strokeWidth: 4,
                gradientColors: [
                  const Color(0xffE40203),
                  const Color(0xffFEED00),
                  const Color(0xff007E2D),
                ],
              ),
              // Define uma polilinha azul com borda vermelha
              Polyline(
                points: [
                  const LatLng(50.5, -0.09),
                  const LatLng(51.3498, 6.2603),
                  const LatLng(53.8566, 2.3522),
                ],
                strokeWidth: 20,
                color: Colors.blue.withOpacity(0.6),
                borderStrokeWidth: 20,      // Largura da borda
                borderColor: Colors.red.withOpacity(0.4), // Cor da borda
              ),
              Polyline(
                points: [
                  const LatLng(50.2, -0.08),
                  const LatLng(51.2498, -10.2603),
                  const LatLng(54.8566, -9.3522),
                ],
                strokeWidth: 20,
                color: Colors.black.withOpacity(0.2),
                borderStrokeWidth: 20,
                borderColor: Colors.white30,
              ),
              Polyline(
                points: [
                  const LatLng(49.1, -0.06),
                  const LatLng(52.15, -1.4),
                  const LatLng(55.5, 0.8),
                ],
                strokeWidth: 10,
                color: Colors.yellow,
                borderStrokeWidth: 10,
                borderColor: Colors.blue.withOpacity(0.5),
              ),
              Polyline(
                points: [
                  const LatLng(48.1, -0.03),
                  const LatLng(50.5, -7.8),
                  const LatLng(56.5, 0.4),
                ],
                strokeWidth: 10,
                color: Colors.amber,
                borderStrokeWidth: 10,
                borderColor: Colors.blue.withOpacity(0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



/**

Importações:

Importa bibliotecas necessárias para o Flutter e o Flutter Map.
Classe PolylinePage:

Define a página que exibirá polilinhas no mapa.
Classe _PolylinePageState:

Estado da página de polilinhas.
build(): Constrói a interface da página com um mapa e polilinhas.
Polilinhas:

São linhas poligonais no mapa.
São definidas por uma lista de pontos.
Variados estilos, cores e larguras podem ser aplicados.



 */