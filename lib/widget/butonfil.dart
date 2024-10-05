import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_pro.dart';

class Butonfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Taskprovider>(
      builder: (context, taskProvider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Alignement des boutons
          children: [
            ElevatedButton(
              onPressed: () {
                taskProvider.setDisplayState(DisplayState.all);
              },
              child: Text('Tous'),
            ),
            ElevatedButton(
              onPressed: () {
                taskProvider.setDisplayState(DisplayState.active);
              },
              child: Text('En cours'),
            ),
            ElevatedButton(
              onPressed: () {
                taskProvider.setDisplayState(DisplayState.completed);
              },
              child: Text('Terminées'),
            ),
          ],
        );


      },
    );
  }
}