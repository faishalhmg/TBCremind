// ignore_for_file: file_names
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/components/cardButton.dart';
import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/routes/routers.dart';
import 'package:tbc_app/service/SharedPreferenceHelper.dart';

import 'package:tbc_app/theme/app_colors.dart';

ValueNotifier<bool> isAlarmRinging = ValueNotifier<bool>(false);

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

  SharedPref sharedPref = SharedPref();

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc()..add(CheckSignInStatus()),
        child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          // if (state is UserSignedIn) {

          // }
          return Scaffold(
            appBar: AppBar(
              title: const Text('TB - Remind'),
              backgroundColor: AppColors.appBarColor,
              iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
              actions: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () async {
                        flutterLocalNotificationsPlugin
                            .getActiveNotifications();
                        context.goNamed('notification');
                      },
                      child: Icon(
                        Icons.notifications,
                        size: 26.0,
                        color: Alarm.hasAlarm()
                            ? AppColors.buttonColor
                            : AppColors.appBarIconColor,
                      ),
                    )),
              ],
            ),
            drawer: Drawer(
              elevation: 10.0,
              backgroundColor: AppColors.cardcolor,
              child: ListView(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: Icon(Icons.account_circle, size: 100),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              state is UserSignedIn
                                  ? truncateWithEllipsis(
                                      20, state.userModel.nama!)
                                  : '-',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 25.0),
                            ),
                          ),
                          const Divider(
                            color: AppColors.appBarColor,
                            endIndent: 10,
                          ),
                          Text(
                            state is UserSignedIn
                                ? state.userModel.role.toString()
                                : 'Role',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14.0),
                          ),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                context.goNamed('profile');
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.edit,
                                    size: 12,
                                  ),
                                  Text(
                                    'edit profile',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                  const Divider(
                    indent: 10,
                    color: AppColors.appBarColor,
                    endIndent: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.question_mark_sharp,
                    ),
                    title:
                        const Text('Bantuan', style: TextStyle(fontSize: 18)),
                    onTap: () {
                      // Here you can give your route to navigate
                    },
                  ),
                  ListTile(
                      leading: const Icon(Icons.exit_to_app_outlined),
                      title:
                          const Text('Keluar', style: TextStyle(fontSize: 18)),
                      onTap: () async {
                        context.read<UserBloc>().add(SignOut());
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        final storage = new FlutterSecureStorage();
                        storage.deleteAll();
                        pref.remove('nikOremail');
                        pref.remove('token');
                        router.goNamed('login');
                      }),
                ],
              ),
            ),
            backgroundColor: const Color(0xFFffd275),
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.fitHeight,
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserSignedIn &&
                            state.userModel.role == "kader") {
                          return Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CardButton(
                                no: 6,
                              ),
                              CardButton(
                                no: 5,
                              )
                            ],
                          );
                        } else if (state is UserSignedIn &&
                            state.userModel.role == 'pasien') {
                          return Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              for (var x = 0; x < 6; x++) ...[
                                CardButton(
                                  no: x,
                                )
                              ],
                            ],
                          );
                        } else if (state is UserSignedIn &&
                            state.userModel.role == 'pk') {
                          return Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CardButton(
                                no: 6,
                              ),
                              CardButton(
                                no: 7,
                              )
                            ],
                          );
                        } else if (state is UserSignedIn &&
                            state.userModel.role == 'admin') {
                          return Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              CardButton(
                                no: 8,
                              ),
                              CardButton(
                                no: 9,
                              )
                            ],
                          );
                        }
                        return const SizedBox(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.buttonColor,
                              strokeWidth: 5,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
            // return Scaffold(
            //   backgroundColor: AppColors.pageBackground,
            //   body: Container(
            //     child: Center(
            //       child: Builder(builder: (context) {
            //         return RefreshProgressIndicator(
            //           color: AppColors.appBarColor,
            //           backgroundColor: AppColors.buttonColor,
            //         );
            //       }),
            //     ),
            //   ),
            // );

            ));
  }
}
