import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';

import 'package:tbc_app/components/reusablecomp.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/service/SharedPreferenceHelper.dart';
import 'package:tbc_app/theme/app_colors.dart';

import '../../data/cardMenuTileMap.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final DioClient _dioClient = DioClient();
  SharedPref sharedPref = SharedPref();
  TextEditingController _jkTextController = TextEditingController();
  TextEditingController _alamatTextController = TextEditingController();
  TextEditingController _usiaTextController = TextEditingController();
  TextEditingController _nohpTextController = TextEditingController();
  TextEditingController _goldarTextController = TextEditingController();
  TextEditingController _bbTextController = TextEditingController();
  TextEditingController _kadertbTextController = TextEditingController();
  TextEditingController _pmoTextController = TextEditingController();
  TextEditingController _petkesehatanTextController = TextEditingController();
  String selectedValue = "Laki-Laki";
  static const List<String> list = <String>['Laki-Laki', 'Perempuan'];

  Widget cardviewprofil() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        selectedValue =
            state is UserSignedIn ? state.userModel.jk.toString() : "Laki-Laki";
        return Card(
          color: AppColors.cardcolor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
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
                        const Expanded(child: Text('Jenis Kelamin')),
                        Expanded(
                            child: DropdownButton<String>(
                          dropdownColor: AppColors.cardcolor,
                          underline: Container(height: 0, color: Colors.white),
                          hint: Text(state is UserSignedIn
                              ? state.userModel.jk!
                              : '-'),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                            _jkTextController.text = value!;
                          },
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
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
                        const Expanded(child: Text('Alamat')),
                        Expanded(
                            child: reusableTextField1(
                                state is UserSignedIn
                                    ? state.userModel.alamat!
                                    : '-',
                                _alamatTextController)),
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
                                  child: reusableTextField4(
                                      state is UserSignedIn
                                          ? state.userModel.usia.toString()
                                          : '-',
                                      _usiaTextController)),
                              const Text(" Tahun"),
                            ],
                          ),
                        ),
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
                        const Expanded(child: Text('No Hp')),
                        Expanded(
                            child: reusableTextField3(
                                state is UserSignedIn
                                    ? state.userModel.no_hp!
                                    : '-',
                                _nohpTextController)),
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
                        const Expanded(child: Text('Golongan Darah')),
                        Expanded(
                            child: reusableTextField1(
                                state is UserSignedIn
                                    ? state.userModel.goldar!
                                    : '-',
                                _goldarTextController)),
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
                        const Expanded(child: Text('Berat Badan')),
                        Expanded(
                            child: Row(
                          children: [
                            Expanded(
                              child: reusableTextField4(
                                  state is UserSignedIn
                                      ? state.userModel.bb!
                                      : '-',
                                  _bbTextController),
                            ),
                            const Text(" KG"),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget cardviewprofilnonpasien() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Card(
          color: AppColors.cardcolor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
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
                        const Expanded(child: Text('KaderTB')),
                        Expanded(
                            child: reusableTextField1(
                                state is UserSignedIn
                                    ? state.userModel.kaderTB!
                                    : '-',
                                _kadertbTextController)),
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
                        const Expanded(child: Text('PMO')),
                        Expanded(
                            child: reusableTextField1(
                                state is UserSignedIn
                                    ? state.userModel.pmo!
                                    : '-',
                                _pmoTextController)),
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
                        const Expanded(child: Text('Pet Kesehatan')),
                        Expanded(
                          child: reusableTextField1(
                              state is UserSignedIn
                                  ? state.userModel.pet_kesehatan!
                                  : '-',
                              _petkesehatanTextController),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget cardviewprofilext() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Card(
          color: AppColors.cardcolor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: state is UserSignedIn &&
                      state.userModel.role!.contains('pasien')
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(child: Text('KaderTB')),
                              Expanded(
                                  child: reusableTextField1(
                                      state is UserSignedIn
                                          ? state.userModel.kaderTB!
                                          : '-',
                                      _kadertbTextController)),
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
                              const Expanded(child: Text('PMO')),
                              Expanded(
                                  child: reusableTextField1(
                                      state is UserSignedIn
                                          ? state.userModel.pmo!
                                          : '-',
                                      _pmoTextController)),
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
                              const Expanded(child: Text('Pet Kesehatan')),
                              Expanded(
                                child: reusableTextField1(
                                    state is UserSignedIn
                                        ? state.userModel.pet_kesehatan!
                                        : '-',
                                    _petkesehatanTextController),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        if (state is UserSignedIn &&
                            state.userModel.role!.contains('kader')) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(child: Text('KaderTB')),
                                Expanded(
                                    child: reusableTextField1(
                                        state is UserSignedIn
                                            ? state.userModel.kaderTB!
                                            : '-',
                                        _kadertbTextController)),
                              ],
                            ),
                          ),
                        ] else if (state is UserSignedIn &&
                            state.userModel.role!.contains('pk')) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(child: Text('Pet Kesehatan')),
                                Expanded(
                                  child: reusableTextField1(
                                      state is UserSignedIn
                                          ? state.userModel.pet_kesehatan!
                                          : '-',
                                      _petkesehatanTextController),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Container()
                        ]
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(CheckSignInStatus()),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Profile Edit"),
                backgroundColor: AppColors.appBarColor,
                iconTheme: IconThemeData(color: AppColors.buttonIconColor),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: () async {
                          var jk,
                              alamat,
                              no_hp,
                              bb,
                              goldar,
                              kaderTB,
                              pmo,
                              usia,
                              pet_kesehatan;
                          if (_jkTextController.text.isEmpty) {
                            jk = state is UserSignedIn
                                ? state.userModel.jk!
                                : '-';
                          } else {
                            jk = _jkTextController.text;
                          }
                          if (_alamatTextController.text.isEmpty) {
                            alamat = state is UserSignedIn
                                ? state.userModel.alamat!
                                : '-';
                          } else {
                            alamat = _alamatTextController.text;
                          }
                          if (_nohpTextController.text.isEmpty) {
                            no_hp = state is UserSignedIn
                                ? state.userModel.no_hp!
                                : '-';
                          } else {
                            no_hp = _nohpTextController.text;
                          }
                          if (_goldarTextController.text.isEmpty) {
                            goldar = state is UserSignedIn
                                ? state.userModel.goldar!
                                : '-';
                          } else {
                            goldar = _goldarTextController.text;
                          }
                          if (_bbTextController.text.isEmpty) {
                            bb = state is UserSignedIn
                                ? state.userModel.bb!
                                : '-';
                          } else {
                            bb = _bbTextController.text;
                          }
                          if (_kadertbTextController.text.isEmpty) {
                            kaderTB = state is UserSignedIn
                                ? state.userModel.kaderTB!
                                : '-';
                          } else {
                            kaderTB = _kadertbTextController.text;
                          }
                          if (_pmoTextController.text.isEmpty) {
                            pmo = state is UserSignedIn
                                ? state.userModel.pmo!
                                : '-';
                          } else {
                            pmo = _pmoTextController.text;
                          }
                          if (_petkesehatanTextController.text.isEmpty) {
                            pet_kesehatan = state is UserSignedIn
                                ? state.userModel.pet_kesehatan!
                                : '-';
                          } else {
                            pet_kesehatan = _petkesehatanTextController.text;
                          }
                          if (_usiaTextController.text.isEmpty) {
                            usia = state is UserSignedIn
                                ? state.userModel.usia!
                                : 0;
                          } else {
                            usia = int.parse(_usiaTextController.text);
                          }
                          context.read<UserBloc>().add(UpdateProfile(
                              id: state is UserSignedIn
                                  ? state.userModel.id!
                                  : 0,
                              userModel: UserModel(
                                  id: state is UserSignedIn
                                      ? state.userModel.id!
                                      : 0,
                                  nama: state is UserSignedIn
                                      ? state.userModel.nama!
                                      : '-',
                                  email: state is UserSignedIn
                                      ? state.userModel.email!
                                      : '-',
                                  nik: state is UserSignedIn
                                      ? state.userModel.nik!
                                      : '-',
                                  username: state is UserSignedIn
                                      ? state.userModel.username!
                                      : '-',
                                  jk: jk,
                                  alamat: alamat,
                                  usia: usia.toString(),
                                  no_hp: no_hp,
                                  bb: bb,
                                  goldar: goldar,
                                  kaderTB: kaderTB,
                                  pmo: pmo,
                                  pet_kesehatan: pet_kesehatan,
                                  role: state is UserSignedIn
                                      ? state.userModel.role!
                                      : '-')));
                          context.pushReplacementNamed('profile');
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text('Data Profil di simpan')));
                        },
                        child: Icon(
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
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserSignedIn) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Icon(Icons.account_circle, size: 100),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                state is UserSignedIn
                                    ? state.userModel.nama!
                                    : '-',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            state is UserSignedIn ? state.userModel.nik! : '-',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          cardviewprofil(),
                          const SizedBox(
                            height: 15,
                          ),
                          cardviewprofilext(),
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ));
        },
      ),
    );
  }
}
