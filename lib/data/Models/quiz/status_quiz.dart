import 'package:json_annotation/json_annotation.dart';

part 'status_quiz.g.dart';

@JsonSerializable()
class Status_Kuis {
  Status_Kuis({
    this.id,
    this.id_quiz,
  });

  int? id;
  int? id_quiz;

  factory Status_Kuis.fromJson(Map<String, dynamic> json) =>
      _$Status_KuisFromJson(json);

  Map<String, dynamic> toJson() => _$Status_KuisToJson(this);
}
