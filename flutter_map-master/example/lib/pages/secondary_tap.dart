import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_example/misc/tile_providers.dart';
import 'package:flutter_map_example/widgets/drawer/menu_drawer.dart';

// Página que demonstra o suporte a eventos de toque secundário (secondary tap) em um mapa
class SecondaryTapPage extends StatelessWidget {
  const SecondaryTapPage({super.key});

  // Rota para navegação
  static const route = '/secondary_tap';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra superior do aplicativo
      appBar: AppBar(title: const Text('Secondary Tap')),
      // Menu lateral da aplicação
      drawer: const MenuDrawer(route),
      body: Column(
        children: [
          // Espaçamento e texto informativo
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('This is a map that supports secondary tap events.'),
          ),
          // Widget flexível que ocupa o espaço disponível
          Flexible(
            child: FlutterMap(
              // Configurações do mapa
              options: MapOptions(
                // Callback chamado quando ocorre um toque secundário (secondary tap)
                onSecondaryTap: (tapPos, latLng) {
                  // Exibe um SnackBar informando a posição do toque secundário
                  ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                    SnackBar(content: Text('Secondary tap at $latLng')),
                  );
                },
                // Centro inicial do mapa
                initialCenter: const LatLng(51.5, -0.09),
                // Zoom inicial do mapa
                initialZoom: 5,
              ),
              // Camadas do mapa
              children: [openStreetMapTileLayer],
            ),
          ),
        ],
      ),
    );
  }
}


/**


Rota de Navegação: A rota /secondary_tap é definida para navegação entre páginas.

AppBar e Drawer: O código inclui uma barra superior (AppBar) e um menu lateral (Drawer) para navegação.

Configurações do Mapa: O mapa é configurado usando FlutterMap e MapOptions. Ele é inicializado com um centro e zoom iniciais.

Evento onSecondaryTap: O mapa tem um callback onSecondaryTap que é acionado quando ocorre um toque secundário. Neste exemplo, ele exibe um SnackBar informando a posição do toque secundário.

Conteúdo Flexível: O conteúdo é colocado dentro de um widget Flexible para ocupar o espaço disponível na tela.

SnackBar: Um SnackBar é usado para mostrar mensagens breves na parte inferior da tela.


 */