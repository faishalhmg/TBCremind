import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tbc_app/data/Models/alarm/pengambilan_hive_storage.dart';
import 'package:tbc_app/data/Models/alarm/pengambilan_model/pengambilan_data_model.dart';
import 'package:tbc_app/data/Models/alarm/periksa_hive_storage.dart';
import 'package:tbc_app/data/Models/alarm/periksa_model/periksa_data_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/helper/alarm_helper.dart';
import 'package:tbc_app/service/StorageService.dart';
import 'package:timezone/timezone.dart';

class PengambilanModel extends ChangeNotifier {
  final PengambilanHiveLocalStorage _storage;

  PengambilanState? state;
  List<PengambilanDataModel>? pengambilans;
  List<PengambilanDataModel> _pengambilanList = [];
  List<dynamic> get pengambilanList => _pengambilanList;
  bool loading = true;
  final DioClient _dioClient = DioClient();

  PengambilanModel(PengambilanHiveLocalStorage storage) : _storage = storage {
    _storage.init().then((_) => loadPengambilan());
  }

  @override
  void dispose() {
    _storage.dispose();
    super.dispose();
  }

  void loadPengambilan() async {
    final StorageService _storageService = StorageService();
    String? id = await _storageService.readSecureData('id');
    try {
      List result = await _dioClient.getPengambilan(id: int.parse(id!));

      result.map((e) async {
        PengambilanDataModel pengambilan1 = PengambilanDataModel(
          id: int.tryParse(e['id'].toString()),
          id_pasien: int.parse(e['id_pasien'].toString()),
          time: DateTime.parse(e['time'].toString()),
          date1: DateTime.parse(e['awal'].toString()),
          date2: DateTime.parse(e['ambil'].toString()),
          lokasi: e['lokasi'],
        );
        _pengambilanList.add(pengambilan1);
        await _storage.addPengambilan(pengambilan1);
      }).toList();
    } catch (e) {
      null;
    }

    final pengambilans = await _storage.loadPengambilan();
    this.pengambilans = List.from(pengambilans
        .where((element) => element.id_pasien == int.tryParse(id!)));

    state = PengambilanLoaded(pengambilans);

    loading = false;
    notifyListeners();
  }

  Future<void> addPengambilan(PengambilanDataModel pengambilan) async {
    loading = true;
    notifyListeners();

    final newPengambilan1 = await _dioClient.createPengambilan(
      id_pasien: pengambilan.id_pasien,
      time: pengambilan.time.toIso8601String(),
      ambil: pengambilan.date2!.toIso8601String(),
      awal: pengambilan.date1.toIso8601String(),
      lokasi: pengambilan.lokasi,
    );
    final newPengambilan = await _storage.addPengambilan(PengambilanDataModel(
      id: newPengambilan1!.id,
      id_pasien: pengambilan.id_pasien,
      time: pengambilan.time,
      date2: pengambilan.date2,
      date1: pengambilan.date1,
      lokasi: pengambilan.lokasi,
    ));

    pengambilans!.add(newPengambilan);
    pengambilans!.sort(pengambilansort);

    pengambilans = List.from(pengambilans!);

    loading = false;
    state = PengambilanCreate(
      pengambilan,
      pengambilans!.indexOf(newPengambilan),
    );
    notifyListeners();

    await _scheduledPengambilan(pengambilan);
  }

  Future<void> updatePengambilan(
      PengambilanDataModel pengambilan, int index) async {
    loading = true;
    notifyListeners();

    final pengambilanss = await _dioClient.updatePengambilan(
        id_pasien: pengambilan.id_pasien,
        time: pengambilan.time,
        awal: pengambilan.date1,
        ambil: pengambilan.date2,
        lokasi: pengambilan.lokasi,
        id: pengambilan.id);
    if (pengambilanss.toString().contains('berhasil')) {
      final newPengambilan = await _storage.updatePengambilan(pengambilan);
      pengambilans![index] = newPengambilan;
      pengambilans!.sort(pengambilansort);
      pengambilans = List.from(pengambilans!);

      loading = false;
      state = PengambilanUpdate(
        newPengambilan,
        pengambilan,
        index,
        pengambilans!.indexOf(newPengambilan),
      );
      notifyListeners();

      await _removeScheduledPengambilan(pengambilan);
      await _scheduledPengambilan(newPengambilan);
    }
  }

  Future<void> deletePengambilan(
      PengambilanDataModel pengambilan, int index) async {
    loading = true;
    notifyListeners();
    final delete = await _dioClient.deletePengambilan(id: pengambilan.id);
    if (delete.toString().contains('berhasil')) {
      await _storage.removePengambilan(pengambilan);

      pengambilans!.removeAt(index);

      loading = false;
      state = PeriksaDeleted(
        pengambilan,
        index,
      );
      notifyListeners();

      await _removeScheduledPengambilan(pengambilan);
    }
  }

  int pengambilansort(pengambilan1, pengambilan2) =>
      pengambilan1.time.compareTo(pengambilan2.time);

  Future<void> _removeScheduledPengambilan(PengambilanDataModel periksa) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (periksa.date2 != null) {
      await flutterLocalNotificationsPlugin.cancel(periksa.id);
      await Alarm.stop((periksa.id * 100) + periksa.id);
    }
  }

  Future<void> _scheduledPengambilan(PengambilanDataModel periksa) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'pengambilan',
      'Pengambilan Obat',
      channelDescription: 'Show the pengambilan',
      importance: Importance.max,
      priority: Priority.high,
      sound: UriAndroidNotificationSound("assets/alarm.mp3"),
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.zonedSchedule(
      periksa.id,
      'pengambilan at ${fromTimeToString(periksa.time)}',
      'Ring Ring!!! Jangan lupa ambil obat hari ini!',
      TZDateTime.local(
        periksa.time.year,
        periksa.time.month,
        periksa.date2!.day,
        periksa.time.hour,
        periksa.time.minute,
      ),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    DateTime day = DateTime(
      periksa.time.year,
      periksa.time.month,
      periksa.date2!.day,
      periksa.time.hour,
      periksa.time.minute,
    );
    final alarmSettings = AlarmSettings(
        id: (periksa.id * 100) + periksa.id,
        dateTime: day,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        fadeDuration: 3.0,
        notificationTitle: 'Alarm at ${fromTimeToString(periksa.time)}',
        notificationBody:
            'Ring Ring!!! Waktunya Ambil Obat! Jangan lupa ambil obat hari ini',
        enableNotificationOnKill: true,
        stopOnNotificationOpen: true);
    await Alarm.set(alarmSettings: alarmSettings);
  }
}

abstract class PengambilanState {
  const PengambilanState();
}

class PengambilanLoaded extends PengambilanState {
  final List<PengambilanDataModel> pengambilans;

  const PengambilanLoaded(this.pengambilans);
}

// state for create, update, delete,
class PengambilanCreate extends PengambilanState {
  final PengambilanDataModel pengambilan;
  final int index;

  const PengambilanCreate(this.pengambilan, this.index);
}

class PeriksaDeleted extends PengambilanState {
  final PengambilanDataModel pengambilan;
  final int index;

  const PeriksaDeleted(this.pengambilan, this.index);
}

class PengambilanUpdate extends PengambilanState {
  final PengambilanDataModel pengambilan;
  final PengambilanDataModel oldpengambilan;
  final int index;
  final int newIndex;

  const PengambilanUpdate(
      this.pengambilan, this.oldpengambilan, this.index, this.newIndex);
}
