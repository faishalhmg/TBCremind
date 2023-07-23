// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pengambilan.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pengambilan _$PengambilanFromJson(Map<String, dynamic> json) => Pengambilan(
      id: json['id'] as int?,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      awal:
          json['awal'] == null ? null : DateTime.parse(json['awal'] as String),
      ambil: json['ambil'] == null
          ? null
          : DateTime.parse(json['ambil'] as String),
      lokasi: json['lokasi'] as String?,
      id_pasien: json['id_pasien'] as int?,
    );

Map<String, dynamic> _$PengambilanToJson(Pengambilan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time?.toIso8601String(),
      'awal': instance.awal?.toIso8601String(),
      'ambil': instance.ambil?.toIso8601String(),
      'lokasi': instance.lokasi,
      'id_pasien': instance.id_pasien,
    };
