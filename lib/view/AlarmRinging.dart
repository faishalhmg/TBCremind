import 'package:alarm/alarm.dart';

import 'package:flutter/material.dart';
import 'package:tbc_app/theme/app_colors.dart';

class ExampleAlarmRingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;

  const ExampleAlarmRingScreen({Key? key, required this.alarmSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "You alarm is ringing...",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                const Text("🔔", style: TextStyle(fontSize: 150)),
                Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.fitHeight,
                  width: 100,
                  height: 100,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    final now = DateTime.now();
                    Alarm.set(
                      alarmSettings: alarmSettings.copyWith(
                        dateTime: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                          0,
                          0,
                        ).add(const Duration(minutes: 1)),
                      ),
                    ).then((_) => Navigator.pop(context));
                  },
                  child: Text(
                    "Snooze",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    final now = DateTime.now();
                    Alarm.stop(alarmSettings.id)
                        .then((value) => Alarm.set(
                              alarmSettings: alarmSettings.copyWith(
                                  id: alarmSettings.id,
                                  dateTime: DateTime(
                                    now.year,
                                    now.month,
                                    alarmSettings.dateTime.day + 7,
                                    alarmSettings.dateTime.hour,
                                    alarmSettings.dateTime.minute,
                                    0,
                                    0,
                                  ),
                                  assetAudioPath: 'assets/alarm.mp3',
                                  loopAudio: true,
                                  vibrate: true,
                                  fadeDuration: 3.0,
                                  notificationTitle:
                                      'Alarm at ${alarmSettings.dateTime.hour.toString()} : ${alarmSettings.dateTime.minute.toString()}',
                                  notificationBody:
                                      'Ring Ring!!! Waktunya Minum Obat!',
                                  enableNotificationOnKill: true,
                                  stopOnNotificationOpen: false),
                            ))
                        .then((_) => Navigator.pop(context));
                  },
                  child: Text(
                    "Stop",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
