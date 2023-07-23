import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/components/reusablecomp.dart';
import 'package:tbc_app/data/Models/user/user.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, required this.dioClient}) : super(key: key);
  final DioClient dioClient;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _passwordagainTextController = TextEditingController();
  TextEditingController _nikTextController = TextEditingController();
  TextEditingController _namaTextController = TextEditingController();

  bool isLoading = false;
  User? createdUser;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(color: AppColors.appBarColor),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.fitHeight,
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Masukan Email", Icons.person_outline, false,
                    _emailTextController, 'Email'),
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
                reusableTextField("Ulang Kata sandi", Icons.lock_outlined, true,
                    _passwordagainTextController, 'Confirm Password'),
                const SizedBox(
                  height: 20,
                ),
                ButtonAction(context, "Daftar", () async {
                  setState(() => isLoading = true);
                  final user = User(
                    nama: _namaTextController.text,
                    username: '',
                    email: _emailTextController.text,
                    nik: _nikTextController.text,
                    password: _passwordTextController.text,
                    confirm_password: _passwordagainTextController.text,
                    role: 'pasien',
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
                        content: Text('Registrasi berhasil silahkan login')));
                    context.goNamed('login');
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
          ))),
    );
  }
}
