import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tbc_app/data/Models/alarm/periksa_model/periksa_data_model.dart';

class PeriksaHiveLocalStorage {
  static const _kPeriksaHiveBoxName = 'periksa';

  const PeriksaHiveLocalStorage();

  Future<void> init() async {
    Hive.registerAdapter(PeriksaDataModelAdapter());

    await Hive.initFlutter();
    await Hive.openBox(_kPeriksaHiveBoxName);
  }

  Future<List<PeriksaDataModel>> loadPeriksas() async {
    final box = Hive.box(_kPeriksaHiveBoxName);

    final List<PeriksaDataModel> alarms = box.values.toList().cast();

    return Future.value(alarms);
  }

  Future<PeriksaDataModel> addPeriksa(PeriksaDataModel alarm) async {
    final box = Hive.box(_kPeriksaHiveBoxName);

    await box.put(alarm.id, alarm);

    return alarm;
  }

  Future<PeriksaDataModel> updatePeriksa(PeriksaDataModel alarm) async {
    final box = Hive.box(_kPeriksaHiveBoxName);

    await box.put(alarm.id, alarm);

    return alarm;
  }

  Future<void> removePeriksa(PeriksaDataModel alarm) {
    final box = Hive.box(_kPeriksaHiveBoxName);

    return box.delete(alarm.id);
  }

  Future<void> dispose() async {
    await Hive.close();
  }
}
