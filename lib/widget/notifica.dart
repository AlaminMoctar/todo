import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:rxdart/rxdart.dart';


class Noti  {

  // Instance unique du plugin FlutterLocalNotificationsPlugin (singleton)
   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
   FlutterLocalNotificationsPlugin();

   // Stream BehaviorSubject pour diffuser les clics sur les notifications
   static final onClickNotification = BehaviorSubject<String>();

   // Fuseau horaire local actuel (utilisé pour les notifications)
  static final currentTimeZone =  FlutterTimezone.getLocalTimezone();

   // Méthode appelée lorsqu'une notification est tapée par l'utilisateur
   static void onNotificationTap(
       NotificationResponse notificationResponse 
       )

   // Ajouter la charge utile de la notification au BehaviorSubject
   {
    onClickNotification.add(notificationResponse.payload!);
   }

   // Méthode d'initialisation du plugin
    static Future init() async{
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      // Paramètres d'initialisation pour iOS
      final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {},
      );

      // Paramètres d'initialisation pour Linux (facultatif)
      final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
          defaultActionName: 'Open notification');

      // Paramètres d'initialisation combinés pour toutes les plateformes
      final InitializationSettings initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          linux: initializationSettingsLinux);

      // Initialisation du plugin avec gestion des clics sur les notifications
      _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap
      );
    }


   // Méthode pour afficher une notification simple
    static void showBasicNotifications({
     required String title,
     required String body,
     required String payload}) async {
     NotificationDetails details = const NotificationDetails(
         android: AndroidNotificationDetails('id 1', 'basic notification')
     );

     // Afficher la notification avec un ID de 0
     await _flutterLocalNotificationsPlugin.show(0, 'Simple notification', 'this is a body notification', details);
   }


   // Méthode pour afficher une notification périodique
  static Future showPeriodicNotifications({
     required String title,
    required String body,
    required String payload
}) async {

    // Détails de la notification spécifiques à Android
   const AndroidNotificationDetails androidNotificationDetails =
       AndroidNotificationDetails('channelId', 'channel',
       channelDescription: 'this my channel desc',
       importance: Importance.max,
       priority: Priority.high,
       ticker: 'ticker');

   // Détails de la notification combinés pour toutes les plateformes
   const NotificationDetails notificationDetails =
       NotificationDetails(android: androidNotificationDetails);

   // Afficher la notification avec un ID de 1 et une charge utile
   await _flutterLocalNotificationsPlugin.show(
     1, title, body, payload: 'this periodic noti',
       notificationDetails
   );
  }

  // Méthode pour annuler une notification par son ID
   static Future cancel (int id) async {
   await _flutterLocalNotificationsPlugin.cancel(id);
  }

   // Méthode pour annuler toutes les notifications simple et périodique programmées
   static Future cancelAll () async {
     await _flutterLocalNotificationsPlugin.cancelAll();
   }
}

