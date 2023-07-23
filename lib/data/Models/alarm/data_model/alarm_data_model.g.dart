// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmDataModelAdapter extends TypeAdapter<AlarmDataModel> {
  @override
  final int typeId = 0;

  @override
  AlarmDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmDataModel(
      id: fields[0] as int?,
      judul: fields[1] as String,
      time: fields[2] as DateTime,
      weekdays: (fields[3] as List).cast<int>(),
      id_pasien: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmDataModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.judul)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.weekdays)
      ..writeByte(4)
      ..write(obj.id_pasien);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
