import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:provider/provider.dart';
import 'package:tbc_app/data/Models/alarm/alarm_hive_storage.dart';
import 'package:tbc_app/provider/alarm_provider.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

import 'package:tbc_app/bloc/bloc/bloc/keluarga_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/dio/DioClient.dart';

import 'package:tbc_app/routes/routers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    _setUpLocalNotification();
    _requestPermissions();
    super.initState();
  }

  void _requestPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _setUpLocalNotification() async {
    await _configureLocalTimeZone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(title ?? ''),
                  content: Text(body ?? ''),
                ),
              );
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
    });
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    setLocalLocation(getLocation(timeZoneName));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserBloc()
            ..add(
              CheckSignInStatus(),
            ),
        ),
        BlocProvider(
          create: (context) => KeluargaBloc(DioClient()),
        ),
        ChangeNotifierProvider(
          create: (context) => AlarmModel(
            const AlarmsHiveLocalStorage(),
          ),
        )
      ],
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserSignedIn) {
            router.replaceNamed('home');
          } else if (state is UserSignedOut) {
            router.replaceNamed('login');
          }
        },
        child: MaterialApp.router(
          // routerDelegate: router.routerDelegate,
          // routeInformationParser: router.routeInformationParser,
          // routeInformationProvider: router.routeInformationProvider,
          debugShowCheckedModeBanner: false,
          title: 'TBC - APP',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
