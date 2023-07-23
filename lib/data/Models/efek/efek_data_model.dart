import 'dart:math';

import 'package:hive/hive.dart';

part 'efek_data_model.g.dart';

@HiveType(typeId: 3)
class EfekDataModel {
  @HiveField(0)
  late final int id;
  @HiveField(1)
  String? judul;
  @HiveField(2)
  DateTime p_awal;
  @HiveField(3)
  DateTime? p_akhir;
  @HiveField(4)
  final String dosis;
  @HiveField(5)
  DateTime? lupa;
  @HiveField(6)
  final String efek;
  @HiveField(7)
  final int id_pasien;

  EfekDataModel(
      {int? id,
      this.judul,
      required this.p_awal,
      required this.p_akhir,
      required this.dosis,
      this.lupa,
      required this.efek,
      required this.id_pasien}) {
    this.id = id ?? Random.secure().nextInt(10000 - 1000) + 1000;
  }

  EfekDataModel copyWith({
    int? id,
    String? judul,
    DateTime? p_awal,
    DateTime? p_akhir,
    String? dosis,
    DateTime? lupa,
    String? efek,
    int? id_pasien,
  }) =>
      EfekDataModel(
          id: id ?? this.id,
          judul: judul ?? this.judul,
          p_awal: p_awal ?? this.p_awal,
          p_akhir: p_akhir ?? this.p_akhir,
          dosis: dosis ?? this.dosis,
          lupa: lupa ?? this.lupa,
          efek: efek ?? this.efek,
          id_pasien: id_pasien ?? this.id_pasien);
}
