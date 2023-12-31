import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

// Página que exibe um mapa com opções para carregar azulejos (tiles) com ou sem modo Retina
class RetinaPage extends StatefulWidget {
  static const String route = '/retina';

  static const String _defaultUrlTemplate =
      'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/256/{z}/{x}/{y}{r}?access_token={accessToken}';

  const RetinaPage({Key? key}) : super(key: key);

  @override
  State<RetinaPage> createState() => _RetinaPageState();
}

class _RetinaPageState extends State<RetinaPage> {
  String urlTemplate = RetinaPage._defaultUrlTemplate;
  final urlTemplateInputController = InputFieldColorizer(
    {
      '{r}': const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      '{accessToken}': const TextStyle(fontStyle: FontStyle.italic),
    },
    initialValue: RetinaPage._defaultUrlTemplate,
  );
  String? accessToken;

  bool? retinaMode;

  @override
  Widget build(BuildContext context) {
    // Cria um layer de azulejos (tiles) com base nas opções escolhidas
    final tileLayer = TileLayer(
      urlTemplate: urlTemplate,
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      additionalOptions: {'accessToken': accessToken ?? ''},
      retinaMode: switch (retinaMode) {
        null => RetinaMode.isHighDensity(context),
        _ => retinaMode!,
      },
      tileBuilder: (context, tileWidget, _) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.white),
        ),
        position: DecorationPosition.foreground,
        child: tileWidget,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Retina Tiles')),
      drawer: const MenuDrawer(RetinaPage.route),
      body: Column(
        children: [
          // Configurações da página, como modo Retina, URL do template e token de acesso
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Column(
                  children: [
                    const Text(
                      'Retina Mode',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Checkbox.adaptive(
                          tristate: true,
                          value: retinaMode,
                          onChanged: (v) => setState(() => retinaMode = v),
                        ),
                        Text(switch (retinaMode) {
                          null => '(auto)',
                          true => '(force)',
                          false => '(disabled)',
                        }),
                      ],
                    ),
                    const SizedBox.square(dimension: 4),
                    Builder(
                      builder: (context) {
                        final dpr = MediaQuery.of(context).devicePixelRatio;
                        return RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(
                                text: 'Screen Density: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '@${dpr.toStringAsFixed(2)}x\n'),
                              const TextSpan(
                                text: 'Resulting Method: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: tileLayer.resolvedRetinaMode.friendlyName,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox.square(dimension: 12),
                Expanded(
                  child: Column(
                    children: [
                      // Entrada de texto para a URL do template
                      TextFormField(
                        onChanged: (v) => setState(() => urlTemplate = v),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.link),
                          border: const UnderlineInputBorder(),
                          isDense: true,
                          labelText: 'URL Template',
                          helperText: urlTemplate.contains('{r}')
                              ? "Remove the '{r}' placeholder to simulate retina mode when enabled"
                              : "Add an '{r}' placeholder to request retina tiles when enabled",
                        ),
                        controller: urlTemplateInputController,
                      ),
                      // Entrada de texto para o token de acesso
                      TextFormField(
                        onChanged: (v) => setState(() => accessToken = v),
                        autofocus: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password),
                          border: const UnderlineInputBorder(),
                          isDense: true,
                          labelText: 'Access Token',
                          errorText: accessToken?.isEmpty ?? true
                              ? 'Insert your own access token'
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Mapa exibindo os azulejos
          Expanded(
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(51.5, -0.09),
                initialZoom: 5,
                maxZoom: 19,
              ),
              children: [
                if (accessToken?.isNotEmpty ?? false) tileLayer,
                // Atribuições e links para as fontes dos azulejos
                RichAttributionWidget(
                  attributions: [
                    LogoSourceAttribution(
                      Image.asset(
                        'assets/mapbox-logo-white.png',
                        color: Colors.black,
                      ),
                      height: 16,
                    ),
                    TextSourceAttribution(
                      'Mapbox',
                      onTap: () => launchUrl(
                          Uri.parse('https://www.mapbox.com/about/maps/')),
                    ),
                    TextSourceAttribution(
                      'OpenStreetMap',
                      onTap: () => launchUrl(
                          Uri.parse('https://www.openstreetmap.org/copyright')),
                    ),
                    TextSourceAttribution(
                      'Improve this map',
                      prependCopyright: false,
                      onTap: () => launchUrl(
                          Uri.parse('https://www.mapbox.com/map-feedback')),
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
}

// Um controlador de campo de entrada personalizado que destaca partes específicas do texto
class InputFieldColorizer extends TextEditingController {
  final Map<String, TextStyle> mapping;
  final Pattern pattern;

  InputFieldColorizer(this.mapping, {String? initialValue})
      : pattern =
            RegExp(mapping.keys.map((key) => RegExp.escape(key)).join('|')),
        super(text: initialValue);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<InlineSpan> children = [];

    text.splitMapJoin(
      pattern,
      onMatch: (match) {
        children.add(
          TextSpan(text: match[0], style: style!.merge(mapping[match[0]])),
        );
        return '';
      },
      onNonMatch: (text) {
        children.add(TextSpan(text: text, style: style));
        return '';
      },
    );

    return TextSpan(style: style, children: children);
  }
}
