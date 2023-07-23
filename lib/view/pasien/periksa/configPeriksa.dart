import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/components/cardviewNotif.dart';
import 'package:tbc_app/data/Models/alarm/data_model/alarm_data_model.dart';
import 'package:tbc_app/data/Models/alarm/periksa_model/periksa_data_model.dart';
import 'package:tbc_app/helper/alarm_helper.dart';
import 'package:tbc_app/provider/periksa_provider.dart';
import 'package:tbc_app/routes/routers.dart';
import 'package:tbc_app/theme/app_colors.dart';

import '../../../provider/alarm_provider.dart';

class ModifyAlarmPeriksaScreenArg {
  final PeriksaDataModel alarm;
  final int index;

  ModifyAlarmPeriksaScreenArg(this.alarm, this.index);
}

class ConfigPeriksa extends StatefulWidget {
  final ModifyAlarmPeriksaScreenArg? arg;
  const ConfigPeriksa({super.key, this.arg});

  @override
  State<ConfigPeriksa> createState() => _ConfigPeriksaState();
}

class _ConfigPeriksaState extends State<ConfigPeriksa> {
  TextEditingController _lokasiTextController = TextEditingController();
  late PeriksaDataModel alarm = widget.arg?.alarm ??
      PeriksaDataModel(
        time: DateTime.now(),
        date1: DateTime.now(),
        date2: DateTime.now(),
        lokasi: '',
        id_pasien: 0,
      );
  bool get _editing => widget.arg?.alarm != null;

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: AppColors.cardcolor,
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    var formattedDate = "${now.day}-${now.month}-${now.year}";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: Text((_editing ? 'Edit' : 'Tambah') + ' Periksa Dahak',
            style: TextStyle(color: AppColors.appBarTextColor)),
        iconTheme: IconThemeData(color: AppColors.buttonIconColor),
        actions: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () async {
                if (alarm.lokasi.isNotEmpty) {
                  final model = context.read<PeriksaModel>();
                  context.goNamed('periksaDahak');
                  _editing
                      ? await model.updatePeriksa(alarm, widget.arg!.index)
                      : await model.addPeriksa(alarm);
                } else {
                  return await showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: AppColors.cardcolor,
                          title: const Text('Data Tidak boleh kosong !'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('Cek kembali lokasi periksa anda.'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('oke',
                                  style:
                                      TextStyle(color: AppColors.buttonColor)),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                          ],
                        );
                      });
                }
              },
              child: const Icon(
                Icons.save_as_rounded,
                color: AppColors.buttonIconColor,
              ),
            ),
          )
        ],
      ),
      backgroundColor: AppColors.pageBackground,
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        color: AppColors.cardcolor,
        child: BlocProvider(
          create: (context) => UserBloc()..add(CheckSignInStatus()),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              alarm = alarm.copyWith(
                  id_pasien: state is UserSignedIn ? state.userModel.id : 0);
              return Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // IconButton(
                      //     onPressed: () {},
                      //     icon: Icon(
                      //       Icons.arrow_upward_sharp,
                      //       size: 100,
                      //     ),
                      //     color: AppColors.buttonColor),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      SizedBox(
                        height: 200,
                        child: CupertinoTheme(
                          data: CupertinoThemeData(
                              brightness: Theme.of(context).brightness,
                              textTheme: CupertinoTextThemeData(
                                  dateTimePickerTextStyle: TextStyle(
                                      color: AppColors.buttonColor,
                                      fontSize: 30))),
                          child: CupertinoDatePicker(
                            use24hFormat: true,
                            mode: CupertinoDatePickerMode.time,
                            onDateTimeChanged: (value) {
                              setState(() {
                                alarm = alarm.copyWith(time: value);
                              });
                            },
                            initialDateTime: alarm.time,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // IconButton(
                      //     onPressed: () {},
                      //     icon: Icon(
                      //       Icons.arrow_downward_sharp,
                      //       color: AppColors.buttonColor,
                      //       size: 100,
                      //     )),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Periksa Sebelumnya'),
                              TextButton(
                                  onPressed: () {
                                    _showDialog(CupertinoTheme(
                                      data: CupertinoThemeData(
                                          brightness:
                                              Theme.of(context).brightness,
                                          textTheme: CupertinoTextThemeData(
                                              dateTimePickerTextStyle:
                                                  TextStyle(
                                                      color:
                                                          AppColors.buttonColor,
                                                      fontSize: 30))),
                                      child: CupertinoDatePicker(
                                        use24hFormat: true,
                                        mode: CupertinoDatePickerMode.date,
                                        initialDateTime: alarm.date1,
                                        onDateTimeChanged: (value) {
                                          setState(() {
                                            alarm =
                                                alarm.copyWith(date1: value);
                                          });
                                        },
                                      ),
                                    ));
                                  },
                                  child: Text(
                                    alarm.date2 != null
                                        ? "${alarm.date1.day}-${alarm.date1.month}-${alarm.date1.year}"
                                        : 'dd/mm/yyyy',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ]),
                      ),
                      Divider(color: AppColors.statusBarColor),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Periksa Selanjutnya'),
                              TextButton(
                                  onPressed: () {
                                    _showDialog(CupertinoTheme(
                                      data: CupertinoThemeData(
                                          brightness:
                                              Theme.of(context).brightness,
                                          textTheme: CupertinoTextThemeData(
                                              dateTimePickerTextStyle:
                                                  TextStyle(
                                                      color:
                                                          AppColors.buttonColor,
                                                      fontSize: 30))),
                                      child: CupertinoDatePicker(
                                        use24hFormat: true,
                                        mode: CupertinoDatePickerMode.date,
                                        initialDateTime: alarm.date2,
                                        onDateTimeChanged: (value) {
                                          setState(() {
                                            alarm =
                                                alarm.copyWith(date2: value);
                                          });
                                        },
                                      ),
                                    ));
                                  },
                                  child: Text(
                                    alarm.date2 != null
                                        ? "${alarm.date2!.day}-${alarm.date2!.month}-${alarm.date2!.year}"
                                        : 'dd/mm/yyyy',
                                    style: TextStyle(color: Colors.black),
                                  )),
                            ]),
                      ),
                      Divider(color: AppColors.statusBarColor),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text('Lokasi periksa')),
                              Expanded(
                                child: Container(),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _lokasiTextController,
                                  cursorColor: Colors.black,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.9)),
                                  decoration: InputDecoration.collapsed(
                                    hintText: alarm.lokasi.isEmpty
                                        ? ''
                                        : alarm.lokasi,
                                    hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      alarm = alarm.copyWith(
                                          lokasi: _lokasiTextController.text);
                                    });
                                  },
                                ),
                              ),
                            ]),
                      ),
                      Divider(color: AppColors.statusBarColor),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: []),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
