import 'package:flutter/material.dart';

class MenuItemWidget extends StatelessWidget {
  final String caption;
  final String routeName;
  final bool isSelected;
  final Widget? icon;

  // Construtor do widget
  const MenuItemWidget({
    required this.caption,
    required this.routeName,
    required String currentRoute,
    this.icon,
    Key? key,
  }) : isSelected = currentRoute == routeName,
       super(key: key);

  // Método responsável por construir o widget
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Título do item do menu
      title: Text(caption),
      // Ícone do item do menu à esquerda
      leading: icon,
      // Define se o item do menu está selecionado
      selected: isSelected,
      // Função chamada quando o item do menu é tocado
      onTap: () {
        if (isSelected) {
          // Se já estiver selecionado, fecha o drawer (menu lateral)
          Navigator.pop(context);
          return;
        }
        // Se não estiver selecionado, navega para a nova rota e substitui a rota atual
        Navigator.pushReplacementNamed(context, routeName);
      },
    );
  }
}


/** Widget e Construtor: Este código define um widget chamado MenuItemWidget, que representa um item de menu em um aplicativo Flutter. O construtor recebe informações como o texto do item, o nome da rota associada, o ícone opcional e a rota atual.

Condição de Seleção: A propriedade isSelected é definida com base na comparação entre a rota atual (currentRoute) e a rota associada ao item do menu (routeName). Se são iguais, o item do menu é considerado selecionado.

ListTile: O widget ListTile é usado para representar visualmente um item de menu. Ele inclui o título, o ícone, a condição de seleção e uma função de retorno de chamada (onTap) para lidar com toques no item do menu.

Ação ao Tocar: Quando um item do menu é tocado, a função onTap é chamada. Se o item já estiver selecionado, o drawer (menu lateral) é fechado usando Navigator.pop(context). Caso contrário, o aplicativo navega para a nova rota usando Navigator.pushReplacementNamed(context, routeName). A substituição de rota é usada para substituir a rota atual pela nova rota no histórico de navegação.*/