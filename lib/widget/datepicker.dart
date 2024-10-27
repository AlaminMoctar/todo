import 'package:flutter/material.dart';

class Datepicker extends StatefulWidget {
  const Datepicker({super.key,});

  @override
  State<Datepicker> createState() => _DatepickerState();
}
class _DatepickerState extends State<Datepicker> {

  // Date et heure sélectionnées par l'utilisateur
  DateTime selectedDate = DateTime.now();

  // Méthode pour afficher un sélecteur de date et d'heure
  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    // Le paramètre context n'est pas utilisé dans cette implémentation
    // Définir la date initiale si non fournie (date actuelle)
    context;
    initialDate ??= DateTime.now();

    // Définir la date de début sélectionnable par défaut (lointain dans le passé)
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));

    // Définir la date de fin sélectionnable par défaut (lointain dans le futur)
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    // Afficher le sélecteur de date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    // Si aucune date n'a été sélectionnée, retourner null
    if (pickedDate == null) return null;

    // Afficher le sélecteur d'heure
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,

      // Heure initiale basée sur la date sélectionnée
      initialTime: TimeOfDay.fromDateTime(pickedDate),
    );

    // Si aucune heure n'a été sélectionnée, retourner la date uniquement
    if (pickedTime == null) return pickedDate;

    // Combiner la date et l'heure sélectionnées dans un objet DateTime
    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.date_range_outlined),
      onPressed: () async {

        // Afficher le sélecteur de date et d'heure
        final DateTime? newDateTime = await showDateTimePicker(
          context: context,
        );

        // Mettre à jour la date et l'heure sélectionnées si une date a été choisie
        if (newDateTime != null) {
          setState(() {
            selectedDate = newDateTime;
          });
        }
        else {

          // Si aucune date n'a été sélectionnée, on ne peut pas créer de notification
          debugPrint('Aucune date et heure sélectionnées'); // Message de debug (suggestion)
        }

      },
      label: Text('Sélectionner date et heure'),
    );
  }
}
