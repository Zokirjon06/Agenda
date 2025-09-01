import 'package:hive/hive.dart';

part 'task_model_hive.g.dart';

@HiveType(typeId: 2)
class TaskModelHive extends HiveObject {
  @HiveField(0)
  String task;

  @HiveField(1)
  String docId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String priority;

  @HiveField(4)
  String? description;

  @HiveField(5)
  String? image;

  @HiveField(6)
  int status;

  TaskModelHive({
    required this.task,
    this.docId = '',
    required this.date,
    required this.priority,
    this.description,
    this.image,
    this.status = 0,
  });

  // Convert to Firebase model for compatibility
  Map<String, dynamic> toJson() => {
        "task": task,
        "docId": docId,
        "date": date.toIso8601String(),
        "priority": priority,
        "description": description,
        "image": image,
        "status": status,
      };

  // Create from Firebase model for migration
  factory TaskModelHive.fromFirebaseModel(Map<String, dynamic> json) {
    return TaskModelHive(
      task: json['task'],
      docId: json['docId'] ?? '',
      date: DateTime.parse(json['date']),
      priority: json['priority'],
      description: json['description'],
      image: json['image'],
      status: json['status'] ?? 0,
    );
  }
}

@HiveType(typeId: 3)
class TaskTypeModelHive extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String docId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String? description;

  TaskTypeModelHive({
    required this.name,
    this.docId = '',
    required this.date,
    this.description,
  });

  // Convert to Firebase model for compatibility
  Map<String, dynamic> toJson() => {
        "name": name,
        "docId": docId,
        "date": date.toIso8601String(),
        "description": description,
      };

  // Create from Firebase model for migration
  factory TaskTypeModelHive.fromFirebaseModel(Map<String, dynamic> json) {
    return TaskTypeModelHive(
      name: json['name'],
      docId: json['docId'] ?? '',
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }
}
