// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'efek_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EfekDataModelAdapter extends TypeAdapter<EfekDataModel> {
  @override
  final int typeId = 3;

  @override
  EfekDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EfekDataModel(
      id: fields[0] as int?,
      judul: fields[1] as String?,
      p_awal: fields[2] as DateTime,
      p_akhir: fields[3] as DateTime?,
      dosis: fields[4] as String,
      lupa: fields[5] as DateTime?,
      efek: fields[6] as String,
      id_pasien: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EfekDataModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.judul)
      ..writeByte(2)
      ..write(obj.p_awal)
      ..writeByte(3)
      ..write(obj.p_akhir)
      ..writeByte(4)
      ..write(obj.dosis)
      ..writeByte(5)
      ..write(obj.lupa)
      ..writeByte(6)
      ..write(obj.efek)
      ..writeByte(7)
      ..write(obj.id_pasien);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EfekDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
