import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:tbc_app/data/Models/alarm/data_model/alarm_data_model.dart';

class AlarmsHiveLocalStorage {
  static const _kAlarmsHiveBoxName = 'alarms';

  const AlarmsHiveLocalStorage();

  Future<void> init() async {
    Hive.registerAdapter(AlarmDataModelAdapter());

    await Hive.initFlutter();
    await Hive.openBox(_kAlarmsHiveBoxName);
  }

  isExists() async {
    final openBox = await Hive.openBox(_kAlarmsHiveBoxName);
    int length = openBox.length;
    return length;
  }

  Future<List<AlarmDataModel>> loadAlarms() async {
    final box = Hive.box(_kAlarmsHiveBoxName);

    final List<AlarmDataModel> alarms = box.values.toList().cast();

    return Future.value(alarms);
  }

  Future<AlarmDataModel> addAlarm(AlarmDataModel periksa) async {
    final box = Hive.box(_kAlarmsHiveBoxName);

    await box.put(periksa.id, periksa);

    return periksa;
  }

  Future<AlarmDataModel> updateAlarm(AlarmDataModel periksa) async {
    final box = Hive.box(_kAlarmsHiveBoxName);

    await box.put(periksa.id, periksa);

    return periksa;
  }

  Future<void> removeAlarm(AlarmDataModel periksa) {
    final box = Hive.box(_kAlarmsHiveBoxName);

    return box.delete(periksa.id);
  }

  Future<void> dispose() async {
    await Hive.close();
  }
}
