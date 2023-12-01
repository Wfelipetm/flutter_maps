// Importa a biblioteca 'dart:math' para usar funções matemáticas, e pacotes do Flutter necessários
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

// Define um widget chamado FlutterMapZoomButtons, que fornece botões de zoom para um mapa FlutterMap
class FlutterMapZoomButtons extends StatelessWidget {
  // Parâmetros opcionais do construtor
  final double minZoom;           // Zoom mínimo permitido
  final double maxZoom;           // Zoom máximo permitido
  final bool mini;                // Define se os botões serão miniaturas
  final double padding;           // Espaçamento ao redor dos botões
  final Alignment alignment;      // Alinhamento dos botões na tela
  final Color? zoomInColor;       // Cor de fundo do botão de zoom in
  final Color? zoomInColorIcon;   // Cor do ícone do botão de zoom in
  final Color? zoomOutColor;      // Cor de fundo do botão de zoom out
  final Color? zoomOutColorIcon;  // Cor do ícone do botão de zoom out
  final IconData zoomInIcon;      // Ícone do botão de zoom in
  final IconData zoomOutIcon;     // Ícone do botão de zoom out

  // Constante para o preenchimento ao ajustar os limites da câmera
  static const _fitBoundsPadding = EdgeInsets.all(12);

  // Construtor que aceita parâmetros opcionais
  const FlutterMapZoomButtons({
    super.key,
    this.minZoom = 1,            // Valor padrão para o zoom mínimo
    this.maxZoom = 18,           // Valor padrão para o zoom máximo
    this.mini = true,            // Valor padrão para miniaturas
    this.padding = 2.0,           // Valor padrão para o espaçamento
    this.alignment = Alignment.topRight,  // Valor padrão para o alinhamento
    this.zoomInColor,            // Cor de fundo do botão de zoom in (pode ser nulo)
    this.zoomInColorIcon,        // Cor do ícone do botão de zoom in (pode ser nulo)
    this.zoomInIcon = Icons.zoom_in,      // Ícone padrão para o botão de zoom in
    this.zoomOutColor,           // Cor de fundo do botão de zoom out (pode ser nulo)
    this.zoomOutColorIcon,       // Cor do ícone do botão de zoom out (pode ser nulo)
    this.zoomOutIcon = Icons.zoom_out,    // Ícone padrão para o botão de zoom out
  });

  // Método build, obrigatório em qualquer widget Flutter, onde você descreve como o widget deve ser renderizado
  @override
  Widget build(BuildContext context) {
    // Obtém o controlador e a câmera do mapa a partir do contexto
    final controller = MapController.of(context);
    final camera = MapCamera.of(context);
    // Obtém o tema atual do contexto
    final theme = Theme.of(context);

    // Retorna um widget Align, que alinha seu filho de acordo com as coordenadas fornecidas
    return Align(
      // Define a coordenada de alinhamento
      alignment: alignment,
      // Child do Align é uma coluna que contém os botões de zoom
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Botão de zoom in
          Padding(
            padding: EdgeInsets.only(left: padding, top: padding, right: padding),
            child: FloatingActionButton(
              heroTag: 'zoomInButton',                   // Identificador único para o botão
              mini: mini,                                // Define se é um botão miniatura
              backgroundColor: zoomInColor ?? theme.primaryColor, // Cor de fundo do botão de zoom in
              onPressed: () {
                // Obtém os limites visíveis da câmera com um preenchimento e ajusta a câmera
                final paddedMapCamera = CameraFit.bounds(
                  bounds: camera.visibleBounds,
                  padding: _fitBoundsPadding,
                ).fit(camera);
                // Calcula o próximo nível de zoom e move o controlador para essa posição
                final zoom = min(paddedMapCamera.zoom + 1, maxZoom);
                controller.move(paddedMapCamera.center, zoom);
              },
              // Ícone do botão de zoom in
              child: Icon(zoomInIcon, color: zoomInColorIcon ?? theme.iconTheme.color),
            ),
          ),
          // Botão de zoom out
          Padding(
            padding: EdgeInsets.all(padding),
            child: FloatingActionButton(
              heroTag: 'zoomOutButton',                  // Identificador único para o botão
              mini: mini,                                // Define se é um botão miniatura
              backgroundColor: zoomOutColor ?? theme.primaryColor, // Cor de fundo do botão de zoom out
              onPressed: () {
                // Obtém os limites visíveis da câmera com um preenchimento e ajusta a câmera
                final paddedMapCamera = CameraFit.bounds(
                  bounds: camera.visibleBounds,
                  padding: _fitBoundsPadding,
                ).fit(camera);
                // Calcula o próximo nível de zoom e move o controlador para essa posição
                var zoom = paddedMapCamera.zoom - 1;
                if (zoom < minZoom) {
                  zoom = minZoom;
                }
                controller.move(paddedMapCamera.center, zoom);
              },
              // Ícone do botão de zoom out
              child: Icon(zoomOutIcon, color: zoomOutColorIcon ?? theme.iconTheme.color),
            ),
          ),
        ],
      ),
    );
  }
}

/**

FlutterMapZoomButtons: Este é um widget que fornece botões de zoom para um mapa FlutterMap.

minZoom, maxZoom: Parâmetros opcionais que definem os limites de zoom permitidos.

mini: Parâmetro opcional que define se os botões serão miniaturas.

padding: Parâmetro opcional que especifica o espaçamento ao redor dos botões.

alignment: Parâmetro opcional que define o alinhamento dos botões na tela.

zoomInColor, zoomInColorIcon, zoomOutColor, zoomOutColorIcon: Parâmetros opcionais que especificam as cores de fundo e de ícone para os botões de zoom in e zoom out.

zoomInIcon, zoomOutIcon: Parâmetros opcionais que definem os ícones para os botões de zoom in e zoom out.

_fitBoundsPadding: Uma constante que representa o preenchimento ao ajustar os limites da câmera.

build: O método obrigatório que descreve como o widget deve ser renderizado. Ele cria dois botões de zoom, um para aumentar e outro para diminuir o zoom do mapa.

onPressed: A ação executada quando os botões são pressionados, ajustando a câmera e movendo o controlador para a nova posição.

 */
