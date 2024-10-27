import 'package:flutter/material.dart';

import '../widget/datepicker.dart';
import '../widget/listen_noti.dart';
import '../widget/notifica.dart';
import '../widget/planifiernoti.dart';

class Notifi extends StatefulWidget {
  const Notifi({super.key});

  @override
  State<Notifi> createState() => _NotifiState();

}

class _NotifiState extends State<Notifi> {

  // Date sélectionnée (initialisée à la date actuelle)
  DateTime selectedDate = DateTime.now();
  // Ecoute des notifications au démarrage
  @override
  void initState() {
    listenToNotifications();
    super.initState();
  }
  // Méthode pour écouter les notifications
  listenToNotifications() {
    print('listing to noti'); // Message de debug
    Noti.onClickNotification.stream.listen((event){
      // Navigation vers l'écran ListenNoti avec les données de la notification
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => ListenNoti(payload: event,)));
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: const Text('Notifications Task'),
  centerTitle: true,
  elevation: 0,
  ),
  body: Center(
    child: Column(
    children: [
      // Bouton d'envoi d'une notification simple
    ElevatedButton.icon(
    icon: Icon(Icons.notifications_active),
    onPressed: () {
    Noti.showBasicNotifications(
    title: 'simple noti',
    body: 'bodynoti',
    payload: 'this is simple'
    );
    }, label: Text('Simple notification')),
      // Bouton d'envoi d'une notification périodique
    ElevatedButton.icon(
    icon: Icon(Icons.timer),
    onPressed: () {
    Noti.showPeriodicNotifications(
    title: 'Periodic Noti',
    body: 'bodynoti',
    payload: 'this is simple'
    );
    }, label: Text('Periodic notification')),
      // Bouton d'annulation d'une notification par son ID
    ElevatedButton.icon(
    icon: Icon(Icons.close),
    onPressed: () {
    Noti.cancel(1);
    }, label: Text('close noti')),
      // Bouton d'annulation de notifications simples et périodique
    ElevatedButton.icon(
    icon: Icon(Icons.delete_forever_outlined),
    onPressed: () {
    Noti.cancelAll();
    }, label: Text('deleteAll notis')),
      Datepicker (),// Widget Datepicker
      Schedule(selectedDateTime: DateTime.now().add(Duration(minutes: 1))) // Widget schedule
    ],

    ),
    
  ),

  );
  }

}









