import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/components/cardviewNotif.dart';
import 'package:tbc_app/components/reusablecomp.dart';
import 'package:tbc_app/data/Models/alarm/data_model/alarm_data_model.dart';
import 'package:tbc_app/helper/alarm_helper.dart';
import 'package:tbc_app/routes/routers.dart';
import 'package:tbc_app/theme/app_colors.dart';

import '../../../provider/alarm_provider.dart';

class ModifyAlarmScreenArg {
  final AlarmDataModel alarm;
  final int index;

  ModifyAlarmScreenArg(this.alarm, this.index);
}

class TambahPengingat extends StatefulWidget {
  final ModifyAlarmScreenArg? arg;
  const TambahPengingat({super.key, this.arg});

  @override
  State<TambahPengingat> createState() => _TambahPengingatState();
}

class _TambahPengingatState extends State<TambahPengingat> {
  TextEditingController _judulTextController = TextEditingController();
  late AlarmDataModel alarm = widget.arg?.alarm ??
      AlarmDataModel(
        judul: '',
        time: DateTime.now(),
        weekdays: [],
        id_pasien: 0,
      );
  bool get _editing => widget.arg?.alarm != null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(CheckSignInStatus()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.appBarColor,
          title: Text((_editing ? 'Edit' : 'Tambah') + ' Pengingat Obat',
              style: TextStyle(color: AppColors.appBarTextColor)),
          iconTheme: IconThemeData(color: AppColors.buttonIconColor),
          actions: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: GestureDetector(
                onTap: () async {
                  if (alarm.judul.isNotEmpty && alarm.weekdays.isNotEmpty) {
                    final model = context.read<AlarmModel>();
                    context.goNamed('pengingatObat');
                    _editing
                        ? await model.updateAlarm(alarm, widget.arg!.index)
                        : await model.addAlarm(alarm);
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
                                  Text(
                                      'Cek kembali judul dan hari alarm anda.'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('oke',
                                    style: TextStyle(
                                        color: AppColors.buttonColor)),
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
        body: Card(
          elevation: 10,
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
                          height: 100,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(child: Text('Judul')),
                                Expanded(
                                  child: Container(),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _judulTextController,
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.9)),
                                    decoration: InputDecoration.collapsed(
                                      hintText: alarm.judul.isEmpty
                                          ? ''
                                          : alarm.judul,
                                      hintStyle: TextStyle(
                                          color: Colors.black.withOpacity(0.5)),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        alarm = alarm.copyWith(
                                            judul: _judulTextController.text);
                                      });
                                    },
                                  ),
                                )
                              ]),
                        ),
                        Divider(color: AppColors.statusBarColor),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Hari alarm'),
                                Text(
                                  alarm.weekdays.isEmpty
                                      ? 'Tidak ada'
                                      : alarm.weekdays.length == 7
                                          ? 'Setiap Hari'
                                          : alarm.weekdays
                                              .map((weekday) =>
                                                  fromWeekdayToStringShort(
                                                      weekday))
                                              .join(', '),
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                              ]),
                        ),
                        Divider(color: AppColors.statusBarColor),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: Wrap(
                              children: List.generate(7, (index) => index + 1)
                                  .map((weekday) {
                                final checked =
                                    alarm.weekdays.contains(weekday);
                                return CheckboxListTile(
                                    title: Text(
                                      fromWeekdayToString(weekday),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                    ),
                                    value: checked,
                                    activeColor: AppColors.buttonColor,
                                    checkColor: AppColors.statusBarColor,
                                    onChanged: (value) {
                                      setState(() {
                                        (value ?? false)
                                            ? alarm.weekdays.add(weekday)
                                            : alarm.weekdays.remove(weekday);
                                      });
                                    });
                              }).toList(),
                            ),
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
      ),
    );
  }
}
