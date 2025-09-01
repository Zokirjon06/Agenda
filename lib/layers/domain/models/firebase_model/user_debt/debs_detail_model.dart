import 'package:equatable/equatable.dart';

class DebtsListDetailModel extends Equatable {
  String? fulName;
  DateTime? date;
  String? detailComment;
  num? detailAmount;
  num? removDetailAmount;
  String docId;

  DebtsListDetailModel({
    this.fulName,
    this.detailComment = '',
    this.detailAmount = 0,
    this.removDetailAmount = 0,
    this.date,
    this.docId = '',
  });

  Map<String, dynamic> toJson()  {
        return {
        "fulName": fulName,
        "detailComment": detailComment,
        "date": date?.toIso8601String(),
        "detailAmount": detailAmount,
        "removDetailAmount": removDetailAmount,
        };
      }

  factory DebtsListDetailModel.fromJson(Map<String, dynamic> json) {
    return DebtsListDetailModel(
      fulName: json['fulName'] as String? ?? '',
      detailComment: json['detailComment'] as String? ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      detailAmount: json['detailAmount'] as num? ?? 0,
      removDetailAmount: json['removDetailAmount'] as num? ?? 0,
    );
  }

  @override
  List<Object?> get props =>
      [fulName, detailComment, date, detailAmount, removDetailAmount];
}
