import 'package:agenda/layers/domain/models/firebase_model/user_debt/debs_detail_model.dart';
import 'package:equatable/equatable.dart';

class DebtsListModel extends Equatable {
  String? name;
  num? money;
  String? goal;
  DateTime? date;
  DateTime? dueDate;
  String docId;
  int? status;
  String? debt;
  List<DebtsListDetailModel>? detail;

  DebtsListModel({
    this.name,
    this.money,
    this.goal,
    this.date,
    this.dueDate,
    this.docId = '',
    this.status = 0,
    this.debt,
    this.detail,
  });

  // JSON dan obyektga aylantirish
  factory DebtsListModel.fromJson(Map<String, dynamic> json) {
    return DebtsListModel(
      name: json['name'] as String?,
      money: json['money'] as num?,
      goal: json['goal'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      docId: json['docId'] as String,
      status: json['status'] as int? ?? 0,
      debt: json['debt'] as String?,
      detail: (json['detail'] as List<dynamic>?)
          ?.map((child) =>
              DebtsListDetailModel.fromJson(child as Map<String, dynamic>))
          .toList(),
    );
  }

  // Obyektni JSON formatiga aylantirish
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "money": money,
      "goal": goal,
      "date": date?.toIso8601String(), // Null bo'lsa, null qaytaradi
      "dueDate": dueDate?.toIso8601String(),
      "docId": docId,
      "status": status,
      "debt": debt,
      "detail": detail?.map((child) => child.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props =>
      [name, money, goal, date,dueDate, docId, status, debt, detail];
}
