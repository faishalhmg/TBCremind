import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tbc_app/data/Models/alarm/pengambilan_model/pengambilan_data_model.dart';
import 'package:tbc_app/data/Models/alarm/periksa_model/periksa_data_model.dart';

class PengambilanHiveLocalStorage {
  static const _kPengambilanHiveBoxName = 'pengambilan';

  const PengambilanHiveLocalStorage();

  Future<void> init() async {
    Hive.registerAdapter(PengambilanDataModelAdapter());

    await Hive.initFlutter();
    await Hive.openBox(_kPengambilanHiveBoxName);
  }

  Future<List<PengambilanDataModel>> loadPengambilan() async {
    final box = Hive.box(_kPengambilanHiveBoxName);

    final List<PengambilanDataModel> pengambilans = box.values.toList().cast();

    return Future.value(pengambilans);
  }

  Future<PengambilanDataModel> addPengambilan(
      PengambilanDataModel pengambilan) async {
    final box = Hive.box(_kPengambilanHiveBoxName);

    await box.put(pengambilan.id, pengambilan);

    return pengambilan;
  }

  Future<PengambilanDataModel> updatePengambilan(
      PengambilanDataModel pengambilan) async {
    final box = Hive.box(_kPengambilanHiveBoxName);

    await box.put(pengambilan.id, pengambilan);

    return pengambilan;
  }

  Future<void> removePengambilan(PengambilanDataModel pengambilan) {
    final box = Hive.box(_kPengambilanHiveBoxName);

    return box.delete(pengambilan.id);
  }

  Future<void> dispose() async {
    await Hive.close();
  }
}
