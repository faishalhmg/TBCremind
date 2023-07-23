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
                        context.replaceNamed('editkeluarga');
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'Data Keluarga',
                            style: TextStyle(fontSize: 20),
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
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
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
                                                    child: Row(
                                                  children: [
                                                    Text('Nama '),
                                                    Text(keluargaList[index]
                                                                ["jenis"]
                                                            .toString()
                                                            .contains("null")
                                                        ? ''
                                                        : keluargaList[index]
                                                                ["jenis"]
                                                            .toString()),
                                                  ],
                                                )),
                                                Expanded(
                                                    child: Text(keluargaList[
                                                                index]['nama']
                                                            .toString()
                                                            .contains("null")
                                                        ? ''
                                                        : keluargaList[index]
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
                                                    child: Text(keluargaList[
                                                                        index]
                                                                    ['usia']
                                                                .toString() !=
                                                            'null'
                                                        ? keluargaList[index]
                                                            ['usia']
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
                                                    child: Text(keluargaList[
                                                                        index]
                                                                    ['riwayat']
                                                                .toString() !=
                                                            'null'
                                                        ? keluargaList[index]
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
