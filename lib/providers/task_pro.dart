import 'package:flutter/material.dart';
import '../models/dbhelper.dart';
import '../models/latache.dart';
import 'package:intl/intl.dart';

// Enumération pour définir les différents états d'affichage des tâches
enum DisplayState {
  all,
  active,
  completed,
}

class Taskprovider extends ChangeNotifier{

// Instance de l'helper de base de données
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final List<Task> _allTasks = [];
  List<Task> filteredTasks = [];

  // Liste des tâches en mémoire
  List<Task> tasks = [
    Task(id: 1, title: 'task1', description: 'welcom in my frist task', priority: 'moyenne', status: 'en cours', dueDate: DateTime.now().add(Duration(days: 3)),),
    Task(id: 2, title: 'task2', description: 'welcom in my second task', priority: 'faible', status: 'à faire', dueDate: DateTime.now().add(Duration(days: 1)), ),

  ];

  // Méthode pour charger les tâches depuis la base de données
  Future<void> loadTasks() async {

    // Utiliser _dbHelper.queryAllRows() pour récupérer les tâches
    List<Map<String, dynamic>> tasksFromDb = await _dbHelper.queryAllRows();

    // Convertir les tâches en objets Task
    tasks = tasksFromDb.map((task) => Task.fromMap(task)).toList();

    // Informe les widgets utilisant ce Provider que les données ont changé
    notifyListeners();
  }

  // État d'affichage des tâches (toutes, actives, terminées)
  DisplayState _displayState = DisplayState.all;
  DisplayState get displayState => _displayState;

  List<Task> get taches {
    return switch(_displayState){
      DisplayState.active => tasks.where((t) => !t.completed).toList(), // Renvoie uniquement les tâches non terminées
      DisplayState.completed => tasks.where((t) => t.completed).toList(),// Renvoie uniquement les tâches terminées
      _ => tasks // Renvoie toutes les tâches
    };
  }

  // Détermine l'état global de la checkbox principale en fonction des tâches
  bool? get CheckBoxState{
    bool hasComplete = tasks.any((t) => t.completed); // Y a-t-il des tâches terminées ?
    bool hasUnComplete = tasks.any((t) => !t.completed); // Y a-t-il des tâches non terminées ?


    if(hasComplete && hasUnComplete){
      // Tâches terminées et non terminées présentes : état indéfini
      return null;
    } else if(hasComplete){
      // Uniquement des tâches terminées : cocher la checkbox
      return true;
    } else {
      // Uniquement des tâches non terminées : décocher la checkbox
      return false;
    }
  }

  // Ajoute une nouvelle tâche
  void addTask (String title, String description,  String priority, String status, DateTime dueDate)
  {
    String formattedDueDate = DateFormat ('yyyy-MM-dd').format(dueDate);
    int taskId = DateTime.now().microsecondsSinceEpoch;
    var task = Task(id: taskId, title: title, description: description, priority: priority, status: status, dueDate: dueDate);
    tasks.add(task);// Ajout à la liste en mémoire
    notifyListeners();// Informe les widgets des changements

    // Ajout à la base de données
    _dbHelper.insert(task.toMap()).then((id) {
      print('Task added with ID: $id');
      task.id = id;
      tasks.add(task);
      notifyListeners();

    });
  }

   // Fonction pour mettre à jour une tâche
  void updateTask (int taskId, String title, String description, String priority, String status, DateTime? dueDate,)
  {
    // Recherche la tâche à mettre à jour en fonction de son ID
    var task = tasks.where((t) => t.id == taskId).first;
    task.title = title; task.description = description;  task.priority = priority; task.status = status;
    // Informe les widgets utilisant ce Provider des changements (avant la mise à jour en base de données)
    notifyListeners();

    // Mise à jour des propriétés de la tâche en mémoire
    task.title = title;
    task.description = description;
    task.priority = priority;
    task.status = status;
    task.dueDate = dueDate!;
    _dbHelper.update(task.toMap()).then((_) {
      // Informe les widgets des changements une fois la mise à jour en base de données effectuée
      notifyListeners();
    });
  }

// Fonction pour supprimer une tâche
  void deleteTask (Task task)
  {
    // Suppression de la tâche en base de données
    _dbHelper.delete(task.id).then((_) {
      // Suppression de la tâche de la liste en mémoire
      tasks.remove(task);
      notifyListeners();
    });
  }

  // Fonction pour inverser l'état d'achèvement d'une tâche
  void toggleTask (Task task)
  {
    // Inverser l'état d'achèvement de la tâche
    task.completed = !task.completed;
    notifyListeners();
  }

  // Fonction pour inverser l'état d'achèvement de toutes les tâches
  void toggleAllCompleted(bool completed)
  {
    // Parcourir toutes les tâches
    for (var task in tasks){
      // Modifier l'état d'achèvement de chaque tâche
      task.completed = completed;
    }
    notifyListeners();
  }

  // Fonction pour définir l'état d'affichage des tâches
  void setDisplayState(DisplayState newState)
  {
    // Mise à jour de l'état d'affichage interne
    _displayState = newState;
    notifyListeners();
  }


  void filterTasks(String query) {
    if (query.isEmpty) {
      filteredTasks = _allTasks; // Afficher toutes les tâches si la recherche est vide
    } else {
      filteredTasks = _allTasks.where((task) =>
      task.title.toLowerCase().contains(query.toLowerCase()) ||
          task.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
    notifyListeners(); // Notifier les widgets pour déclencher un re-rendu
  }
}