import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Página que exibe imagens sobrepostas em um mapa
class OverlayImagePage extends StatelessWidget {
  static const String route = '/overlay_image';

  const OverlayImagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overlay Image')),
      drawer: const MenuDrawer(route),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(51.5, -0.09),
          initialZoom: 6,
        ),
        children: [
          openStreetMapTileLayer, // Adiciona camada de mapa OpenStreetMap
          
          // Adiciona camada de imagens sobrepostas
          OverlayImageLayer(
            overlayImages: [
              // Sobreposição retangular com opacidade e URL da imagem
              OverlayImage(
                bounds: LatLngBounds(
                  const LatLng(51.5, -0.09),
                  const LatLng(48.8566, 2.3522),
                ),
                opacity: 0.8,
                imageProvider: const NetworkImage(
                    'https://images.pexels.com/photos/231009/pexels-photo-231009.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=300&w=600'),
              ),
              
              // Sobreposição rotacionada com coordenadas das esquinas e URL da imagem
              const RotatedOverlayImage(
                topLeftCorner: LatLng(53.377, -2.999),
                bottomLeftCorner: LatLng(52.503, -1.868),
                bottomRightCorner: LatLng(53.475, 0.275),
                opacity: 0.8,
                imageProvider: NetworkImage(
                    'https://images.pexels.com/photos/231009/pexels-photo-231009.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=300&w=600'),
              ),
            ],
          ),
          
          // Adiciona camada de marcadores para indicar esquinas das imagens
          const MarkerLayer(
            markers: [
              Marker(
                point: LatLng(53.377, -2.999),
                child: _Circle(color: Colors.redAccent, label: 'TL'),
              ),
              Marker(
                point: LatLng(52.503, -1.868),
                child: _Circle(color: Colors.redAccent, label: 'BL'),
              ),
              Marker(
                point: LatLng(53.475, 0.275),
                child: _Circle(color: Colors.redAccent, label: 'BR'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Widget de círculo usado como marcador no mapa
class _Circle extends StatelessWidget {
  final String label;
  final Color color;

  const _Circle({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          label,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
/**

Importações:

São feitas importações das bibliotecas necessárias para o Flutter Map e outros componentes.
Classe OverlayImagePage:

Define a classe da página que exibe sobreposições de imagem em um mapa.
Construtor:

Declara uma constante para a rota da página.
Método build:

Constrói a interface da página usando o Flutter Map, que é um mapa interativo.
Utiliza a classe OverlayImageLayer para adicionar imagens sobrepostas ao mapa.
OverlayImage representa uma sobreposição de imagem retangular, enquanto RotatedOverlayImage permite a sobreposição de uma imagem rotacionada.
Adiciona marcadores (MarkerLayer) para indicar as esquinas das imagens sobrepostas.
Classe _Circle:

Uma classe interna que representa um círculo decorado usado como marcador no mapa.
Cada círculo tem uma cor e um rótulo.
Em resumo, o código cria uma página que demonstra como adicionar sobreposições de imagens (retangulares e rotacionadas) a um mapa interativo usando o Flutter Map. Marcadores circulares são adicionados para indicar posições específicas no mapa.


 */