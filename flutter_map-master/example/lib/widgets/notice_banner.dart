// Importa os pacotes necessários do Flutter e Dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Define um widget chamado NoticeBanner que é do tipo StatelessWidget
class NoticeBanner extends StatelessWidget {
  // Declaração do construtor para um banner de aviso (warning)
  const NoticeBanner.warning({
    Key? key, // Chave única para identificar o widget
    required this.text, // Texto exibido no banner
    required this.url, // URL associada ao banner
    required this.sizeTransition, // Transição de tamanho para responsividade
  })  : icon = Icons.warning_rounded, // Ícone a ser exibido (ícone de aviso)
        foregroundColor = const Color(0xFF410002), // Cor do texto
        backgroundColor = const Color(0xFFFFDAD6); // Cor de fundo do banner

  // Declaração do construtor para um banner de recomendação
  const NoticeBanner.recommendation({
    Key? key, // Chave única para identificar o widget
    required this.text, // Texto exibido no banner
    required this.url, // URL associada ao banner
    required this.sizeTransition, // Transição de tamanho para responsividade
  })  : icon = Icons.task_alt, // Ícone a ser exibido (ícone de tarefa)
        foregroundColor = const Color(0xFF072100), // Cor do texto
        backgroundColor = const Color(0xFFB8F397); // Cor de fundo do banner

  // Atributos da classe
  final String text; // Texto exibido no banner
  final String? url; // URL associada ao banner (pode ser nula)
  final double sizeTransition; // Transição de tamanho para responsividade

  final IconData icon; // Ícone a ser exibido no banner
  final Color foregroundColor; // Cor do texto
  final Color backgroundColor; // Cor de fundo do banner

  // Método responsável por construir o widget
  @override
  Widget build(BuildContext context) {
    // LayoutBuilder permite acessar as restrições de layout do widget pai
    return LayoutBuilder(
      builder: (context, constraints) {
        // Container é um widget que contém outros widgets e define propriedades visuais
        return Container(
          // Define o preenchimento interno do container
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: constraints.maxWidth <= sizeTransition ? 8 : 0,
          ),
          // Define a largura do container para ocupar toda a largura disponível
          width: double.infinity,
          // Define a cor de fundo do container
          color: backgroundColor,
          // Flex é um widget que organiza seus filhos em um layout flexível
          child: Flex(
            // Define a direção do layout com base nas restrições de tamanho
            direction: constraints.maxWidth <= sizeTransition
                ? Axis.vertical
                : Axis.horizontal,
            // Define o alinhamento dos filhos no layout
            mainAxisAlignment: MainAxisAlignment.center,
            // Lista de filhos do Flex
            children: [
              // Icon é um widget que exibe um ícone gráfico
              Icon(icon, color: foregroundColor, size: 32),
              // Espaçamento entre o ícone e o texto
              const SizedBox(height: 12, width: 16),
              // Text é um widget que exibe um texto
              Text(
                text,
                style: TextStyle(color: foregroundColor),
                textAlign: TextAlign.center,
              ),
              // Verifica se há uma URL associada ao banner
              if (url != null) ...[
                // Espaçamento entre o texto e o botão
                const SizedBox(height: 0, width: 16),
                // TextButton é um botão de texto clicável
                TextButton.icon(
                  // Ícone ao lado do botão
                  icon: const Icon(Icons.open_in_new),
                  // Rótulo do botão
                  label: const Text('Learn more'),
                  // Função chamada ao clicar no botão
                  onPressed: () => launchUrl(Uri.parse(url!)),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
/**Este código em Dart representa uma estrutura de dados chamada LatLngBounds que é uma caixa delimitadora retangular definida por seus cantos noroeste (NW) e sudeste (SE). Essa caixa delimitadora é usada para representar uma área geográfica no plano do mapa. Aqui estão algumas explicações:

LatLng: Isso representa um ponto no mapa usando coordenadas de latitude e longitude.

LatLngBounds: É uma caixa delimitadora que contém métodos para expansão, obtenção de bordas e verificação de interseção com outras caixas delimitadoras.

extend: Este método expande a caixa delimitadora para incluir um novo ponto ou outra caixa delimitadora.

contains: Este método verifica se um ponto está dentro da caixa delimitadora.

isOverlapping: Este método verifica se duas caixas delimitadoras têm alguma sobreposição.

center: Este método calcula o ponto central da caixa delimitadora.

hashCode e operator==: São implementados para que você possa usar as instâncias desta classe em estruturas de dados que dependem desses métodos, como Set ou Map. */