// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vois_recording_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoiceRecordingModelAdapter extends TypeAdapter<VoiceRecordingModel> {
  @override
  final int typeId = 4;

  @override
  VoiceRecordingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoiceRecordingModel(
      filePath: fields[0] as String,
      date: fields[1] as DateTime,
      description: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, VoiceRecordingModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.filePath)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceRecordingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
