import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_pro.dart';

class Cherche extends StatelessWidget{
  const Cherche({super.key});

  @override
  Widget build(BuildContext context){
    // Accéder au TaskProvider pour filtrer les tâches
    final taskProvider = Provider.of<Taskprovider>(context);
    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Stack(
        children: [
          TextField(
            onChanged: (value) {
              // Filtrer les tâches en fonction de la valeur saisie
              taskProvider.filterTasks(value);
            },
            decoration: InputDecoration(fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3,
                        style: BorderStyle.none
                    )
                ),
                prefixIcon: Icon(Icons.search_outlined,
                  weight: 10,
                ),
              hintText: 'Rechercher une tâche',
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child:
            SizedBox(
              height: 10,
              width: 10,
              //color: Colors.deepOrange,

            ),
          )
        ],
      ),
    );
  }
}