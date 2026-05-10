class TaskModel {
  String id;
  String title;
  String description;
  DateTime date;
  bool completed;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
      'completed': completed,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map, String id) {
    return TaskModel(
      id: id,
      title: map['title'],
      description: map['description'],
      date: map['date'].toDate(),
      completed: map['completed'],
    );
  }
}
