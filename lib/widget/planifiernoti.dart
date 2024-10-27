import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Schedule extends StatefulWidget {
  // Date et heure sélectionnées par l'utilisateur
  final DateTime selectedDateTime;
  const Schedule({super.key, required this.selectedDateTime, });
  @override
  State<Schedule> createState() => _ScheduleState();
}
class _ScheduleState extends State<Schedule> {
  // Instance du plugin FlutterLocalNotificationsPlugin pour programmer des notifications
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  // Variable d'état interne pour stocker la date et l'heure sélectionnées
  // (redondante avec widget.selectedDateTime)
  DateTime selectedDateTime = DateTime.now().add(Duration(minutes: 1));
  // Méthode pour programmer une notification avec des paramètres personnalisables
  Future<void> showScheduleNotifications({
    int id = 0,
    String title = 'Scheduled Notification',
    String body = '',
    String payload = '',
    required DateTime scheduledDateTime,
  }) async {
    // Détails de notification spécifiques à la plateforme Android (personnalisables)
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your_channel_id', 'your_channel_name',
        channelDescription: 'your_channel_description');
    // Combiner les détails spécifiques à la plateforme dans un seul objet NotificationDetails
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    // Date et heure de programmation à partir du widget
    // Programmer la notification avec conversion du fuseau horaire (utilise le package "tz")
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.schedule),
      onPressed: () async {
        // Programmer la notification en utilisant la date et l'heure présélectionnées
        await showScheduleNotifications(
          id: 0,
          title: '',
          body: '',
          payload: '',
          scheduledDateTime: selectedDateTime.add(Duration(minutes: 1)),
        );
        // Imprimer un message de debug dans la console
        debugPrint('Notification scheduled for ${widget.selectedDateTime}');
      },
      label: const Text('Schedule Notification'),);
  }
}