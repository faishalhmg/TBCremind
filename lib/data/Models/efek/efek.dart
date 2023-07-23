import 'package:json_annotation/json_annotation.dart';

part 'efek.g.dart';

@JsonSerializable()
class Efek {
  Efek({
    this.id,
    this.judul,
    this.p_awal,
    this.p_akhir,
    this.dosis,
    this.lupa,
    this.efek,
    this.id_pasien,
  });

  int? id;
  String? judul;
  DateTime? p_awal;
  DateTime? p_akhir;
  String? dosis;
  DateTime? lupa;
  String? efek;
  int? id_pasien;

  factory Efek.fromJson(Map<String, dynamic> json) => _$EfekFromJson(json);

  Map<String, dynamic> toJson() => _$EfekToJson(this);
}
