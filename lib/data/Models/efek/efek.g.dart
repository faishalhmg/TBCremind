// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'efek.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Efek _$EfekFromJson(Map<String, dynamic> json) => Efek(
      id: json['id'] as int?,
      judul: json['judul'] as String?,
      p_awal: json['p_awal'] == null
          ? null
          : DateTime.parse(json['p_awal'] as String),
      p_akhir: json['p_akhir'] == null
          ? null
          : DateTime.parse(json['p_akhir'] as String),
      dosis: json['dosis'] as String?,
      lupa:
          json['lupa'] == null ? null : DateTime.parse(json['lupa'] as String),
      efek: json['efek'] as String?,
      id_pasien: json['id_pasien'] as int?,
    );

Map<String, dynamic> _$EfekToJson(Efek instance) => <String, dynamic>{
      'id': instance.id,
      'judul': instance.judul,
      'p_awal': instance.p_awal?.toIso8601String(),
      'p_akhir': instance.p_akhir?.toIso8601String(),
      'dosis': instance.dosis,
      'lupa': instance.lupa?.toIso8601String(),
      'efek': instance.efek,
      'id_pasien': instance.id_pasien,
    };
