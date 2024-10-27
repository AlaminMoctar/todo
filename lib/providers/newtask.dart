import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/providers/task_pro.dart';
import '../models/latache.dart';

// Classe Newtask - widget à état permettant de créer
// un formulaire pour ajouter ou modifier une tâche
class Newtask extends StatefulWidget {
  final Task? task;// Tâche existante à modifier (optionnelle)

  const Newtask({super.key, this.task});
  @override
  State<Newtask> createState() => _NewtaskState();
}
class _NewtaskState extends State<Newtask> {
  // Contrôleurs de formulaire pour chaque champ de saisie
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priorityController = TextEditingController();
  final statusController = TextEditingController();
  final dueDateController = TextEditingController();
  DateTime? dateTime;



  final formKey = GlobalKey<FormState>();// Clé unique pour le formulaire

  DateTime? dueDate;
  @override
  void initState() {
    super.initState();

    // Remplissage des contrôleurs avec les valeurs de la tâche existante (si fournie)
    titleController.text = widget.task?.title ?? "";
    descriptionController.text = widget.task?.description ?? "";
    statusController.text = widget.task?.status ?? "";
    dueDate = widget.task?.dueDate; // Récupération de la date d'échéance existante

    // Affichage de la date d'échéance initiale dans le champ de formulaire

    dueDateController.text = dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate!) : ''; // Display initial due date if any
  }
  @override
  void dispose() {
    super.dispose();

    // Libération des ressources utilisées par les contrôleurs
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    statusController.dispose();

  }
  void saveTask(){
    if (!formKey.currentState!.validate()){
       return; // Arrêt de la méthode si le formulaire n'est pas valide
    }

    // Récupération du TaskProvider via Provider.of
    final provider = Provider.of<Taskprovider>(context, listen: false);

    // Parse de la date d'échéance à partir du texte du contrôleur
      dueDate = DateFormat('yyyy-MM-dd').parse(dueDateController.text);

    // Vérification de la date d'échéance future
    if (dueDate!.isBefore(DateTime.now())) {
        // Afficher un message d'erreur : "La date d'échéance doit être future"
        return;
      }

    // Ajout d'une nouvelle tâche ou mise à jour d'une tâche existante via le TaskProvider
    if (widget.task == null){
     provider.addTask(
       titleController.text,
       descriptionController.text,
       priorityController.text ,
       statusController.text,
       dueDate!,);
   }
   else{
     provider.updateTask(
       widget.task!.id,
       titleController.text,
       descriptionController.text,
       priorityController.text ,
       statusController.text,
       dueDate,);
   }

    // Notification d'ajout réussi
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        content: Text("la tache est ajouter", style: TextStyle(color: Colors.white),
        )
    )
    );

    // Fermeture de la page du formulaire
    Navigator.of(context).pop();
}

  // Sélection d'une date d'échéance via showDatePicker
  Future<void> selectDueDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(), // Date initiale basée sur la date existante ou la date actuelle
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        dueDate = selectedDate;
        dueDateController.text = DateFormat('yyyy-MM-dd').format(dueDate!);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50, height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Ajoutez une task",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),),
              const SizedBox(height: 10,),
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "title of task",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if(value!.isEmpty) {
                    return'Veillez saisie dans le champ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 5,),
              TextFormField(
                controller: descriptionController,
                minLines: 2,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: "Description",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if(value!.isEmpty) {
                    return'Veillez saisie dans le champ';
                  }
                  return null;
                },
              ),
              //const SizedBox(height: 5,),

              TextFormField(
                controller: dueDateController,
                decoration: InputDecoration(
                  hintText: 'Due Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        dueDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
                      }
                    },
                  ),
                ),
                validator: (value) {
                  if(value!.isEmpty) {
                    return'Veillez choisi une date';
                  }
                  return null;
                },
                readOnly: true,
              ),
              const SizedBox(height: 5,),
              Row(
                children: [
                  Expanded(
                    child: TextButton(onPressed: () {
                      Navigator.of(context).pop();
                    },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(
                              color: Colors.cyan
                            )
                          )
                        ),
                        child: const Text("Annuler")),
                  ),
                  const SizedBox(width: 5,),
                  Expanded(
                    child: TextButton(onPressed: saveTask,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.cyan,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                            )
                        ),
                        child: const Text("Enregistrer")),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}