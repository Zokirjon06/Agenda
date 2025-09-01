class TaskTypeModel {
  String docId;
  DateTime date; // Vaqt maydoni
  String name;

  TaskTypeModel({
    this.docId = '',
    required this.name,
    required this.date, // Konstruktor orqali kiritiladi
  });

  // JSON ga o'zgartirish
  Map<String, dynamic> toJson() => {
        "docId": docId,
        "name": name,
        "date": date.toIso8601String(), // DateTime ISO 8601 formatiga o'zgartiriladi
      };

  // JSON dan modelga o'zgartirish
  factory TaskTypeModel.fromJson(Map<String, dynamic> json) {
    return TaskTypeModel(
      docId: json['docId'] ?? '',
      name: json['name'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date']) // JSONdagi 'date' qiymati DateTime formatiga o'giriladi
          : DateTime.now(), // Agar 'date' bo'lmasa, joriy vaqt olinadi
    );
  }
}
