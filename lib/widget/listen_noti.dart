import 'package:flutter/material.dart';

class ListenNoti extends StatelessWidget{
  // Charge utile de la notification reçue
  final String payload;

  // Constructeur de la classe
  const ListenNoti ({super.key, required this.payload, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listing noti page'),
      ),
      body: Center(
        child: Text(payload), // Affiche la charge utile de la notification reçue
      ),
    );
  }
}