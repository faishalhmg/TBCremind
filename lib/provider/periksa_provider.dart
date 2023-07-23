import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tbc_app/data/Models/alarm/periksa_hive_storage.dart';
import 'package:tbc_app/data/Models/alarm/periksa_model/periksa_data_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/helper/alarm_helper.dart';
import 'package:tbc_app/service/StorageService.dart';
import 'package:timezone/timezone.dart';

class PeriksaModel extends ChangeNotifier {
  final PeriksaHiveLocalStorage _storage;

  PeriksaState? state;
  List<PeriksaDataModel>? periksas;
  List<PeriksaDataModel> _periksasList = [];
  List<dynamic> get pengambilanList => _periksasList;
  bool loading = true;
  final DioClient _dioClient = DioClient();

  PeriksaModel(PeriksaHiveLocalStorage storage) : _storage = storage {
    _storage.init().then((_) => loadPeriksas());
  }

  @override
  void dispose() {
    _storage.dispose();
    super.dispose();
  }

  void loadPeriksas() async {
    final StorageService _storageService = StorageService();
    String? id = await _storageService.readSecureData('id');
    try {
      List result = await _dioClient.getPeriksa(id: int.parse(id!));
      result.map((e) async {
        PeriksaDataModel periksa1 = PeriksaDataModel(
          id: int.tryParse(e['id'].toString()),
          id_pasien: int.parse(e['id_pasien'].toString()),
          time: DateTime.parse(e['time'].toString()),
          date1: DateTime.parse(e['sebelumnya'].toString()),
          date2: DateTime.parse(e['selanjutnya'].toString()),
          lokasi: e['lokasi_periksa'],
        );
        _periksasList.add(periksa1);
        await _storage.addPeriksa(periksa1);
      }).toList();
    } catch (e) {
      null;
    }

    final periksas = await _storage.loadPeriksas();
    this.periksas = List.from(
        periksas.where((element) => element.id_pasien == int.tryParse(id!)));
    state = PeriksaLoaded(periksas);

    loading = false;
    notifyListeners();
  }

  Future<void> addPeriksa(PeriksaDataModel periksa) async {
    loading = true;
    notifyListeners();

    final newPeriksa1 = await _dioClient.createPeriksa(
      id_pasien: periksa.id_pasien,
      time: periksa.time.toIso8601String(),
      selanjutnya: periksa.date2!.toIso8601String(),
      sebelumnya: periksa.date1.toIso8601String(),
      lokasi_periksa: periksa.lokasi,
    );
    final newPeriksa = await _storage.addPeriksa(PeriksaDataModel(
      id: newPeriksa1!.id,
      id_pasien: periksa.id_pasien,
      time: periksa.time,
      date2: periksa.date2,
      date1: periksa.date1,
      lokasi: periksa.lokasi,
    ));

    periksas!.add(newPeriksa);
    periksas!.sort(periksasort);

    periksas = List.from(periksas!);

    loading = false;
    state = PeriksaCreated(
      periksa,
      periksas!.indexOf(newPeriksa),
    );
    notifyListeners();

    await _scheduledPeriksa(periksa);
  }

  Future<void> updatePeriksa(PeriksaDataModel periksa, int index) async {
    loading = true;
    notifyListeners();
    final periksass = await _dioClient.updatePeriksa(
        id_pasien: periksa.id_pasien,
        time: periksa.time,
        sebelumnya: periksa.date1,
        selanjutnya: periksa.date2,
        lokasi_periksa: periksa.lokasi,
        id: periksa.id);

    if (periksass.toString().contains('berhasil')) {
      final newPeriksa = await _storage.updatePeriksa(periksa);

      periksas![index] = newPeriksa;
      periksas!.sort(periksasort);
      periksas = List.from(periksas!);

      loading = false;
      state = PeriksaUpdate(
        newPeriksa,
        periksa,
        index,
        periksas!.indexOf(newPeriksa),
      );
      notifyListeners();

      await _removeScheduledPeriksa(periksa);
      await _scheduledPeriksa(newPeriksa);
    }
  }

  Future<void> deletePeriksa(PeriksaDataModel periksa, int index) async {
    loading = true;
    notifyListeners();
    final delete = await _dioClient.deletePeriksa(id: periksa.id);

    if (delete.toString().contains('berhasil')) {
      await _storage.removePeriksa(periksa);

      periksas!.removeAt(index);

      loading = false;
      state = PeriksaDeleted(
        periksa,
        index,
      );
      notifyListeners();

      await _removeScheduledPeriksa(periksa);
    }
  }

  int periksasort(periksa1, periksa2) => periksa1.time.compareTo(periksa2.time);

  Future<void> _removeScheduledPeriksa(PeriksaDataModel periksa) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (periksa.date2 != null) {
      await flutterLocalNotificationsPlugin.cancel(periksa.id);
      await Alarm.stop((periksa.id * 1000) + periksa.id);
    }
  }

  Future<void> _scheduledPeriksa(PeriksaDataModel periksa) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'periksa',
      'Periksa Dahak',
      channelDescription: 'Show the periksa',
      importance: Importance.max,
      priority: Priority.high,
      sound: UriAndroidNotificationSound("assets/alarm.mp3"),
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.zonedSchedule(
      periksa.id,
      'periksa at ${fromTimeToString(periksa.time)}',
      'Ring Ring!!! Jangan lupa periksa dahak hari ini!',
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
        id: (periksa.id * 1000) + periksa.id,
        dateTime: day,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        fadeDuration: 3.0,
        notificationTitle: 'Alarm at ${fromTimeToString(periksa.time)}',
        notificationBody:
            'Ring Ring!!! Waktunya Periksa Dahak! Jangan lupa periksa dahak hari ini',
        enableNotificationOnKill: true,
        stopOnNotificationOpen: true);
    await Alarm.set(alarmSettings: alarmSettings);
  }
}

abstract class PeriksaState {
  const PeriksaState();
}

class PeriksaLoaded extends PeriksaState {
  final List<PeriksaDataModel> periksas;

  const PeriksaLoaded(this.periksas);
}

// state for create, update, delete,
class PeriksaCreated extends PeriksaState {
  final PeriksaDataModel periksa;
  final int index;

  const PeriksaCreated(this.periksa, this.index);
}

class PeriksaDeleted extends PeriksaState {
  final PeriksaDataModel periksa;
  final int index;

  const PeriksaDeleted(this.periksa, this.index);
}

class PeriksaUpdate extends PeriksaState {
  final PeriksaDataModel periksa;
  final PeriksaDataModel oldperiksa;
  final int index;
  final int newIndex;

  const PeriksaUpdate(this.periksa, this.oldperiksa, this.index, this.newIndex);
}
