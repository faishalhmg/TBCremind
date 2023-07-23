import 'package:json_annotation/json_annotation.dart';

part 'quizez.g.dart';

@JsonSerializable()
class Quizez {
  Quizez({
    this.quiz,
    this.question,
    this.answer,
  });

  List<dynamic>? quiz;
  List<dynamic>? question;
  List<dynamic>? answer;

  factory Quizez.fromJson(Map<String, dynamic> json) => _$QuizezFromJson(json);

  Map<String, dynamic> toJson() => _$QuizezToJson(this);
}
