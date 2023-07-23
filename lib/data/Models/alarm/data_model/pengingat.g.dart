// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pengingat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pengingat _$PengingatFromJson(Map<String, dynamic> json) => Pengingat(
      id: json['id'] as int?,
      judul: json['judul'] as String?,
      hari: (json['hari'] as List<dynamic>?)?.map((e) => e as int).toList(),
      waktu: json['waktu'] == null
          ? null
          : DateTime.parse(json['waktu'] as String),
      id_pasien: json['id_pasien'] as int?,
    );

Map<String, dynamic> _$PengingatToJson(Pengingat instance) => <String, dynamic>{
      'id': instance.id,
      'judul': instance.judul,
      'hari': instance.hari,
      'waktu': instance.waktu?.toIso8601String(),
      'id_pasien': instance.id_pasien,
    };
