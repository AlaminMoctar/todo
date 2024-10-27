import 'package:flutter/material.dart';

// Classe Navinot  Widget représentant la barre de navigation inférieure
class Navinot extends StatelessWidget {
  // Index de l'élément sélectionné actuellement
  final int currentIndex;
  
  // Fonction de rappel appelée lorsque l'utilisateur clique sur un élément
  final void Function(int) onTap;

  // Constructeur du widget
  const Navinot({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(

      // Liste des éléments de la barre de navigation
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "Notification",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_ethernet_outlined),
          label: "settings",
        ),
      ],
      currentIndex: currentIndex, // Index de l'élément actuellement sélectionné

      // Fonction de rappel appelée lorsque l'utilisateur clique sur un élément
      onTap: onTap,
    );
  }
}