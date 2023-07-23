import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/bloc/edukasi_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/efek_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/keluarga_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/pasien_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

class DataKeluargaPFull extends StatelessWidget {
  final String? email;
  final String? id;
  const DataKeluargaPFull({super.key, this.email, this.id});

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Data Pasien'),
          backgroundColor: AppColors.appBarColor,
          iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
            ),
          ],
        ),
        backgroundColor: AppColors.pageBackground,
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Wrap(
              children: [
                BlocProvider(
                  create: (context) => PasienBloc(DioClient())
                    ..add(LoadedPasienEvent(nikOremail: email!)),
                  child: BlocBuilder<PasienBloc, PasienState>(
                    builder: (context, state) {
                      if (state is PasienLoadingState) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            height:
                                MediaQuery.of(context).size.height * (1 / 3),
                            child: const Center(
                                child: CircularProgressIndicator(
                              color: AppColors.statusBarColor,
                            )));
                      }
                      if (state is LoadPasienState) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * (1 / 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(Icons.account_circle_rounded,
                                    size: MediaQuery.of(context).size.height *
                                        (1 / 3) *
                                        (7 / 10)),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height *
                                    (1 / 3) *
                                    (1 / 10),
                                child: Text(
                                  state is LoadPasienState
                                      ? state.userModel.nama!.toString()
                                      : "(Nama Pasien)",
                                  style: TextStyle(),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (2 / 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Riwayat Pasien',
                        style: TextStyle(fontSize: 20),
                      ),
                      BlocProvider(
                        create: (context) => KeluargaBloc(DioClient())
                          ..add(LoadKeluargaEvent(id: int.parse(id!))),
                        child: BlocBuilder<KeluargaBloc, KeluargaState>(
                          builder: (context, state) {
                            if (state is EfekLoadingState) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height *
                                    (1 / 3),
                                child: const Center(
                                    child: CircularProgressIndicator(
                                  color: AppColors.statusBarColor,
                                )),
                              );
                            }
                            if (state is KeluargaLoadedState) {
                              List keluargaList = state.keluarga;
                              if (keluargaList.isNotEmpty) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: keluargaList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        null;
                                      },
                                      child: Column(
                                        children: [
                                          Card(
                                            color: AppColors.cardcolor,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 8, 2),
                                                  child: Row(
                                                    children: [
                                                      Text('Nama : '),
                                                      Text(keluargaList[index]
                                                              ['nama']
                                                          .toString())
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 8, 2),
                                                  child: Row(
                                                    children: [
                                                      Text('Usia : '),
                                                      Text(keluargaList[index]
                                                              ['usia']
                                                          .toString())
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 8, 2),
                                                  child: Row(
                                                    children: [
                                                      Text('Riwayat :'),
                                                      Text(keluargaList[index]
                                                              ['riwayat']
                                                          .toString())
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 8, 8, 8),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          'Jenis anggota keluarga :'),
                                                      Text(keluargaList[index]
                                                              ['jenis']
                                                          .toString())
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Divider(),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height *
                                      (1 / 3),
                                  child: Center(
                                    child: Text('Belum menambahkan efek obat'),
                                  ),
                                );
                              }
                            }
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}
