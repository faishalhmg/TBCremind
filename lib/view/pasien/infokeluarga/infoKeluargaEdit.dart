import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbc_app/bloc/bloc/bloc/keluarga_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/components/reusablecomp.dart';
import 'package:tbc_app/data/Models/keluarga/keluarga.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/service/SharedPreferenceHelper.dart';

import '../../../data/cardMenuTileMap.dart';
import '../../../theme/app_colors.dart';

class InfoKeluargaEdit extends StatefulWidget {
  InfoKeluargaEdit({super.key});

  @override
  State<InfoKeluargaEdit> createState() => _InfoKeluargaEditState();
}

class _InfoKeluargaEditState extends State<InfoKeluargaEdit> {
  final DioClient _dioClient = DioClient();
  SharedPref sharedPref = SharedPref();
  // List keluarga = [];
  String _errorMessage = '';

  String? error;
  String get errorMessage => _errorMessage;
  final TextEditingController _namaTextController = TextEditingController();
  final TextEditingController _usiaTextController = TextEditingController();
  final TextEditingController _riwayatTextController = TextEditingController();
  final TextEditingController _jeinsTextController = TextEditingController();
  String? selectedValue;
  static const List<String> list = <String>[
    'Ayah',
    'Ibu',
    'Anak',
    'Istri',
    'suami'
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      return BlocProvider(
        create: (context) => UserBloc()..add(CheckSignInStatus()),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Edit Informasi Keluarga"),
              backgroundColor: AppColors.appBarColor,
              iconTheme: IconThemeData(color: AppColors.buttonIconColor),
              leading: BackButton(
                onPressed: () {
                  context.replaceNamed('infoKeluarga');
                },
              ),
              actions: <Widget>[
                Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        context.go("/home/dataKeluarga/infoKeluarga");
                      },
                      child: const Icon(
                        Icons.save_sharp,
                        size: 26.0,
                        color: AppColors.appBarIconColor,
                      ),
                    )),
              ],
            ),
            backgroundColor: AppColors.pageBackground,
            body: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => KeluargaBloc(DioClient())
                        ..add(
                          LoadKeluargaEvent(
                              id: state is UserSignedIn
                                  ? state.userModel.id!
                                  : 0),
                        ),
                    ),
                    BlocProvider(
                      create: (context) => UserBloc()..add(CheckSignInStatus()),
                    ),
                  ],
                  child: Column(children: <Widget>[
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Data Keluarga',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 170,
                          ),
                          BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                              return IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                      useSafeArea: false,
                                      context: context,
                                      barrierDismissible:
                                          true, // user must tap button!
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (context, setStateSB) =>
                                              Dialog(
                                            child: SizedBox(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 10, 10),
                                                child: Wrap(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            child: Row(
                                                          children: [
                                                            const Text('nama '),
                                                            Expanded(
                                                                child:
                                                                    DropdownButton<
                                                                        String>(
                                                              icon: Icon(Icons
                                                                  .arrow_downward_sharp),
                                                              dropdownColor:
                                                                  AppColors
                                                                      .cardcolor,
                                                              underline:
                                                                  Container(
                                                                height: 0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              hint: Text(
                                                                  "Jenis Anggota"),
                                                              value:
                                                                  selectedValue,
                                                              onChanged:
                                                                  (value) {
                                                                setStateSB(() {
                                                                  selectedValue =
                                                                      value
                                                                          as String;
                                                                });
                                                                _jeinsTextController
                                                                        .text =
                                                                    value!;
                                                              },
                                                              items: list.map<
                                                                  DropdownMenuItem<
                                                                      String>>((String
                                                                  value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child: Text(
                                                                      value),
                                                                );
                                                              }).toList(),
                                                            )),
                                                          ],
                                                        )),
                                                        Expanded(
                                                            child: reusableTextField1(
                                                                'Nama',
                                                                _namaTextController)),
                                                      ],
                                                    ),
                                                    const Divider(
                                                      indent: 10,
                                                      endIndent: 10,
                                                      color:
                                                          AppColors.appBarColor,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Expanded(
                                                            child:
                                                                Text('Usia')),
                                                        Expanded(
                                                            child: Row(
                                                          children: [
                                                            Expanded(
                                                                child: reusableTextField3(
                                                                    'Usia',
                                                                    _usiaTextController)),
                                                            const Text(
                                                                " Tahun"),
                                                          ],
                                                        )),
                                                      ],
                                                    ),
                                                    const Divider(
                                                      indent: 10,
                                                      endIndent: 10,
                                                      color:
                                                          AppColors.appBarColor,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                            child: const Text(
                                                                'Riwayat penyakit')),
                                                        Expanded(
                                                            child: reusableTextField1(
                                                                'riwayat penyakit',
                                                                _riwayatTextController)),
                                                      ],
                                                    ),
                                                    Divider(
                                                      indent: 10,
                                                      endIndent: 10,
                                                      color:
                                                          AppColors.appBarColor,
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          if (_jeinsTextController.text == '' ||
                                                              _namaTextController
                                                                      .text ==
                                                                  '' ||
                                                              _usiaTextController
                                                                      .text ==
                                                                  '' ||
                                                              _riwayatTextController
                                                                      .text ==
                                                                  '') {
                                                            setState(() {
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              3),
                                                                  content: Text(
                                                                      "Semua data harus dimasukan!"),
                                                                ),
                                                              );
                                                            });
                                                          } else {
                                                            context.pushReplacementNamed(
                                                                'editkeluarga');
                                                          }
                                                        },
                                                        child: Text("save"))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add_circle_sharp,
                                    color: AppColors.buttonColor,
                                    size: 30,
                                  ));
                            },
                          ),
                        ]),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: BlocBuilder<KeluargaBloc, KeluargaState>(
                          builder: (context, state) {
                        if (state is KeluargaLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is KeluargaLoadedState) {
                          List keluargaList = state.keluarga;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: keluargaList.length,
                            itemBuilder: (context, index) {
                              final datakeluarga = keluargaList[index]['id'];
                              return Dismissible(
                                  key: Key(datakeluarga),
                                  onDismissed: (direction) {
                                    context.read<KeluargaBloc>().add(
                                        DeleteKeluargaEvent(
                                            id_pasien: int.parse(
                                                keluargaList[index]
                                                    ['id_pasien']),
                                            id: int.parse(
                                                keluargaList[index]['id'])));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            duration: Duration(seconds: 3),
                                            content: Text(
                                                'Data Keluarga Deleted (untuk sekarang fungsi delete dan update tidak bisa pada server)')));
                                  },
                                  background: Container(
                                    color: AppColors.buttonIconColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Card(
                                      color: AppColors.cardcolor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3.0)),
                                      child: SizedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 10, 15, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                        child: Row(
                                                      children: [
                                                        Text('Nama '),
                                                        Text(keluargaList[index]
                                                                    ["jenis"]
                                                                .toString()
                                                                .contains(
                                                                    "null")
                                                            ? ''
                                                            : keluargaList[
                                                                        index]
                                                                    ["jenis"]
                                                                .toString()),
                                                      ],
                                                    )),
                                                    Expanded(
                                                        child: Text(keluargaList[
                                                                        index]
                                                                    ['nama']
                                                                .toString()
                                                                .contains(
                                                                    "null")
                                                            ? ''
                                                            : keluargaList[
                                                                        index]
                                                                    ['nama']
                                                                .toString())),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                indent: 10,
                                                endIndent: 10,
                                                color: AppColors.appBarColor,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 10, 15, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Expanded(
                                                        child: Text('Usia')),
                                                    Expanded(
                                                        child: Text(keluargaList[
                                                                            index]
                                                                        ['usia']
                                                                    .toString() !=
                                                                'null'
                                                            ? keluargaList[
                                                                index]['usia']
                                                            : '')),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                indent: 10,
                                                endIndent: 10,
                                                color: AppColors.appBarColor,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 10, 15, 0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Expanded(
                                                        child: Text(
                                                            'Riwayat penyakit')),
                                                    Expanded(
                                                        child: Text(keluargaList[
                                                                            index]
                                                                        [
                                                                        'riwayat']
                                                                    .toString() !=
                                                                'null'
                                                            ? keluargaList[
                                                                    index]
                                                                ['riwayat']
                                                            : '')),
                                                  ],
                                                ),
                                              ),
                                              const Divider(
                                                indent: 10,
                                                endIndent: 10,
                                                color: AppColors.appBarColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ));
                            },
                          );
                        }
                        if (state is KeluargaErrorState) {
                          return const Center(
                            child: Text('error'),
                          );
                        }
                        return Container();
                      }),
                    )
                  ]),
                ))),
      );
    });
  }
}
