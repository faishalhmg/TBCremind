import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';

import 'package:tbc_app/components/cardviewNotif.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/theme/app_colors.dart';
import 'package:tbc_app/view/AlarmRinging.dart';

class Notifications extends StatefulWidget {
  const Notifications({
    super.key,
  });

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late List<AlarmSettings> alarms;

  static StreamSubscription? subscription;
  @override
  void initState() {
    super.initState();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
  }

  void loadAlarms() {
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ExampleAlarmRingScreen(alarmSettings: alarmSettings),
        ));
    loadAlarms();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notification'),
            backgroundColor: AppColors.appBarColor,
            iconTheme: IconThemeData(color: AppColors.buttonIconColor),
          ),
          backgroundColor: AppColors.pageBackground,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: const Text('belum ada notifikasi'),
              ),
              IconButton(
                  onPressed: () {
                    subscription ??= Alarm.ringStream.stream.listen(
                      (alarmSettings) => navigateToRingScreen(alarmSettings),
                    );
                  },
                  icon: Icon(Icons.alarm))
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              //   child: SizedBox(
              //       width: 200,
              //       height: 200,
              //       child: Column(
              //         children: [

              //           Cardview(),
              //         ],
              //       )),
              // ),
              // Divider(
              //   indent: 20,
              //   endIndent: 20,
              // )
            ],
          ),
        );
      },
    );
  }
}
