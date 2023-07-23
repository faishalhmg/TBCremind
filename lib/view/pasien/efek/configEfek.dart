import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/bloc/efek_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/efek/efek.dart';
import 'package:tbc_app/data/Models/efek/efek_data_model.dart';
import 'package:tbc_app/provider/efek_provider.dart';
import 'package:tbc_app/theme/app_colors.dart';

class ModifyEfekScreenArg {
  final EfekDataModel alarm;
  final int index;

  ModifyEfekScreenArg(this.alarm, this.index);
}

class ConfigEfek extends StatefulWidget {
  final ModifyEfekScreenArg? arg;
  const ConfigEfek({super.key, this.arg});

  @override
  State<ConfigEfek> createState() => _ConfigEfekState();
}

class _ConfigEfekState extends State<ConfigEfek> {
  TextEditingController _judulTextController = TextEditingController();
  TextEditingController _dosisTextController = TextEditingController();
  TextEditingController _efekTextController = TextEditingController();
  late EfekDataModel alarm = widget.arg?.alarm ??
      EfekDataModel(
        judul: '',
        p_awal: DateTime.now(),
        p_akhir: DateTime.now(),
        dosis: '',
        lupa: null,
        efek: '',
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
        title: Text((_editing ? 'Edit' : 'Tambah') + ' Efek Obat',
            style: TextStyle(color: AppColors.appBarTextColor)),
        iconTheme: IconThemeData(color: AppColors.buttonIconColor),
        actions: [
          Padding(
            padding: EdgeInsets.all(20.0),
            child: GestureDetector(
              onTap: () async {
                if (alarm.judul!.isNotEmpty &&
                    alarm.dosis.isNotEmpty &&
                    alarm.efek.isNotEmpty) {
                  final model = context.read<EfekModel>();
                  context.goNamed('efekObat');
                  _editing
                      ? await model.updateEfek(alarm, widget.arg!.index)
                      : await model.addEfek(alarm);
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
                                    'Cek kembali judul, dosis pakai dan efek samping Obat anda.'),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services,
              color: AppColors.buttonColor,
              size: 200,
            ),
            Card(
              elevation: 50,
              color: AppColors.cardcolor,
              child: BlocProvider(
                create: (context) => UserBloc()..add(CheckSignInStatus()),
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    alarm = alarm.copyWith(
                        id_pasien:
                            state is UserSignedIn ? state.userModel.id : 0);
                    return Padding(
                      padding: const EdgeInsets.all(40),
                      child: SizedBox(
                        height: 380,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        child: Text('Judul Catatan')),
                                    Expanded(
                                      child: TextField(
                                        controller: _judulTextController,
                                        cursorColor: Colors.black,
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.9)),
                                        decoration: InputDecoration.collapsed(
                                          hintText: alarm.judul!.isEmpty
                                              ? ''
                                              : alarm.judul,
                                          hintStyle: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            alarm = alarm.copyWith(
                                                judul:
                                                    _judulTextController.text);
                                          });
                                        },
                                      ),
                                    )
                                  ]),
                            ),
                            Divider(color: AppColors.statusBarColor),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Ambil Sebelumnya'),
                                  Text(alarm.p_awal != null
                                      ? "${alarm.p_awal.day}-${alarm.p_awal.month}-${alarm.p_awal.year}"
                                      : formattedDate),
                                ]),
                            Divider(color: AppColors.statusBarColor),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Ambil Selanjutnya'),
                                  TextButton(
                                      onPressed: () {
                                        _showDialog(CupertinoTheme(
                                          data: CupertinoThemeData(
                                              brightness:
                                                  Theme.of(context).brightness,
                                              textTheme: CupertinoTextThemeData(
                                                  dateTimePickerTextStyle:
                                                      TextStyle(
                                                          color: AppColors
                                                              .buttonColor,
                                                          fontSize: 30))),
                                          child: CupertinoDatePicker(
                                            use24hFormat: true,
                                            mode: CupertinoDatePickerMode.date,
                                            initialDateTime: alarm.p_akhir,
                                            onDateTimeChanged: (value) {
                                              setState(() {
                                                alarm = alarm.copyWith(
                                                    p_akhir: value);
                                              });
                                            },
                                          ),
                                        ));
                                      },
                                      child: Text(
                                        alarm.p_akhir != null
                                            ? "${alarm.p_akhir!.day}-${alarm.p_akhir!.month}-${alarm.p_akhir!.year}"
                                            : 'dd-mm-yyyy',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ]),
                            Divider(color: AppColors.statusBarColor),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text('Dosis pakai obat')),
                                    Expanded(
                                      child: TextField(
                                        controller: _dosisTextController,
                                        cursorColor: Colors.black,
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.9)),
                                        decoration: InputDecoration.collapsed(
                                          hintText: alarm.dosis.isEmpty
                                              ? ''
                                              : alarm.dosis,
                                          hintStyle: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            alarm = alarm.copyWith(
                                                dosis:
                                                    _dosisTextController.text);
                                          });
                                        },
                                      ),
                                    )
                                  ]),
                            ),
                            Divider(color: AppColors.statusBarColor),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Lupa pakai obat'),
                                  TextButton(
                                      onPressed: () {
                                        _showDialog(CupertinoTheme(
                                          data: CupertinoThemeData(
                                              brightness:
                                                  Theme.of(context).brightness,
                                              textTheme: CupertinoTextThemeData(
                                                  dateTimePickerTextStyle:
                                                      TextStyle(
                                                          color: AppColors
                                                              .buttonColor,
                                                          fontSize: 30))),
                                          child: CupertinoDatePicker(
                                            use24hFormat: true,
                                            mode: CupertinoDatePickerMode.date,
                                            initialDateTime: alarm.lupa,
                                            onDateTimeChanged: (value) {
                                              setState(() {
                                                alarm =
                                                    alarm.copyWith(lupa: value);
                                              });
                                            },
                                          ),
                                        ));
                                      },
                                      child: Text(
                                        _editing
                                            ? '${alarm.lupa!.day}-${alarm.lupa!.month}-${alarm.lupa!.year}'
                                            : alarm.lupa != null
                                                ? '${alarm.lupa!.day}-${alarm.lupa!.month}-${alarm.lupa!.year}'
                                                : 'dd-mm-yyyy',
                                        style: TextStyle(color: Colors.black),
                                      )),
                                ]),
                            Divider(color: AppColors.statusBarColor),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text('Efek samping')),
                                    Expanded(
                                      child: TextField(
                                        controller: _efekTextController,
                                        cursorColor: Colors.black,
                                        style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.9)),
                                        decoration: InputDecoration.collapsed(
                                          hintText: alarm.efek.isEmpty
                                              ? ''
                                              : alarm.efek,
                                          hintStyle: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            alarm = alarm.copyWith(
                                                efek: _efekTextController.text);
                                          });
                                        },
                                      ),
                                    )
                                  ]),
                            ),
                            Divider(color: AppColors.statusBarColor),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
