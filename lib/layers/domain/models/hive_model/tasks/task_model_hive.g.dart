// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelHiveAdapter extends TypeAdapter<TaskModelHive> {
  @override
  final int typeId = 2;

  @override
  TaskModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModelHive(
      task: fields[0] as String,
      docId: fields[1] as String,
      date: fields[2] as DateTime,
      priority: fields[3] as String,
      description: fields[4] as String?,
      image: fields[5] as String?,
      status: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModelHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.task)
      ..writeByte(1)
      ..write(obj.docId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TaskTypeModelHiveAdapter extends TypeAdapter<TaskTypeModelHive> {
  @override
  final int typeId = 3;

  @override
  TaskTypeModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskTypeModelHive(
      name: fields[0] as String,
      docId: fields[1] as String,
      date: fields[2] as DateTime,
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TaskTypeModelHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.docId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskTypeModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
