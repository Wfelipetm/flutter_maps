import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/floating_menu_button.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';
import 'package:flutter_map_example/widgets/first_start_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Página inicial da aplicação
class HomePage extends StatefulWidget {
  static const String route = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Executado quando o estado é inicializado
  @override
  void initState() {
    super.initState();
    // Exibe o diálogo introdutório se necessário
    showIntroDialogIfNeeded();
  }

  // Constrói a interface da página
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(HomePage.route),
      body: Stack(
        children: [
          // Mapa FlutterMap
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(-22.852701, -43.779682),
              initialZoom: 15,
              cameraConstraint: CameraConstraint.contain(
                bounds: LatLngBounds(
                  const LatLng(-90, -180),
                  const LatLng(90, 180),
                ),
              ),
            ),
            children: [
              // Camada de azulejos OpenStreetMap
              openStreetMapTileLayer,
              // Widget de atribuição rica
              RichAttributionWidget(
                popupInitialDisplayDuration: const Duration(seconds: 5),
                animationConfig: const ScaleRAWA(),
                showFlutterMapAttribution: false,
                attributions: [
                  // Atribuição de fonte de texto
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright'),
                    ),
                  ),
                  // Atribuição de texto
                  const TextSourceAttribution(
                    'This attribution is the same throughout this app, except '
                    'where otherwise specified',
                    prependCopyright: false,
                  ),
                ],
              ),
            ],
          ),
          // Botão flutuante do menu
          const FloatingMenuButton()
        ],
      ),
    );
  }

  // Exibe o diálogo introdutório se ainda não foi visto
  void showIntroDialogIfNeeded() {
    // Chave de preferência compartilhada para rastrear se o diálogo introdutório foi visto
    const seenIntroBoxKey = 'seenIntroBox(a)';
    // Verifica se a aplicação está sendo executada na web e no domínio específico
    if (kIsWeb && Uri.base.host.trim() == 'demo.fleaflet.dev') {
      // Adiciona uma chamada de retorno após o quadro ser concluído
      SchedulerBinding.instance?.addPostFrameCallback(
        (_) async {
          // Obtém as preferências compartilhadas
          final prefs = await SharedPreferences.getInstance();
          // Verifica se o diálogo já foi visto
          if (prefs.getBool(seenIntroBoxKey) ?? false) return;

          // Verifica se o widget ainda está montado antes de exibir o diálogo
          if (!mounted) return;

          // Exibe o diálogo de início
          await showDialog<void>(
            context: context,
            builder: (context) => const FirstStartDialog(),
          );
          // Marca que o diálogo foi visto nas preferências compartilhadas
          await prefs.setBool(seenIntroBoxKey, true);
        },
      );
    }
  }
}
