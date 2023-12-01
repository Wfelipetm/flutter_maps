import 'package:flutter/material.dart';
import 'package:flutter_map_example/pages/animated_map_controller.dart';
import 'package:flutter_map_example/pages/bundled_offline_map.dart';
import 'package:flutter_map_example/pages/cancellable_tile_provider.dart';
import 'package:flutter_map_example/pages/circle.dart';
import 'package:flutter_map_example/pages/custom_crs/custom_crs.dart';
import 'package:flutter_map_example/pages/epsg3413_crs.dart';
import 'package:flutter_map_example/pages/epsg4326_crs.dart';
import 'package:flutter_map_example/pages/fallback_url_page.dart';
import 'package:flutter_map_example/pages/home.dart';
import 'package:flutter_map_example/pages/interactive_test_page.dart';
import 'package:flutter_map_example/pages/latlng_to_screen_point.dart';
import 'package:flutter_map_example/pages/many_circles.dart';
import 'package:flutter_map_example/pages/many_markers.dart';
import 'package:flutter_map_example/pages/map_controller.dart';
import 'package:flutter_map_example/pages/map_inside_listview.dart';
import 'package:flutter_map_example/pages/markers.dart';
import 'package:flutter_map_example/pages/moving_markers.dart';
import 'package:flutter_map_example/pages/overlay_image.dart';
import 'package:flutter_map_example/pages/polygon.dart';
import 'package:flutter_map_example/pages/polyline.dart';
import 'package:flutter_map_example/pages/reset_tile_layer.dart';
import 'package:flutter_map_example/pages/retina.dart';
import 'package:flutter_map_example/pages/screen_point_to_latlng.dart';
import 'package:flutter_map_example/pages/secondary_tap.dart';
import 'package:flutter_map_example/pages/sliding_map.dart';
import 'package:flutter_map_example/pages/stateful_markers.dart';
import 'package:flutter_map_example/pages/tile_builder.dart';
import 'package:flutter_map_example/pages/tile_loading_error_handle.dart';
import 'package:flutter_map_example/pages/wms_tile_layer.dart';
import 'package:flutter_map_example/plugins/plugin_scalebar.dart';
import 'package:flutter_map_example/plugins/plugin_zoombuttons.dart';
import 'package:flutter_map_example/widgets/drawer/menu_item.dart';

// Define um widget chamado MenuDrawer que é do tipo StatelessWidget
class MenuDrawer extends StatelessWidget {
  // Atributo que armazena o nome da rota atual
  final String currentRoute;

  // Construtor do widget
  const MenuDrawer(this.currentRoute, {Key? key}) : super(key: key);

  // Método responsável por construir o widget
  @override
  Widget build(BuildContext context) {
    // Retorna um Drawer, um widget que cria um menu lateral no aplicativo
    return Drawer(
      // Define o conteúdo do Drawer como um ListView
      child: ListView(
        // Lista de widgets que representam os itens do menu
        children: <Widget>[
          // Widget para o cabeçalho do Drawer
          DrawerHeader(
            // Contém uma coluna com elementos centrados
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Imagem do cabeçalho
                Image.asset(
                  'assets/ProjectIcon.png',
                  height: 48,
                ),
                const SizedBox(height: 16), // Espaçamento
                // Título do aplicativo
                const Text(
                  'flutter_map Demo',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // Informações adicionais sobre os autores
                const Text(
                  '© flutter_map Authors & Contributors',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          // Item do menu representado por MenuItemWidget
          MenuItemWidget(
            caption: 'Home',
            routeName: HomePage.route,
            currentRoute: currentRoute,
            icon: const Icon(Icons.home),
          ),
           // Outros itens do menu...
          const Divider(),// Linha divisória entre os itens
          MenuItemWidget(
            caption: 'Marker Layer',
            routeName: MarkerPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Polygon Layer',
            routeName: PolygonPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Polyline Layer',
            routeName: PolylinePage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Circle Layer',
            routeName: CirclePage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Overlay Image Layer',
            routeName: OverlayImagePage.route,
            currentRoute: currentRoute,
          ),
          const Divider(),
          MenuItemWidget(
            caption: 'Map Controller',
            routeName: MapControllerPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Animated Map Controller',
            routeName: AnimatedMapControllerPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Interactive Flags',
            routeName: InteractiveFlagsPage.route,
            currentRoute: currentRoute,
          ),
          const Divider(),
          MenuItemWidget(
            caption: 'WMS Sourced Map',
            routeName: WMSLayerPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Bundled Offline Map',
            routeName: BundledOfflineMapPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Fallback URL',
            routeName: FallbackUrlPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Cancellable Tile Provider',
            routeName: CancellableTileProviderPage.route,
            currentRoute: currentRoute,
          ),
          const Divider(),
          MenuItemWidget(
            caption: 'Stateful Markers',
            routeName: StatefulMarkersPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Many Markers',
            routeName: ManyMarkersPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Many Circles',
            routeName: ManyCirclesPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Moving Marker',
            routeName: MovingMarkersPage.route,
            currentRoute: currentRoute,
          ),
          const Divider(),
          MenuItemWidget(
            caption: 'Scale Bar Plugin',
            routeName: PluginScaleBar.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Zoom Buttons Plugin',
            routeName: PluginZoomButtons.route,
            currentRoute: currentRoute,
          ),
          const Divider(),
          MenuItemWidget(
            caption: 'Custom CRS',
            routeName: CustomCrsPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'EPSG4326 CRS',
            currentRoute: currentRoute,
            routeName: EPSG4326Page.route,
          ),
          MenuItemWidget(
            caption: 'EPSG3413 CRS',
            currentRoute: currentRoute,
            routeName: EPSG3413Page.route,
          ),
          const Divider(),
          MenuItemWidget(
            caption: 'Sliding Map',
            routeName: SlidingMapPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Map Inside Scrollable',
            routeName: MapInsideListViewPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Secondary Tap',
            routeName: SecondaryTapPage.route,
            currentRoute: currentRoute,
          ),
          const Divider(),
          MenuItemWidget(
            caption: 'Custom Tile Error Handling',
            routeName: TileLoadingErrorHandle.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Custom Tile Builder',
            routeName: TileBuilderPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Retina Tile Layer',
            routeName: RetinaPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'Reset Tile Layer',
            routeName: ResetTileLayerPage.route,
            currentRoute: currentRoute,
          ),
          const Divider(),
          MenuItemWidget(
            caption: 'Screen Point 🡒 LatLng',
            routeName: ScreenPointToLatLngPage.route,
            currentRoute: currentRoute,
          ),
          MenuItemWidget(
            caption: 'LatLng 🡒 Screen Point',
            routeName: LatLngToScreenPointPage.route,
            currentRoute: currentRoute,
          ),
        ],
      ),
    );
  }
}
/**

Drawer: O widget Drawer cria um menu lateral que pode ser deslizado a partir do canto esquerdo da tela. É comumente usado para navegação em aplicativos.

ListView: O widget ListView cria uma lista vertical de widgets. Aqui, é utilizado para organizar os itens do menu.

DrawerHeader: Este widget adiciona um cabeçalho personalizado ao Drawer. Ele contém uma coluna com uma imagem, o título do aplicativo e informações sobre os autores.

MenuItemWidget: Cada item do menu é representado por este widget. O construtor recebe detalhes sobre o item, como legenda, nome da rota, ícone e se está selecionado ou não.

Divider: O widget Divider cria uma linha divisória visual entre os itens do menu.

O MenuDrawer é uma implementação comum em aplicativos Flutter para fornecer uma navegação organizada e acessível aos usuários por meio de um menu lateral.

 */