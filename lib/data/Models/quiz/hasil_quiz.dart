import 'package:json_annotation/json_annotation.dart';

part 'hasil_quiz.g.dart';

@JsonSerializable()
class Hasil_kuis {
  Hasil_kuis({
    this.id,
    this.id_pasien,
    this.id_quiz,
    this.hasil,
  });

  int? id;
  int? id_pasien;
  int? id_quiz;
  List<int>? hasil;

  factory Hasil_kuis.fromJson(Map<String, dynamic> json) =>
      _$Hasil_kuisFromJson(json);

  Map<String, dynamic> toJson() => _$Hasil_kuisToJson(this);
}
