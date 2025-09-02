// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debts_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtsModelAdapter extends TypeAdapter<DebtsModel> {
  @override
  final int typeId = 0;

  @override
  DebtsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebtsModel(
      name: fields[0] as String?,
      money: fields[1] as num?,
      goal: fields[2] as String?,
      date: fields[3] as DateTime?,
      id: fields[4] as String,
      status: fields[5] as int?,
      debt: fields[6] as String?,
      detail: (fields[7] as List?)?.cast<DebtsDetailModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, DebtsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.money)
      ..writeByte(2)
      ..write(obj.goal)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.debt)
      ..writeByte(7)
      ..write(obj.detail);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DebtsDetailModelAdapter extends TypeAdapter<DebtsDetailModel> {
  @override
  final int typeId = 1;

  @override
  DebtsDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebtsDetailModel(
      fulName: fields[0] as String?,
      detailComment: fields[2] as String?,
      detailAmount: fields[3] as num?,
      removDetailAmount: fields[4] as num?,
      date: fields[1] as DateTime?,
      id: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DebtsDetailModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.fulName)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.detailComment)
      ..writeByte(3)
      ..write(obj.detailAmount)
      ..writeByte(4)
      ..write(obj.removDetailAmount)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtsDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
