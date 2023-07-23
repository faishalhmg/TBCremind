// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'periksa_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PeriksaDataModelAdapter extends TypeAdapter<PeriksaDataModel> {
  @override
  final int typeId = 1;

  @override
  PeriksaDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PeriksaDataModel(
      id: fields[0] as int?,
      time: fields[1] as DateTime,
      date1: fields[2] as DateTime,
      date2: fields[3] as DateTime?,
      lokasi: fields[4] as String,
      id_pasien: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PeriksaDataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.time)
      ..writeByte(2)
      ..write(obj.date1)
      ..writeByte(3)
      ..write(obj.date2)
      ..writeByte(4)
      ..write(obj.lokasi)
      ..writeByte(5)
      ..write(obj.id_pasien);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeriksaDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
