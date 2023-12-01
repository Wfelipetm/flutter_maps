import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

class TileBuilderPage extends StatefulWidget {
  static const String route = '/tile_builder';

  const TileBuilderPage({Key? key});

  @override
  TileBuilderPageState createState() => TileBuilderPageState();
}

class TileBuilderPageState extends State<TileBuilderPage> {
  // Opções de exibição
  bool enableGrid = true;
  bool showCoordinates = true;
  bool showLoadingTime = true;
  bool darkMode = true;

  // Método para construção de azulejos personalizados
  Widget tileBuilder(BuildContext context, Widget tileWidget, TileImage tile) {
    final coords = tile.coordinates;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: enableGrid ? Border.all(width: 2, color: Colors.white) : null,
      ),
      position: DecorationPosition.foreground,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          tileWidget,
          if (showLoadingTime || showCoordinates)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showCoordinates)
                  Text(
                    '${coords.x} : ${coords.y} : ${coords.z}',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                if (showLoadingTime)
                  Text(
                    tile.loadFinishedAt == null
                        ? 'Loading'
                        : '${(tile.loadFinishedAt!.millisecond - tile.loadStarted!.millisecond).abs()} ms',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  // Construção do widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tile Builder')),
      drawer: const MenuDrawer(TileBuilderPage.route),
      body: Column(
        children: [
          // Barra de opções
          Padding(
            padding: const EdgeInsets.all(12),
            child: FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Tooltip(
                    message: 'Overlay Tile Grid',
                    child: Icon(Icons.grid_4x4),
                  ),
                  Switch.adaptive(
                    value: enableGrid,
                    onChanged: (v) => setState(() => enableGrid = v),
                  ),
                  const SizedBox.square(dimension: 12),
                  const Tooltip(
                    message: 'Show Coordinates',
                    child: Icon(Icons.location_on),
                  ),
                  Switch.adaptive(
                    value: showCoordinates,
                    onChanged: (v) => setState(() => showCoordinates = v),
                  ),
                  const SizedBox.square(dimension: 12),
                  const Tooltip(
                    message: 'Show Tile Loading Duration',
                    child: Icon(Icons.timer_outlined),
                  ),
                  Switch.adaptive(
                    value: showLoadingTime,
                    onChanged: (v) => setState(() => showLoadingTime = v),
                  ),
                  const SizedBox.square(dimension: 12),
                  const Tooltip(
                    message: 'Simulate Dark Mode',
                    child: Icon(Icons.dark_mode),
                  ),
                  Switch.adaptive(
                    value: darkMode,
                    onChanged: (v) => setState(() => darkMode = v),
                  ),
                ],
              ),
            ),
          ),
          // Mapa interativo
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(51.5, -0.09),
                initialZoom: 5,
              ),
              children: [
                // Camada de azulejos personalizada
                _darkModeContainerIfEnabled(
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    tileProvider: CancellableNetworkTileProvider(),
                    tileBuilder: tileBuilder,
                  ),
                ),
                // Camada de marcadores
                const MarkerLayer(
                  markers: [
                    // Um marcador no centro do mapa
                    Marker(
                      width: 80,
                      height: 80,
                      point: LatLng(51.5, -0.09),
                      child: FlutterLogo(
                        key: ObjectKey(Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para envolver o conteúdo em um container de modo escuro, se ativado
  Widget _darkModeContainerIfEnabled(Widget child) {
    if (!darkMode) return child;

    return darkModeTilesContainerBuilder(context, child);
  }
}


/**

Classe TileBuilderPage:

Essa classe é um StatefulWidget que representa a página principal do aplicativo. É associada a uma rota chamada /tile_builder.
Variáveis de Estado (enableGrid, showCoordinates, showLoadingTime, darkMode):

Essas variáveis de estado controlam várias opções de exibição na página, como a sobreposição de uma grade nos azulejos, a exibição de coordenadas, a exibição do tempo de carregamento do azulejo e a simulação do modo escuro.
Método tileBuilder:

Este método é responsável por construir azulejos personalizados. É chamado para cada azulejo na camada do mapa.
Ele cria um DecoratedBox que envolve o azulejo original e adiciona sobreposições com base nas opções de exibição selecionadas (grade, coordenadas, tempo de carregamento).
Método build:

Este método constrói a interface do usuário da página.
Ele inclui uma barra de opções na parte superior, permitindo ao usuário alternar entre as opções de exibição.
A parte principal é um FlutterMap, que é um widget que exibe um mapa interativo.
No FlutterMap, há duas camadas (TileLayer e MarkerLayer). O TileLayer é personalizado usando o método tileBuilder.
Método _darkModeContainerIfEnabled:

Este método envolve o conteúdo em um container com tema escuro se o modo escuro estiver ativado.
Widgets Usados:

Scaffold: Fornece uma estrutura básica para a página.
AppBar: Barra de aplicativos que exibe o título da página.
MenuDrawer: Um drawer que fornece navegação entre diferentes páginas do aplicativo.
Switch: Um interruptor que permite ao usuário ativar/desativar opções.
FittedBox: Ajusta seu filho para caber dentro de suas restrições.
FlutterMap: Widget principal para exibir mapas interativos.
TileLayer: Camada de azulejos que exibe os azulejos do mapa.
MarkerLayer: Camada que exibe marcadores no mapa.
Outros widgets padrão do Flutter como Column, Row, Text, Icon, etc.


 */