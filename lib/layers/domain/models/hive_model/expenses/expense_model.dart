import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 0) 
class Expense extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  String type;

  @HiveField(3)
  DateTime dueDate;


  @HiveField(4)
  int reminder;

  @HiveField(5)
  String? reminderMessage;

  @HiveField(6)
  String? recurrence;

  @HiveField(7)
  DateTime? ends;

  Expense({
    required this.id,
    required this.amount,
    required this.type,
    required this.dueDate,
    this.reminder = 0,
    this.reminderMessage,
    this.recurrence,
    this.ends,
  });
}
