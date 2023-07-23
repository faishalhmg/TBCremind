// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/keluarga_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/quiz/hasil_quiz.dart';
import 'package:tbc_app/data/cardMenuTileMap.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

// ignore: camel_case_types
class hasilKuis extends StatefulWidget {
  int? id;
  hasilKuis({
    this.id,
    super.key,
  });

  @override
  State<hasilKuis> createState() => _hasilKuisState();
}

class _hasilKuisState extends State<hasilKuis> {
  final DioClient _dioClient = DioClient();
  List hasil = [];
  int? id_pasien;
  @override
  void initState() {
    getHasil();
    super.initState();
  }

  void getHasil() async {
    final data = await _dioClient.getHasil(widget.id!);
    setState(() {
      hasil = data;
    });
  }

  Widget cardviewdhasil() {
    return BlocProvider(
      create: (context) => UserBloc()..add(CheckSignInStatus()),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UserSignedIn) {
            return Card(
              color: AppColors.cardcolor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0)),
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(child: Text('name')),
                            Expanded(
                                child: Text(state.userModel.nama.toString())),
                          ],
                        ),
                      ),
                      const Divider(
                        indent: 10,
                        endIndent: 10,
                        color: AppColors.appBarColor,
                      ),
                      BlocProvider(
                        create: (context) => KeluargaBloc(DioClient())
                          ..add(LoadKeluargaEvent(id: (state.userModel.id!))),
                        child: BlocBuilder<KeluargaBloc, KeluargaState>(
                          builder: (context, state) {
                            if (state is KeluargaLoadingState) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (state is KeluargaLoadedState) {
                              List keluargaList = state.keluarga;
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                        child: Text('Jumlah keluarga')),
                                    Expanded(
                                        child: Text(
                                            keluargaList.length.toString())),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      const Divider(
                        indent: 10,
                        endIndent: 10,
                        color: AppColors.appBarColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(child: Text('Hasil Kuis Pola TB')),
                            Expanded(
                                child: Text(
                                    '${(1 / ('0'.allMatches(hasil[hasil.indexWhere((element) => element['id_pasien'] == state.userModel.id.toString())]['hasil'].toString()).length + '1'.allMatches(hasil[hasil.indexWhere((element) => element['id_pasien'] == state.userModel.id.toString())]['hasil'].toString().replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) {
                                          return int.parse(e);
                                        }).toString()).length)) * ('1'.allMatches(hasil[hasil.indexWhere((element) => element['id_pasien'] == state.userModel.id.toString())]['hasil'].toString()).length) * 100}%')),
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
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cardmenuDetailsTile[1]['title']),
        backgroundColor: AppColors.appBarColor,
        iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
      ),
      backgroundColor: AppColors.pageBackground,
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Text(
            'Hasil Kuisioner',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: cardviewdhasil(),
          )
        ],
      ),
    );
  }
}
