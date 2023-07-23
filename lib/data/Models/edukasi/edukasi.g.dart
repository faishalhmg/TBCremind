// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edukasi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Edukasi _$EdukasiFromJson(Map<String, dynamic> json) => Edukasi(
      id: json['id'] as int?,
      judul: json['judul'] as String?,
      isi: json['isi'] as String?,
      media: json['media'] as String?,
      created_by: json['created_by'] as int?,
      created_at: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$EdukasiToJson(Edukasi instance) => <String, dynamic>{
      'id': instance.id,
      'judul': instance.judul,
      'isi': instance.isi,
      'media': instance.media,
      'created_by': instance.created_by,
      'created_at': instance.created_at?.toIso8601String(),
    };
