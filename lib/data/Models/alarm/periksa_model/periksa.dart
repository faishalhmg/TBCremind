import 'package:json_annotation/json_annotation.dart';

part 'periksa.g.dart';

@JsonSerializable()
class Periksa {
  Periksa({
    this.id,
    this.time,
    this.sebelumnya,
    this.selanjutnya,
    this.lokasi_periksa,
    this.id_pasien,
  });

  int? id;
  DateTime? time;
  DateTime? sebelumnya;
  DateTime? selanjutnya;
  String? lokasi_periksa;
  int? id_pasien;

  factory Periksa.fromJson(Map<String, dynamic> json) =>
      _$PeriksaFromJson(json);

  Map<String, dynamic> toJson() => _$PeriksaToJson(this);
}
