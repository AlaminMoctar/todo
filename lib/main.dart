import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/task_pro.dart';

import 'home/task.dart';

void main() {
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
    return ChangeNotifierProvider(create: (_) => Taskprovider(),
    builder: (context, child) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DOSTAman',
        home: TaskList(),
      );
    });
  }
}

