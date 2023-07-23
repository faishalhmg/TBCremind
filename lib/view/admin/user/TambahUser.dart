import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/bloc/efek_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/pasien_bloc.dart';
import 'package:tbc_app/components/reusablecomp.dart';
import 'package:tbc_app/data/Models/user/user.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

class DataUserTambah extends StatefulWidget {
  const DataUserTambah({super.key, required this.dioClient});
  final DioClient dioClient;
  @override
  State<DataUserTambah> createState() => _DataUserTambahState();
}

class _DataUserTambahState extends State<DataUserTambah> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _passwordagainTextController = TextEditingController();
  TextEditingController _nikTextController = TextEditingController();
  TextEditingController _namaTextController = TextEditingController();
  TextEditingController _roleTextController = TextEditingController();
  bool isLoading = false;
  User? createdUser;
  String? error;
  String? selectedValue;
  static const List<String> list = <String>['admin', 'pasien', 'kader', 'pk'];

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  bool isSearchOpen = false;
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data User'),
          backgroundColor: AppColors.appBarColor,
          iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
        ),
        backgroundColor: AppColors.pageBackground,
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(color: AppColors.appBarColor),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Masukan Email", Icons.person_outline,
                      false, _emailTextController, 'Email'),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Masukan NIK", Icons.person_outline, false,
                      _nikTextController, 'NIK'),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Masukan Nama", Icons.person_outline, false,
                      _namaTextController, 'Nama'),
                  const SizedBox(
                    height: 20,
                  ),
                  // reusableTextField("Enter UserName", Icons.person_outline, false,
                  //     _userNameTextController, 'UserName'),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  reusableTextField("Masukan Kata sandi", Icons.lock_outlined,
                      true, _passwordTextController, 'Password'),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField("Ulang Kata sandi", Icons.lock_outlined,
                      true, _passwordagainTextController, 'Confirm Password'),
                  const SizedBox(
                    height: 20,
                  ),
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
                        hint: Text("Role"),
                        value: selectedValue,
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value as String;
                          });
                          _roleTextController.text = value!;
                        },
                        items:
                            list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                    ],
                  )),
                  ButtonAction(context, "Daftar", () async {
                    setState(() => isLoading = true);
                    final user = User(
                      nama: _namaTextController.text,
                      username: '',
                      email: _emailTextController.text,
                      nik: _nikTextController.text,
                      password: _passwordTextController.text,
                      confirm_password: _passwordagainTextController.text,
                      role: _roleTextController.text,
                      alamat: '',
                      usia: null,
                      no_hp: '',
                      goldar: '',
                      bb: '',
                      kaderTB: '',
                      pmo: '',
                      pet_kesehatan: '',
                      jk: '',
                    );
                    try {
                      final responseUser =
                          await widget.dioClient.createUser(user: user);
                      setState(() => createdUser = responseUser);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          duration: Duration(seconds: 5),
                          content: Text('Tambah User Berhasil!')));
                      context.pushReplacementNamed('dataUser');
                    } catch (err) {
                      setState(() => ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            duration: Duration(seconds: 3),
                            content: Text(' data tidak sesuai ketentuan'),
                          )));
                    }
                    setState(() => isLoading = false);
                  }),
                ],
              ),
            )));
  }
}
