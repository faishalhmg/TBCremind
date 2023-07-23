// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'periksa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Periksa _$PeriksaFromJson(Map<String, dynamic> json) => Periksa(
      id: json['id'] as int?,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      sebelumnya: json['sebelumnya'] == null
          ? null
          : DateTime.parse(json['sebelumnya'] as String),
      selanjutnya: json['selanjutnya'] == null
          ? null
          : DateTime.parse(json['selanjutnya'] as String),
      lokasi_periksa: json['lokasi_periksa'] as String?,
      id_pasien: json['id_pasien'] as int?,
    );

Map<String, dynamic> _$PeriksaToJson(Periksa instance) => <String, dynamic>{
      'id': instance.id,
      'time': instance.time?.toIso8601String(),
      'sebelumnya': instance.sebelumnya?.toIso8601String(),
      'selanjutnya': instance.selanjutnya?.toIso8601String(),
      'lokasi_periksa': instance.lokasi_periksa,
      'id_pasien': instance.id_pasien,
    };
