import 'package:hive/hive.dart';

part 'debts_model.g.dart';

@HiveType(typeId: 0)
class DebtsModel extends HiveObject {
  @HiveField(0)
  String? name;

  @HiveField(1)
  num? money;

  @HiveField(2)
  String? goal;

  @HiveField(3)
  DateTime? date;

  @HiveField(4)
  String docId;

  @HiveField(5)
  int? status;

  @HiveField(6)
  String? debt;

  @HiveField(7)
  List<DebtsDetailModel>? detail;

  DebtsModel({
    this.name,
    this.money,
    this.goal,
    this.date,
    this.docId = '',
    this.status = 0,
    this.debt,
    this.detail,
  });
}

@HiveType(typeId: 1)
class DebtsDetailModel extends HiveObject {
  @HiveField(0)
  String? fulName;

  @HiveField(1)
  DateTime? date;

  @HiveField(2)
  String? detailComment;

  @HiveField(3)
  num? detailAmount;

  @HiveField(4)
  num? removDetailAmount;

  @HiveField(5)
  String docId;

  DebtsDetailModel({
    this.fulName,
    this.detailComment = '',
    this.detailAmount = 0,
    this.removDetailAmount = 0,
    this.date,
    this.docId = '',
  });
}
