import 'package:agenda/layers/data/services/notification_service.dart';
import 'package:agenda/layers/domain/models/hive_model/expenses/expense_model.dart';



void scheduleExpenseReminder(Expense expense) {
  final notificationService = NotificationService();

  if (expense.reminder == 0) {
    // hech qachon
    return;
  }

  DateTime notifyTime = expense.dueDate;

  if (expense.reminder == 1) {
    // aynan dueDate kuni
    notifyTime = expense.dueDate;
  } else if (expense.reminder == 2) {
    // 1 kun oldin
    notifyTime = expense.dueDate.subtract(const Duration(days: 1));
  }

  notificationService.scheduleNotification(
    id: expense.id,
    title: "Expense Reminder",
    body: expense.reminderMessage ?? "Don’t forget your expense!",
    scheduledDate: notifyTime,
  );
}
