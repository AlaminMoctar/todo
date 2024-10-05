import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/task_pro.dart';
import '../models/dbhelper.dart';
import '../models/latache.dart';
import '../providers/newtask.dart';
import '../widget/butonfil.dart';
import '../widget/varcher.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});


  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {




  void creatTask(){
    showModalBottomSheet(
      isScrollControlled: true,
        context: context,
      builder: (context){
          return Padding(
            padding:  EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,),
            child: const Newtask (),
          );
      },
    );
  }
  @override
  Widget build(BuildContext context) {

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
      //value.loadTasks();
        Butonfil();
    return Column(
    children: [
     const Cherche(),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Checkbox(value: value.CheckBoxState, tristate: true,
    onChanged: (completed) {
      value.toggleAllCompleted(completed ?? false);
    } ),
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

    Expanded(child: ListView.separated(
    itemCount: value.tasks.length,
    separatorBuilder: (context, index){
    return const Divider(height: 1, color: Colors.cyan,);
    },
    itemBuilder: (context, index)
    {
    var task = value.tasks[index];
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
    child: TaskItem(task: task));
    }
    ))
    ]
    );

    }
      ),
    );
  }
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white54,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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

class TaskItem extends StatelessWidget{
  final Task task ;
  const TaskItem({super.key, required this.task});

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
          GestureDetector(
            onTap: () {
              var provider = Provider.of<Taskprovider>(context, listen: false);
              provider.toggleTask(task);
            },
            child: getCheckBox(),
          ),
          const SizedBox(width: 8,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style:  TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w400,
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),),
                Text(task.description, style: TextStyle(
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),),
                Text(task.status, style: TextStyle(
                  decoration: task.completed ? TextDecoration.lineThrough : null,
                ),),
                Text(
                  DateFormat('yyyy-MM-dd').format(task.dueDate),
                  style: TextStyle(
                    color: task.dueDate.isBefore(DateTime.now()) ? Colors.red : Colors.black,
                  ),
                )
              ],
            ),
          ),
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




