import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbc_app/bloc/bloc/bloc/keluarga_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/keluarga/keluarga.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/service/SharedPreferenceHelper.dart';

import '../../../data/cardMenuTileMap.dart';
import '../../../theme/app_colors.dart';

class infoKeluarga extends StatelessWidget {
  infoKeluarga({super.key});

  final DioClient _dioClient = DioClient();

  SharedPref sharedPref = SharedPref();

  List keluarga = [];
  List keluargaEdit = [];

  String _errorMessage = '';

  Keluarga? createKeluarga;

  String? error;

  String get errorMessage => _errorMessage;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
      return BlocProvider(
        create: (context) => UserBloc()..add(CheckSignInStatus()),
        child: Scaffold(
            appBar: AppBar(
              title: Text(cardmenuDetailsTile[0]['title']),
              backgroundColor: AppColors.appBarColor,
              iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
              actions: [
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        context.goNamed('editkeluarga');
                      },
                      child: const Icon(
                        Icons.edit,
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
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Data Keluarga',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                              return IconButton(
                                  onPressed: () async {
                                    context.read<KeluargaBloc>().add(
                                        AddKeluargaEvent(
                                            nama: '',
                                            jenis: '',
                                            usia: 0,
                                            riwayat: '',
                                            id_pasien: state is UserSignedIn
                                                ? state.userModel.id!
                                                : 0));
                                  },
                                  icon: const Icon(
                                    Icons.add_circle_outline_sharp,
                                    color: AppColors.buttonIconColor,
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
                                              keluargaList[index]['id_pasien']),
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
                                child: Card(
                                  color: AppColors.cardcolor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3.0)),
                                  child: SizedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 10, 15, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                    child: Text('Nama ' +
                                                        keluargaList[index]
                                                            ['jenis'])),
                                                Expanded(
                                                    child: Text(
                                                        keluargaList[index]
                                                            ['nama'])),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            indent: 10,
                                            endIndent: 10,
                                            color: AppColors.appBarColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
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
                                                    child: Text(
                                                        keluargaList[index]
                                                            ['usia'])),
                                              ],
                                            ),
                                          ),
                                          const Divider(
                                            indent: 10,
                                            endIndent: 10,
                                            color: AppColors.appBarColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
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
                                                    child: Text(
                                                        keluargaList[index]
                                                            ['riwayat'])),
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
                              );
                            },
                          );
                        }
                        if (state is KeluargaErrorState) {
                          return Center(
                            child: AlertDialog(
                              backgroundColor: AppColors.appBarColor,
                              title: Text(
                                  'error terjadi kesalahan! silahkan kembali login'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text(
                                    'Approve',
                                    style:
                                        TextStyle(color: AppColors.buttonColor),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
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
