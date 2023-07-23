import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/bloc/edukasi_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/efek_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/pasien_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

class DataPasienFull extends StatelessWidget {
  final String? email;
  final String? id;
  const DataPasienFull({super.key, this.email, this.id});

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
                        create: (context) => EfekBloc(DioClient())
                          ..add(LoadEfekEvent(id: int.parse(id!))),
                        child: BlocBuilder<EfekBloc, EfekState>(
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
                            if (state is EfekLoadedState) {
                              List pasienList = state.efek;
                              if (pasienList.isNotEmpty) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: pasienList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        context.goNamed('dataEPFull',
                                            queryParams: {
                                              'awal': pasienList[index]['awal']
                                                  .toString(),
                                              'akhir': pasienList[index]
                                                      ['akhir']
                                                  .toString(),
                                              'dosis': pasienList[index]
                                                      ['dosis']
                                                  .toString(),
                                              'efek': pasienList[index]
                                                      ['efeksamping']
                                                  .toString()
                                            });
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
                                                      Text('Tanggal Awal :'),
                                                      Text(pasienList[index]
                                                              ['awal']
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
                                                      Text('Tanggal Akhir :'),
                                                      Text(pasienList[index]
                                                              ['akhir']
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
                                                      Text('Dosis :'),
                                                      Text(pasienList[index]
                                                              ['dosis']
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
                                                      Text('Efek Obat :'),
                                                      Text(pasienList[index][
                                                                  'efeksamping']
                                                              .toString()
                                                              .contains('null')
                                                          ? 'belum ada effek'
                                                          : truncateWithEllipsis(
                                                              35,
                                                              pasienList[index][
                                                                      'efeksamping']
                                                                  .toString()))
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
