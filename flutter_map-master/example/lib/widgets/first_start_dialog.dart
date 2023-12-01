// Importa os pacotes necessários do Flutter
import 'package:flutter/material.dart';

// Define um widget chamado FirstStartDialog que é do tipo StatelessWidget
class FirstStartDialog extends StatelessWidget {
  // Construtor do widget
  const FirstStartDialog({Key? key}) : super(key: key);

  // Método responsável por construir o widget
  @override
  Widget build(BuildContext context) {
    // Obtém a largura da tela usando o MediaQuery
    final width = MediaQuery.of(context).size.width;

    // Retorna um AlertDialog, um diálogo de alerta do Material Design
    return AlertDialog(
      // Define um ícone não restrito a uma caixa para o diálogo
      icon: UnconstrainedBox(
        // Contém uma imagem de um tamanho específico
        child: SizedBox.square(
          dimension: 64,
          child: Image.asset('assets/ProjectIcon.png', fit: BoxFit.fill),
        ),
      ),
      // Título do diálogo
      title: const Text('flutter_map Live Web Demo'),
      // Conteúdo do diálogo
      content: ConstrainedBox(
        // Restringe as caixas do conteúdo a determinadas limitações
        constraints: BoxConstraints(
          maxWidth: width < 750
              ? double.infinity
              : (width / (width < 1100 ? 1.5 : 2.5)),
        ),
        // Conteúdo principal do diálogo
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Parágrafo de texto informativo
            const Text(
              'This is built automatically off of the latest commits to '
              "'master', so may not reflect the latest release available "
              'on pub.dev.\n'
              "This is hosted on Firebase Hosting, meaning there's limited "
              'bandwidth to share between all users, so please keep loads to a '
              'minimum.',
              textAlign: TextAlign.center,
            ),
            // Padding (preenchimento) para o texto no canto superior direito
            Padding(
              padding: const EdgeInsets.only(right: 8, top: 16, bottom: 4),
              // Alinha o texto no canto superior direito
              child: Align(
                alignment: Alignment.centerRight,
                // Texto indicando que a mensagem não será mostrada novamente
                child: Text(
                  "This won't be shown again",
                  // Estilo do texto com cor específica
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.5),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),
      ),
      // Ações associadas ao diálogo
      actions: [
        // Botão "OK" com ícone de confirmação
        TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          label: const Text('OK'),
          icon: const Icon(Icons.done),
        ),
      ],
      // Preenchimento do conteúdo do diálogo
      contentPadding: const EdgeInsets.only(left: 24, top: 16, right: 24),
    );
  }
}


/**Widget e Construtor: Este código define um widget chamado FirstStartDialog que representa um diálogo de alerta exibido no início.

Obtenção da Largura da Tela: O código usa MediaQuery para obter a largura da tela do dispositivo.

AlertDialog: O widget AlertDialog é usado para criar um diálogo de alerta com título, conteúdo e ações.

Ícone e Imagem: Um ícone e uma imagem (ProjectIcon.png) são exibidos no início do diálogo.

Conteúdo Responsivo: O conteúdo do diálogo é ajustado com base na largura da tela para garantir uma experiência responsiva.

Texto Informativo: Um parágrafo de texto fornece informações sobre a demonstração ao vivo.

Texto Adicional e Ações: Há um texto adicional no canto superior direito indicando que a mensagem não será mostrada novamente. Um botão "OK" é fornecido como ação para fechar o diálogo */