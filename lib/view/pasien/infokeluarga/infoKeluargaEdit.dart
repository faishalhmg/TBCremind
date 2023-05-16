import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  Keluarga? createKeluarga;
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
  Widget cardviewdetail() {
    return BlocBuilder<KeluargaBloc, KeluargaState>(builder: (context, state) {
      if (state is KeluargaLoadingState) {
        return const Center(child: CircularProgressIndicator());
      }
      if (state is KeluargaLoadedState) {
        List keluargaList = state.keluarga;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: keluargaList.length,
          itemBuilder: (context, index) {
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
                            Expanded(
                                child: Row(
                              children: [
                                const Text('nama '),
                                Expanded(
                                    child: DropdownButton<String>(
                                  icon: Icon(Icons.arrow_downward_sharp),
                                  dropdownColor: AppColors.cardcolor,
                                  underline: Container(
                                    height: 0,
                                    color: Colors.white,
                                  ),
                                  hint: Text(keluargaList[index]['nama']),
                                  value: selectedValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value as String;
                                    });
                                    _jeinsTextController.text = value!;
                                  },
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                )),
                              ],
                            )),
                            Expanded(
                                child: reusableTextField1(
                                    keluargaList[index]['nama'],
                                    _namaTextController)),
                          ],
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
                            const Expanded(child: Text('Usia')),
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                    child: reusableTextField1(
                                        keluargaList[index]['usia'].toString(),
                                        _usiaTextController)),
                                const Text(" Tahun"),
                              ],
                            )),
                          ],
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
                            Expanded(child: const Text('Riwayat penyakit')),
                            Expanded(
                                child: reusableTextField1(
                                    keluargaList[index]['riwayat'],
                                    _riwayatTextController)),
                          ],
                        ),
                      ),
                      Divider(
                        indent: 10,
                        endIndent: 10,
                        color: AppColors.appBarColor,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }
      if (state is KeluargaErrorState) {
        return const Center(
          child: Text('error'),
        );
      }
      return Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<KeluargaBloc>(
            create: (BuildContext context) => KeluargaBloc(DioClient())),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Edit Informasi Keluarga"),
              backgroundColor: AppColors.appBarColor,
              iconTheme: IconThemeData(color: AppColors.buttonIconColor),
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
              child: BlocProvider(
                create: (context) => KeluargaBloc(DioClient())
                  ..add(LoadKeluargaEvent(
                      id: state is UserSignedIn ? state.userModel.id! : 0)),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Data Keluarga',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(child: cardviewdetail()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
