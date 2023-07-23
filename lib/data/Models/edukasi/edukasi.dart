import 'package:json_annotation/json_annotation.dart';

part 'edukasi.g.dart';

@JsonSerializable()
class Edukasi {
  Edukasi(
      {this.id,
      this.judul,
      this.isi,
      this.media,
      this.created_by,
      this.created_at});

  int? id;
  String? judul;
  String? isi;
  String? media;
  int? created_by;
  DateTime? created_at;

  factory Edukasi.fromJson(Map<String, dynamic> json) =>
      _$EdukasiFromJson(json);

  Map<String, dynamic> toJson() => _$EdukasiToJson(this);
}
