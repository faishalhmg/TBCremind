import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tbc_app/data/Models/alarm/periksa_model/periksa_data_model.dart';
import 'package:tbc_app/data/Models/efek/efek_data_model.dart';

class EfekHiveLocalStorage {
  static const _kEfekHiveBoxName = 'efek';

  const EfekHiveLocalStorage();

  Future<void> init() async {
    Hive.registerAdapter(EfekDataModelAdapter());

    await Hive.initFlutter();
    await Hive.openBox(_kEfekHiveBoxName);
  }

  Future<List<EfekDataModel>> loadEfek() async {
    final box = Hive.box(_kEfekHiveBoxName);

    final List<EfekDataModel> alarms = box.values.toList().cast();

    return Future.value(alarms);
  }

  Future<EfekDataModel> addEfek(EfekDataModel alarm) async {
    final box = Hive.box(_kEfekHiveBoxName);

    await box.put(alarm.id, alarm);

    return alarm;
  }

  Future<EfekDataModel> updateEfek(EfekDataModel alarm) async {
    final box = Hive.box(_kEfekHiveBoxName);

    await box.put(alarm.id, alarm);

    return alarm;
  }

  Future<void> removeEfek(EfekDataModel alarm) {
    final box = Hive.box(_kEfekHiveBoxName);

    return box.delete(alarm.id);
  }

  Future<void> dispose() async {
    await Hive.close();
  }
}
