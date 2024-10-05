import 'package:flutter/material.dart';

import '../models/dbhelper.dart';
import '../models/latache.dart';
import 'package:intl/intl.dart';

enum DisplayState {
  all,
  active,
  completed,
}

class Taskprovider extends ChangeNotifier{

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Task> tasks = [
    Task(id: 1, title: 'task1', description: 'welcom in my frist task', priority: 'moyenne', status: 'en cours', dueDate: DateTime.now().add(Duration(days: 3)),),
    Task(id: 2, title: 'task2', description: 'welcom in my second task', priority: 'faible', status: 'à faire', dueDate: DateTime.now().add(Duration(days: 1)), ),

  ];
  Future<void> loadTasks() async {
    // Utiliser _dbHelper.queryAllRows() pour récupérer les tâches
    List<Map<String, dynamic>> tasksFromDb = await _dbHelper.queryAllRows();
    // Convertir les tâches en objets Task (si vous utilisez un modèle de données)
    this.tasks = tasksFromDb.map((task) => Task.fromMap(task)).toList();
    notifyListeners();
  }

  DisplayState _displayState = DisplayState.all;
  DisplayState get displayState => _displayState;

  List<Task> get taches {
    return switch(_displayState){
      DisplayState.active => tasks.where((t) => !t.completed).toList(),
      DisplayState.completed => tasks.where((t) => t.completed).toList(),
      _=>tasks
    };
  }

  bool? get CheckBoxState{
    bool hasComplete = tasks.any((t) => t.completed);
    bool hasUnComplete = tasks.any((t) => !t.completed);

    if(hasComplete && hasUnComplete){
      return null;
    } else if(hasComplete){
      return true;
    } else {
      return false;
    }
  }

  void addTask (String title, String description,  String priority, String status, DateTime dueDate)
  {
    String formattedDueDate = DateFormat ('yyyy-MM-dd').format(dueDate);
    int taskId = DateTime.now().microsecondsSinceEpoch;
    var task = Task(id: taskId, title: title, description: description, priority: priority, status: status, dueDate: dueDate);
    tasks.add(task);
    notifyListeners();
    _dbHelper.insert(task.toMap()).then((id) {
      print('Task added with ID: $id');
      task.id = id;
      tasks.add(task);
      notifyListeners();

    });
  }

  void updateTask (int taskId, String title, String description, String priority, String status, DateTime? dueDate,)
  {
    var task = tasks.where((t) => t.id == taskId).first;
    task.title = title; task.description = description;  task.priority = priority; task.status = status;
    notifyListeners();

   //var task = tasks.where((t) => t.id == taskId).first;
    task.title = title;
    task.description = description;
    task.priority = priority;
    task.status = status;
    task.dueDate = dueDate!;
    _dbHelper.update(task.toMap()).then((_) {
      notifyListeners();
    });
  }


  void deleteTask (Task task)
  {
    _dbHelper.delete(task.id).then((_) {
      tasks.remove(task);
      notifyListeners();
    });

    //tasks.remove(task);
  }

  void toggleTask (Task task)
  {
    task.completed = !task.completed;
    notifyListeners();
  }

  void toggleAllCompleted(bool completed)
  {
    for (var task in tasks){
      task.completed = completed;
    }
    notifyListeners();
  }

  void setDisplayState(DisplayState newState)
  {
    _displayState = newState;
    notifyListeners();
  }





}