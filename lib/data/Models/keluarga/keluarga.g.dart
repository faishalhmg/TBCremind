// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keluarga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Keluarga _$KeluargaFromJson(Map<String, dynamic> json) => Keluarga(
      id: json['id'] as int?,
      nama: json['nama'] as String?,
      usia: json['usia'] as int?,
      riwayat: json['riwayat'] as String?,
      jenis: json['jenis'] as String?,
      id_pasien: json['id_pasien'] as int?,
    );

Map<String, dynamic> _$KeluargaToJson(Keluarga instance) => <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'usia': instance.usia,
      'riwayat': instance.riwayat,
      'jenis': instance.jenis,
      'id_pasien': instance.id_pasien,
    };
