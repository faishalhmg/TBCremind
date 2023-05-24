import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tbc_app/data/Models/alarm/periksa_hive_storage.dart';
import 'package:tbc_app/data/Models/alarm/periksa_model/periksa_data_model.dart';
import 'package:tbc_app/helper/alarm_helper.dart';
import 'package:timezone/timezone.dart';

class PeriksaModel extends ChangeNotifier {
  final PeriksaHiveLocalStorage _storage;

  PeriksaState? state;
  List<PeriksaDataModel>? periksas;
  bool loading = true;

  PeriksaModel(PeriksaHiveLocalStorage storage) : _storage = storage {
    _storage.init().then((_) => loadPeriksas());
  }

  @override
  void dispose() {
    _storage.dispose();
    super.dispose();
  }

  void loadPeriksas() async {
    final periksas = await _storage.loadPeriksas();

    this.periksas = List.from(periksas);
    state = PeriksaLoaded(periksas);
    loading = false;
    notifyListeners();
  }

  Future<void> addPeriksa(PeriksaDataModel periksa) async {
    loading = true;
    notifyListeners();

    final newPeriksa = await _storage.addPeriksa(periksa);
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

  Future<void> deletePeriksa(PeriksaDataModel periksa, int index) async {
    loading = true;
    notifyListeners();

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

  int periksasort(periksa1, periksa2) => periksa1.time.compareTo(periksa2.time);

  Future<void> _removeScheduledPeriksa(PeriksaDataModel periksa) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (periksa.date2 != null) {
      for (var notification in pendingNotificationRequests) {
        // get grouped id
        if ((notification.id / 10).floor() == periksa.id) {
          await flutterLocalNotificationsPlugin.cancel(notification.id);
        }
      }
    } else {
      await flutterLocalNotificationsPlugin.cancel(periksa.id);
    }
  }

  Future<void> _scheduledPeriksa(PeriksaDataModel periksa) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'periksa',
      'Periksa Obat',
      channelDescription: 'Show the periksa',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('periksa'),
    );
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails(
      sound: 'alarm.aiff',
      presentSound: true,
      presentAlert: true,
      presentBadge: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      periksa.id,
      'periksa at ${fromTimeToString(periksa.time)}',
      'Ring Ring!!!',
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
