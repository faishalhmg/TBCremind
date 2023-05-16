import 'package:json_annotation/json_annotation.dart';

part 'keluarga.g.dart';

@JsonSerializable()
class Keluarga {
  Keluarga({
    this.id,
    this.nama,
    this.usia,
    this.riwayat,
    this.jenis,
    this.id_pasien,
  });

  int? id;
  String? nama;
  int? usia;

  String? riwayat;
  String? jenis;
  int? id_pasien;

  factory Keluarga.fromJson(Map<String, dynamic> json) =>
      _$KeluargaFromJson(json);

  Map<String, dynamic> toJson() => _$KeluargaToJson(this);
}
