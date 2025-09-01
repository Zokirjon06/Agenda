import 'package:hive/hive.dart';

part 'vois_recording_model.g.dart';

@HiveType(typeId: 4) // typeId sizning modelingizni identifikatsiya qilish uchun
class VoiceRecordingModel {
  @HiveField(0)
  final String filePath;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String? description;

  VoiceRecordingModel({
    required this.filePath,
    required this.date,
    this.description,
  });
}
