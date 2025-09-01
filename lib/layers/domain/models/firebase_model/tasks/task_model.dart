class TaskModel {
  String task;
  String docId;
  DateTime date;
  String priority;
  // String taskType;
  String? description;
  String? image;
  int? status = 0;

  TaskModel({
    required this.task,
    this.docId = '',
    required this.date,
    required this.priority,
    // required this.taskType,
    this.description,
    this.image,
    this.status = 0,
  });

  // JSON ga o'zgartirish
  Map<String, dynamic> toJson() => {
        "task": task,
        "docId": docId,
        "date": date.toIso8601String(),
        "priority": priority,
        // "taskType": taskType,
        "description": description,
        "image": image,
        "status": status,
      };

  // JSON dan modelga o'zgartirish
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      task: json['task'],
      docId: json['docId'] ?? '',
      date: DateTime.parse(json['date']),
      priority: json['priority'],
      // taskType: json['taskType'],
      description: json['description'],
      image: json['image'],
      status: json['status'],
    );
  }
}
