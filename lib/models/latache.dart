class Task {
  int id;
  String title;
  String description;
  String priority;
  String status;
  DateTime dueDate;
  bool completed;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = 'moyenne',
    this.status = 'à faire',
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'status': status,
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        dueDate: map['dueDate'],
        priority: map['priority'],
        status: map['status'],

    );
  }

  }

