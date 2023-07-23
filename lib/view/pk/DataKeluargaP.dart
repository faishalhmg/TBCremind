import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/bloc/efek_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/keluarga_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/pasien_bloc.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

class DataKeluargaP extends StatefulWidget {
  const DataKeluargaP({super.key});

  @override
  State<DataKeluargaP> createState() => _DataKeluargaPState();
}

bool isSearchOpen = false;
String searchQuery = '';

class _DataKeluargaPState extends State<DataKeluargaP> {
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
              padding: EdgeInsets.fromLTRB(40, 3, 0, 0),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    isSearchOpen = !isSearchOpen;
                  });
                },
              ),
            ),
            if (isSearchOpen)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(40, 3, 0, 0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
        backgroundColor: AppColors.pageBackground,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocProvider(
            create: (context) =>
                PasienBloc(DioClient())..add(const LoadPasienEvent()),
            child: BlocBuilder<PasienBloc, PasienState>(
              builder: (context, state) {
                if (state is PasienLoadingState) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: AppColors.statusBarColor,
                  ));
                }
                if (state is UserPasienState) {
                  List pasienList = state.userModel
                      .where((item) => item['role'] == 'pasien')
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: pasienList.length,
                    itemBuilder: (context, index) {
                      if (searchQuery.isNotEmpty &&
                          !pasienList[index]['nama']
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase())) {
                        return const SizedBox.shrink();
                      }
                      return BlocProvider(
                        create: (context) => KeluargaBloc(DioClient())
                          ..add(LoadedKeluargaEvent()),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                context
                                    .goNamed("dataKeluargaPFull", queryParams: {
                                  'email':
                                      pasienList[index]['email'].toString(),
                                  'id': pasienList[index]['id'].toString()
                                });
                              },
                              child: Card(
                                color: AppColors.cardcolor,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.account_circle_rounded,
                                          size: 100),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            truncateWithEllipsis(
                                                19,
                                                pasienList[index]['nama']
                                                    .toString()),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          BlocBuilder<KeluargaBloc,
                                              KeluargaState>(
                                            builder: (context, state) {
                                              if (state
                                                  is KeluargaLoadedState1) {
                                                List keluargalist =
                                                    state.keluarga;
                                                if (keluargalist.isNotEmpty) {
                                                  var jumlah;
                                                  for (int x = 0;
                                                      x < keluargalist.length;
                                                      x++) {
                                                    jumlah = keluargalist.where(
                                                        (element) =>
                                                            element[
                                                                'id_pasien'] ==
                                                            pasienList[index]
                                                                ['id']);
                                                  }
                                                  return Text(
                                                      "Jumlah Keluarga :" +
                                                          jumlah.length
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15));
                                                } else {
                                                  return Text(
                                                      'Belum ada Effek Obat',
                                                      style: TextStyle(
                                                          fontSize: 15));
                                                }
                                              }
                                              return Text('efek obat',
                                                  style:
                                                      TextStyle(fontSize: 20));
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              indent: 10,
                              endIndent: 10,
                              thickness: 1,
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ));
  }
}
