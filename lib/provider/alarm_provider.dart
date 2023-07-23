import 'dart:math';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/alarm/alarm_hive_storage.dart';
import 'package:tbc_app/data/Models/alarm/data_model/alarm_data_model.dart';
import 'package:tbc_app/data/Models/alarm/data_model/pengingat.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/helper/alarm_helper.dart';
import 'package:tbc_app/service/StorageService.dart';
import 'package:timezone/timezone.dart';

class AlarmModel extends ChangeNotifier {
  final AlarmsHiveLocalStorage _storage;

  AlarmState? state;
  List<AlarmDataModel>? alarms;

  List<AlarmDataModel> _alarmList = [];
  List<dynamic> get alarmList => _alarmList;
  bool loading = true;
  final DioClient _dioClient = DioClient();

  AlarmModel(AlarmsHiveLocalStorage storage) : _storage = storage {
    _storage.init().then((_) => loadAlarms());
  }

  @override
  void dispose() {
    _storage.dispose();
    super.dispose();
  }

  DateTime getDesiredDayDate(int desiredDay, DateTime currentDate) {
    int currentDay = currentDate.weekday;

    // Jika hari yang diinginkan sama dengan hari saat ini, gunakan tanggal saat ini
    if (desiredDay == currentDay) {
      return DateTime(currentDate.year, currentDate.month, currentDate.day);
    }

    int difference = desiredDay - currentDay;
    if (difference <= 0) {
      difference += 7;
    }

    DateTime desiredDate = currentDate.add(Duration(days: difference));
    return DateTime(desiredDate.year, desiredDate.month, desiredDate.day);
  }

  void loadAlarms() async {
    final StorageService _storageService = StorageService();
    String? id = await _storageService.readSecureData('id');
    try {
      List result = await _dioClient.getPengingat(id: int.parse(id!));

      result.map((e) async {
        for (var a = 0; a < result.length; a++) {
          List<int> list = e['hari'].toString().split(',').map<int>((ee) {
            // Check if the string is not empty and contains only numeric characters
            if (ee.isNotEmpty && RegExp(r'^[0-9]+$').hasMatch(ee)) {
              return int.parse(ee);
            } else {
              // Handle the case when the parsing fails (e.g., non-numeric content or empty string)
              return 1; // You can set a default value or use any other appropriate handling here
            }
          }).toList();
          AlarmDataModel alarm1 = AlarmDataModel(
              id: int.tryParse(e['id'].toString()),
              id_pasien: int.parse(e['id_pasien'].toString()),
              time: DateTime.parse(e['waktu'].toString()),
              weekdays: list,
              judul: e['judul']);
          _alarmList.add(alarm1);
          await _storage.addAlarm(alarm1);
        }
      }).toList();
    } catch (e) {
      null;
    }
    final alarms = await _storage.loadAlarms();
    this.alarms = List.from(
        alarms.where((element) => element.id_pasien == int.tryParse(id!)));

    state = AlarmLoaded(alarms);

    loading = false;
    notifyListeners();
  }

  Future<void> addAlarm(AlarmDataModel alarm) async {
    loading = true;
    notifyListeners();
    final newAlarm1 = await _dioClient.createPengingat(
        id_pasien: alarm.id_pasien,
        judul: alarm.judul,
        waktu: alarm.time.toIso8601String(),
        hari: alarm.weekdays.map((i) => i.toString()).join(","));

    final newAlarm = await _storage.addAlarm(AlarmDataModel(
        id: newAlarm1!.id,
        id_pasien: newAlarm1.id_pasien!,
        judul: newAlarm1.judul!,
        time: alarm.time,
        weekdays: alarm.weekdays));

    alarms!.add(newAlarm);
    alarms!.sort(alarmSort);

    alarms = List.from(alarms!);

    loading = false;
    state = AlarmCreated(
      alarm,
      alarms!.indexOf(newAlarm),
    );
    notifyListeners();

    await _scheduleAlarm(alarm);
  }

  Future<void> updateAlarm(AlarmDataModel alarm, int index) async {
    loading = true;
    notifyListeners();
    final newAlarm1 = await _dioClient.updatePengingat(
        id: alarm.id,
        id_pasien: alarm.id_pasien,
        judul: alarm.judul,
        waktu: alarm.time.toIso8601String(),
        hari: alarm.weekdays.map((i) => i.toString()).join(","));
    if (newAlarm1.toString().contains('berhasil')) {
      final newAlarm = await _storage.updateAlarm(alarm);

      alarms![index] = newAlarm;
      alarms!.sort(alarmSort);
      alarms = List.from(alarms!);

      loading = false;
      state = AlarmUpdated(
        newAlarm,
        alarm,
        index,
        alarms!.indexOf(newAlarm),
      );
      notifyListeners();

      await _removeScheduledAlarm(alarm);
      await _scheduleAlarm(newAlarm);
    }
  }

  Future<void> deleteAlarm(AlarmDataModel alarm, int index) async {
    loading = true;
    notifyListeners();

    final delete = await _dioClient.deletePengingat(id: alarm.id);
    if (delete.toString().contains('berhasil')) {
      await _storage.removeAlarm(alarm);

      alarms!.removeAt(index);

      loading = false;
      state = AlarmDeleted(
        alarm,
        index,
      );
      notifyListeners();

      await _removeScheduledAlarm(alarm);
    }
  }

