// Importa os pacotes necessários do Flutter
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Define um widget StatefulWidget chamado TileLoadingErrorHandle
class TileLoadingErrorHandle extends StatefulWidget {
  // Rota associada a este widget
  static const String route = '/tile_loading_error_handle';

  // Construtor do widget
  const TileLoadingErrorHandle({Key? key});

  // Cria uma instância do estado associado a este widget
  @override
  TileLoadingErrorHandleState createState() => TileLoadingErrorHandleState();
}

// Define o estado associado ao TileLoadingErrorHandle
class TileLoadingErrorHandleState extends State<TileLoadingErrorHandle> {
  // Duração de exibição do SnackBar
  static const _showSnackBarDuration = Duration(seconds: 1);
  // Variável para simular erros no carregamento de azulejos
  bool _simulateTileLoadErrors = false;
  // Marca a última vez que um erro de carregamento de azulejos foi mostrado
  DateTime? _lastShowedTileLoadError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de aplicativo com título específico
      appBar: AppBar(title: const Text('Tile Loading Error Handle')),
      // Drawer (menu lateral) usando o MenuDrawer personalizado
      drawer: const MenuDrawer(TileLoadingErrorHandle.route),
      // Corpo da tela
      body: Column(
        children: [
          // Caixa de comutação para simular erros no carregamento de azulejos
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: SwitchListTile(
              title: const Text('Simulate tile loading errors'),
              value: _simulateTileLoadErrors,
              onChanged: (newValue) => setState(() {
                _simulateTileLoadErrors = newValue;
              }),
            ),
          ),
          // Mapa FlutterMap
          Flexible(
            child: Builder(builder: (context) {
              return FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(51.5, -0.09),
                  initialZoom: 5,
                ),
                children: [
                  // Camada de azulejos padrão do OpenStreetMap
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    // Estratégia para evict (remover) azulejos com erros
                    evictErrorTileStrategy: EvictErrorTileStrategy.none,
                    // Callback para manipular erros de carregamento de azulejos
                    errorTileCallback: (tile, error, stackTrace) {
                      if (_showErrorSnackBar) {
                        _lastShowedTileLoadError = DateTime.now();
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: _showSnackBarDuration,
                            content: Text(
                              error.toString(),
                              style: const TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.deepOrange,
                          ));
                        });
                      }
                    },
                    // Provedor de azulejos para simular erros ou usar o provedor recomendado
                    tileProvider: _simulateTileLoadErrors
                        ? _SimulateErrorsTileProvider()
                        : CancellableNetworkTileProvider(),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // Método para determinar se deve exibir o SnackBar de erro
  bool get _showErrorSnackBar =>
      _lastShowedTileLoadError == null ||
      DateTime.now().difference(_lastShowedTileLoadError!) -
              const Duration(milliseconds: 50) >
          _showSnackBarDuration;
}

// Classe que representa um provedor de azulejos para simular erros
class _SimulateErrorsTileProvider extends TileProvider {
  _SimulateErrorsTileProvider() : super();

  // Retorna um provedor de imagens para simular erros
  @override
  ImageProvider<Object> getImage(
    TileCoordinates coordinates,
    TileLayer options,
  ) =>
      _SimulateErrorImageProvider();
}

// Classe que representa um provedor de imagens para simular erros
class _SimulateErrorImageProvider
    extends ImageProvider<_SimulateErrorImageProvider> {
  _SimulateErrorImageProvider();

  // Carrega uma imagem simulando um erro
  @override
  ImageStreamCompleter loadImage(
    _SimulateErrorImageProvider key,
    ImageDecoderCallback decode,
  ) =>
      _SimulateErrorImageStreamCompleter();

  // Obtém a chave associada à imagem simulando um erro
  @override
  Future<_SimulateErrorImageProvider> obtainKey(ImageConfiguration _) =>
      Future.error('Simulated tile loading error');
}

// Classe que representa um completer de fluxo de imagens para simular erros
class _SimulateErrorImageStreamCompleter extends ImageStreamCompleter {
  _SimulateErrorImageStreamCompleter() {
    throw Exception('Simulated tile loading error');
  }
}

/**

TileLoadingErrorHandle: Este é um widget StatefulWidget que exibe um mapa com a capacidade de simular erros no carregamento de azulejos e lidar com esses erros.

_simulateTileLoadErrors: Uma variável de estado que determina se os erros no carregamento de azulejos devem ser simulados.

_lastShowedTileLoadError: Mantém o registro do momento em que o último erro de carregamento de azulejos foi exibido.

Scaffold: Define a estrutura básica da tela, incluindo a barra de aplicativo, o drawer e o corpo da tela.

SwitchListTile: Um switch que permite ao usuário simular ou não erros no carregamento de azulejos.

FlutterMap: Um widget que exibe um mapa. Este tem opções iniciais de centro e zoom, além de uma lista de filhos, que inclui uma camada de azulejos.

TileLayer: Uma camada de azulejos configurada com opções específicas, incluindo um callback para lidar com erros de carregamento de azulejos.

_SimulateErrorsTileProvider: Um provedor de azulejos que simula erros no carregamento.

_SimulateErrorImageProvider: Um provedor de imagens que simula erros no carregamento.

_SimulateErrorImageStreamCompleter: Um completer de fluxo de imagens que simula erros no carregamento.



 */