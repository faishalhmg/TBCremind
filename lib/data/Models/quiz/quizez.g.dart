// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quizez.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quizez _$QuizezFromJson(Map<String, dynamic> json) => Quizez(
      quiz: json['quiz'] as List<dynamic>?,
      question: json['question'] as List<dynamic>?,
      answer: json['answer'] as List<dynamic>?,
    );

Map<String, dynamic> _$QuizezToJson(Quizez instance) => <String, dynamic>{
      'quiz': instance.quiz,
      'question': instance.question,
      'answer': instance.answer,
    };