  int daysInMonth(int year, int month) {
    if (month == 12) {
      return DateTime(year + 1, 1, 0).day;
    } else {
      return DateTime(year, month + 1, 0).day;
    }
  }

  int alarmSort(alarm1, alarm2) => alarm1.time.compareTo(alarm2.time);

  Future<void> _removeScheduledAlarm(AlarmDataModel alarm) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (alarm.weekdays.isNotEmpty) {
      for (var notification in pendingNotificationRequests) {
        // get grouped id
        if ((notification.id / 10000).floor() == alarm.id) {
          await Alarm.stop(notification.id);
        }
        if ((notification.id / 10).floor() == alarm.id) {
          await flutterLocalNotificationsPlugin.cancel(notification.id);
        }
      }
    } else {
      await flutterLocalNotificationsPlugin.cancel(alarm.id);
      await Alarm.stop(alarm.id);
    }
  }

  Future<void> _scheduleAlarm(AlarmDataModel alarm) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'efek',
      'efek Obat',
      channelDescription: 'Show the efek',
      importance: Importance.max,
      priority: Priority.high,
      sound: UriAndroidNotificationSound("assets/alarm.mp3"),
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails());

    if (alarm.weekdays.isEmpty) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        alarm.id,
        'Alarm at ${fromTimeToString(alarm.time)}',
        'Ring Ring!!! Waktunya Minum Obat!',
        TZDateTime.local(
          alarm.time.year,
          alarm.time.month,
          alarm.time.day,
          alarm.time.hour,
          alarm.time.minute,
        ),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      final alarmSettings = AlarmSettings(
          id: alarm.id,
          dateTime: alarm.time,
          assetAudioPath: 'assets/alarm.mp3',
          loopAudio: true,
          vibrate: true,
          fadeDuration: 3.0,
          notificationTitle: 'Alarm at ${fromTimeToString(alarm.time)}',
          notificationBody: 'Ring Ring!!! Waktunya Minum Obat!',
          enableNotificationOnKill: true,
          stopOnNotificationOpen: true);
      await Alarm.set(alarmSettings: alarmSettings);
    } else {
      for (var weekday in alarm.weekdays) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          // acts as an id, for cancelling later
          alarm.id * 10 + weekday,
          'Alarm at ${fromTimeToString(alarm.time)}',
          'Ring Ring!!! Waktunya Minum Obat!',
          TZDateTime.local(
            alarm.time.year,
            alarm.time.month,
            alarm.time.day - alarm.time.weekday + weekday,
            alarm.time.hour,
            alarm.time.minute,
          ),
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
        final now = DateTime.now();
        DateTime desiredDate = getDesiredDayDate(weekday, now);
        DateTime alarmDate = DateTime(
          alarm.time.year,
          desiredDate.month,
          desiredDate.day,
          alarm.time.hour,
          alarm.time.minute,
        );

        // Membuat objek AlarmSettings untuk setiap tanggal
        final alarmSettings = AlarmSettings(
          id: alarm.id * 10000 + weekday,
          dateTime: alarmDate,
          assetAudioPath: 'assets/alarm.mp3',
          loopAudio: true,
          vibrate: true,
          fadeDuration: 3.0,
          notificationTitle: 'Alarm at ${fromTimeToString(alarmDate)}',
          notificationBody: 'Ring Ring!!! Waktunya Minum Obat!',
          enableNotificationOnKill: true,
          stopOnNotificationOpen: true,
        );

        // Mengatur alarm menggunakan fungsi Alarm.set
        await Alarm.set(alarmSettings: alarmSettings);
      }
      // DateTime currentDate = DateTime.now();
      // int currentMonth = currentDate.month;
      // int currentDay = currentDate.day;
      // int urutan = 1000;

      // for (var month = currentMonth; month <= 12; month++) {
      //   int startDay = (month == currentMonth) ? currentDay : 1;
      //   for (var day = startDay;
      //       day <= daysInMonth(alarm.time.year, month);
      //       day++) {
      //     // Menghitung tanggal untuk setiap hari dalam setahun

      //   }
      // }
    }
  }
}

abstract class AlarmState {
  const AlarmState();
}

class AlarmLoaded extends AlarmState {
  final List<AlarmDataModel> alarms;

  const AlarmLoaded(this.alarms);
}

// state for create, update, delete,
class AlarmCreated extends AlarmState {
  final AlarmDataModel alarm;
  final int index;

  const AlarmCreated(this.alarm, this.index);
}

class AlarmDeleted extends AlarmState {
  final AlarmDataModel alarm;
  final int index;

  const AlarmDeleted(this.alarm, this.index);
}

class AlarmUpdated extends AlarmState {
  final AlarmDataModel alarm;
  final AlarmDataModel oldAlarm;
  final int index;
  final int newIndex;

  const AlarmUpdated(this.alarm, this.oldAlarm, this.index, this.newIndex);
}
