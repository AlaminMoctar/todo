import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/task_pro.dart';
import 'package:to_do_list/widget/notifica.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'home/task.dart';


void main() async{
  // Initialisation du système de widgets Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation du plugin de notifications locales
  await Noti.init();

  // Initialisation des fuseaux horaires
  tz.initializeTimeZones();

  // Lancement de l'application avec un fournisseur de tâches
  runApp(
    ChangeNotifierProvider(
      create: (context) => Taskprovider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(

        create: (_) => Taskprovider(), // Création d'un fournisseur de tâches
    builder: (context, child) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DOSTAman',
        home: TaskList(),
      );
    });
  }
}

