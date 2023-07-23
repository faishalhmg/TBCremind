import 'package:json_annotation/json_annotation.dart';

part 'pengambilan.g.dart';

@JsonSerializable()
class Pengambilan {
  Pengambilan({
    this.id,
    this.time,
    this.awal,
    this.ambil,
    this.lokasi,
    this.id_pasien,
  });

  int? id;
  DateTime? time;
  DateTime? awal;
  DateTime? ambil;
  String? lokasi;
  int? id_pasien;

  factory Pengambilan.fromJson(Map<String, dynamic> json) =>
      _$PengambilanFromJson(json);

  Map<String, dynamic> toJson() => _$PengambilanToJson(this);
}
