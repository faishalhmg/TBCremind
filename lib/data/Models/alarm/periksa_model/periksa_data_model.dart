import 'dart:math';

import 'package:hive/hive.dart';

part 'periksa_data_model.g.dart';

@HiveType(typeId: 1)
class PeriksaDataModel {
  @HiveField(0)
  late final int id;
  @HiveField(1)
  final DateTime time;
  @HiveField(2)
  DateTime date1;
  @HiveField(3)
  DateTime? date2;
  @HiveField(4)
  final String lokasi;
  @HiveField(5)
  final int id_pasien;

  PeriksaDataModel(
      {int? id,
      required this.time,
      required this.date1,
      this.date2,
      required this.lokasi,
      required this.id_pasien}) {
    this.id = id ?? Random.secure().nextInt(10000 - 1000) + 1000;
  }

  PeriksaDataModel copyWith(
          {int? id,
          DateTime? time,
          DateTime? date1,
          DateTime? date2,
          String? lokasi,
          int? id_pasien}) =>
      PeriksaDataModel(
          id: id ?? this.id,
          time: time ?? this.time,
          date1: date1 ?? this.date1,
          date2: date2 ?? this.date2,
          lokasi: lokasi ?? this.lokasi,
          id_pasien: id_pasien ?? this.id_pasien);
}
