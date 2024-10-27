import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/task_pro.dart';
import 'package:to_do_list/widget/navnot.dart';
import '../models/etat.dart';
import '../models/latache.dart';
import '../models/notifi.dart';
import '../providers/newtask.dart';
import '../widget/varcher.dart';


// Classe TaskList pour l'écran principal de la liste des tâches
class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // Index de navigation actuel
  int _currentIndex = 0;

  // Liste d'écrans à afficher en fonction de l'index de navigation pour les icons du bas
  final List<Widget> ecrane =
  [
    const Notifi(),
    Etat(),
  ];

  // Méthode pour gère le clic sur un élément de la barre de navigation
  void _onNavigationItemTapped(int index){
    setState(() {
      _currentIndex = index;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => ecrane[index]));
  }

  // Ouvre un modal en bas de l'écran pour créer une nouvelle tâche
  void creatTask(){
    showModalBottomSheet(
      isScrollControlled: true,
        context: context,
      builder: (context){
          return Padding(
            padding:  EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,),

            // Widget Newtask pour créer une nouvelle tâche
            child: const Newtask (),
          );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    // Accède au fournisseur de tâches

    final Taskprovider value = Provider.of<Taskprovider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: buildAppBar(),
      floatingActionButton: FloatingActionButton(
          onPressed: creatTask,
              child: const Icon(Icons.add),
      ),
      body: Consumer<Taskprovider>(
       builder: (context, value, child)
    {
    return Column(
    children: [
      // Widget de recherche
     const Cherche(),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Checkbox pour cocher, décocher ou laisser indéfini les tâches
    Checkbox(value: value.CheckBoxState, tristate: true,
    onChanged: (completed) {
      value.toggleAllCompleted(completed ?? false);
    } ),

    // Flitrage de tâches en fonctions de leurs états
    ToggleButtons(
    onPressed: (index){
    final newState = switch (index) {
    0 => DisplayState.all,
    1 => DisplayState.active,
    _ => DisplayState.completed
    };
    value.setDisplayState(newState);
    },
    borderRadius: const BorderRadius.all(Radius.circular(15)),
    selectedColor: Colors.white,
    fillColor: Colors.cyan,
    textStyle: const TextStyle(fontSize: 10),
    constraints: const BoxConstraints(
    maxHeight: 40,
    minWidth: 80,
    ),
    isSelected:[
      value.displayState == DisplayState.all,
      value.displayState == DisplayState.active,
      value.displayState == DisplayState.completed
    ],
    children: [
      const Text('Tous'),
      const Text('Encours'),
      const Text('Terminer')]

    )
    ],
    ),

    Expanded(
        child: ListView.separated(
          // Affichage de nombre d'éléments de la liste et leur séparation
    itemCount: value.tasks.length,
    separatorBuilder: (context, index){
    return const Divider(height: 1, color: Colors.cyan,);
    },
            // Constructeur de chaque élément de la liste
    itemBuilder: (context, index)
    {// Récupère la tâche courante
    var task = value.tasks[index];
    // Widget permettant de supprimer la tâche
    return Dismissible(
    key: ValueKey(task.id),
    onDismissed: (direction){
    final provider = Provider.of<Taskprovider>(context, listen: false);
    provider.deleteTask(task);
    },
    background: Container(
    alignment: Alignment.center,
    color: Colors.red,
    child: const Text('Supprimer', style: TextStyle(color: Colors.white),),
    ),
        // Widget représentant la tâche individuelle (défini dans la classe TaskItem)
    child: TaskItem(task: task));
    }
    ))
    ]
    );

    }
      ),
      //Bottom permmettant d'accèder aux pages de deux icons du bas
      bottomNavigationBar: Navinot(currentIndex: _currentIndex, onTap: _onNavigationItemTapped),
    );
  }
  // la barre d'application
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white54,
      elevation: 0, // Supprime l'ombre de l'AppBar
      title: Row(
        // Espace des éléments horizontalement
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icône de menu (icon ne pas fonctionnel)
          const Icon(Icons.menu,
          color: Color(0xFF3A3A3A), size: 30,),
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/img1.jpg'),
            ),
          )
        ],
      ),

    );
  }
}

// Classe représentant un élément de la liste des tâches
class TaskItem extends StatelessWidget{
  // Tâche associée à l'élément
  final Task task ;
  const TaskItem({super.key, required this.task});  // Constructeur
  // Méthode pour récupérer l'apparence de la checkbox en fonction de l'état de la tâche
  Widget getCheckBox(){
    if(!task.completed){
      return Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            )
        ),
      );
    }
    return Container(
      height: 20,
      width: 20,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green
      ),
      child: const Icon(Icons.check, size: 15, color: Colors.white,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // GestureDetector pour gérer le clic sur la checkbox
          GestureDetector(
            onTap: () {
              // Accède au fournisseur de tâches et bascule l'état de complétion de la tâche
              var provider = Provider.of<Taskprovider>(context, listen: false);
              provider.toggleTask(task);
            },
            child: getCheckBox(),
          ),
          const SizedBox(width: 8,),  // Espace horizontal entre la checkbox et le contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre de la tâche avec style adapté à l'état de complétion
                Text(task.title, style:  TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w400,
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),),
                // Description de la tâche avec style adapté à l'état de complétion
                Text(task.description, style: TextStyle(
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),),
                Text(task.status, style: TextStyle(
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),),
                // Date d'échéance de la tâche avec indication visuelle si dépassée
                Text(
                  DateFormat('yyyy-MM-dd').format(task.dueDate),
                  style: TextStyle(
                    color: task.dueDate.isBefore(DateTime.now()) ? Colors.red : Colors.black,
                  ),
                )
              ],
            ),
          ),
          // Bouton d'édition de la tâche
          IconButton(onPressed: () {
            {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context){
                  return Padding(
                    padding:  EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,),
                    child: Newtask (task: task),
                  );
                },
              );
            }
          },
              icon: const Icon(Icons.edit),)
        ],
      ),
    );
  }
}




