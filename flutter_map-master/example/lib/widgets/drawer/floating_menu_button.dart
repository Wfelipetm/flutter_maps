// Importa o pacote Flutter Material, que fornece widgets para construir interfaces de usuário bonitas
import 'package:flutter/material.dart';

// Define um widget chamado FloatingMenuButton, que é do tipo StatelessWidget
class FloatingMenuButton extends StatelessWidget {
  // Construtor do widget, que aceita uma chave opcional para identificação
  const FloatingMenuButton({Key? key});

  // Método build, obrigatório em qualquer widget Flutter, onde você descreve como o widget deve ser renderizado
  @override
  Widget build(BuildContext context) {
    // Retorna um widget PositionedDirectional, que posiciona seu filho de acordo com a direção de leitura da linguagem
    return PositionedDirectional(
      // Define a posição do início (esquerda em inglês) do widget em relação à borda da tela
      start: 16,
      // Define a posição superior do widget em relação à borda da tela
      top: 16,
      // Child do PositionedDirectional é um SafeArea, garantindo que o conteúdo não seja cortado por barras como a barra de status
      child: SafeArea(
        // Child do SafeArea é um Container, um widget que agrupa outros widgets
        child: Container(
          // BoxDecoration define a aparência visual do Container, neste caso, a cor de fundo e a borda circular
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(999),
          ),
          // Padding adiciona espaçamento interno ao Container
          padding: const EdgeInsets.all(8),
          // Child do Container é um Row, que organiza widgets em uma linha horizontal
          child: Row(
            // Lista de widgets filhos dentro do Row
            children: [
              // Um IconButton, um botão que exibe um ícone, neste caso, o ícone de menu
              IconButton(
                // onPressed define a ação quando o botão é pressionado, abre o drawer (menu lateral)
                onPressed: () => Scaffold.of(context).openDrawer(),
                // Icon exibe o ícone de menu
                icon: const Icon(Icons.menu),
              ),
              // SizedBox é um widget de caixa que adiciona espaçamento horizontal entre widgets
              const SizedBox(width: 8),
              // Image.asset exibe uma imagem do projeto usando um caminho relativo e define altura e largura
              Image.asset('assets/ProjectIcon.png', height: 32, width: 32),
              // SizedBox adiciona mais espaçamento horizontal
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}


/**

FloatingMenuButton: Este é um widget chamado FloatingMenuButton, que é um botão flutuante que contém um ícone de menu e uma imagem do projeto.

PositionedDirectional: Este widget posiciona seu filho em relação à direção de leitura da linguagem. Neste caso, o botão é posicionado a 16 unidades do início (esquerda) e 16 unidades do topo.

SafeArea: Garante que o conteúdo do botão não será cortado por elementos como a barra de status.

Container: Um recipiente que agrupa os elementos do botão. Define a cor de fundo e a borda circular.

BoxDecoration: Define a aparência visual do contêiner.

padding: Adiciona espaçamento interno ao contêiner.

Row: Um widget de linha que organiza seus filhos em uma linha horizontal.

IconButton: Um botão que exibe um ícone (ícone de menu) e define a ação para abrir o drawer quando pressionado.

SizedBox: Um widget de caixa que adiciona espaçamento horizontal.

Image.asset: Exibe uma imagem do projeto com altura e largura especificadas.

Este widget cria um botão flutuante que, quando pressionado, abre o menu lateral (drawer) e exibe um ícone de menu e uma imagem do projeto.



 */