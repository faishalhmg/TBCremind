import 'package:json_annotation/json_annotation.dart';

part 'pengingat.g.dart';

@JsonSerializable()
class Pengingat {
  Pengingat({
    this.id,
    this.judul,
    this.hari,
    this.waktu,
    this.id_pasien,
  });

  int? id;
  String? judul;
  List<int>? hari;
  DateTime? waktu;
  int? id_pasien;

  factory Pengingat.fromJson(Map<String, dynamic> json) =>
      _$PengingatFromJson(json);

  Map<String, dynamic> toJson() => _$PengingatToJson(this);
}
