import 'dart:math';

import 'package:hive/hive.dart';

part 'alarm_data_model.g.dart';

@HiveType(typeId: 0)
class AlarmDataModel {
  @HiveField(0)
  late final int id;
  @HiveField(1)
  String judul;
  @HiveField(2)
  DateTime time;
  @HiveField(3)
  final List<int> weekdays;
  @HiveField(4)
  final int id_pasien;

  AlarmDataModel(
      {int? id,
      required this.judul,
      required this.time,
      required this.weekdays,
      required this.id_pasien}) {
    this.id = id ?? Random.secure().nextInt(10000 - 1000) + 1000;
  }

  AlarmDataModel copyWith(
          {int? id,
          String? judul,
          DateTime? time,
          List<int>? weekdays,
          int? id_pasien}) =>
      AlarmDataModel(
          id: id ?? this.id,
          judul: judul ?? this.judul,
          time: time ?? this.time,
          weekdays: weekdays != null ? List.from(weekdays) : this.weekdays,
          id_pasien: id_pasien ?? this.id_pasien);
}
