// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hasil_quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hasil_kuis _$Hasil_kuisFromJson(Map<String, dynamic> json) => Hasil_kuis(
      id: json['id'] as int?,
      id_pasien: json['id_pasien'] as int?,
      id_quiz: json['id_quiz'] as int?,
      hasil: (json['hasil'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$Hasil_kuisToJson(Hasil_kuis instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_pasien': instance.id_pasien,
      'id_quiz': instance.id_quiz,
      'hasil': instance.hasil,
    };
