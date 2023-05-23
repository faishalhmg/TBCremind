import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tbc_app/components/cardviewNotif.dart';
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
  late AlarmDataModel alarm = widget.arg?.alarm ??
      AlarmDataModel(
        time: DateTime.now(),
        weekdays: [],
      );
  bool get _editing => widget.arg?.alarm != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                final model = context.read<AlarmModel>();
                context.goNamed('pengingatObat');
                _editing
                    ? await model.updateAlarm(alarm, widget.arg!.index)
                    : await model.addAlarm(alarm);
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
        child: Padding(
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
                                color: AppColors.buttonColor, fontSize: 30))),
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
                      children: [Text('Judul'), Text('Judul')]),
                ),
                Divider(color: AppColors.statusBarColor),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hari alarm'),
                        Text(
                          alarm.weekdays.isEmpty
                              ? 'Tidak ada'
                              : alarm.weekdays.length == 7
                                  ? 'Setiap Hari'
                                  : alarm.weekdays
                                      .map((weekday) =>
                                          fromWeekdayToStringShort(weekday))
                                      .join(', '),
                          maxLines: 1,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
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
                      children:
                          List.generate(7, (index) => index + 1).map((weekday) {
                        final checked = alarm.weekdays.contains(weekday);
                        return CheckboxListTile(
                            title: Text(
                              fromWeekdayToString(weekday),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
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
        ),
      ),
    );
  }
}
