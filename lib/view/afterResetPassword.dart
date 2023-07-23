import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/components/reusablecomp.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

class AfterResetPassword extends StatefulWidget {
  const AfterResetPassword({Key? key}) : super(key: key);

  @override
  _AfterResetPasswordState createState() => _AfterResetPasswordState();
}

class _AfterResetPasswordState extends State<AfterResetPassword> {
  final DioClient _dioClient = DioClient();
  TextEditingController _tokenTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: AppColors.appBarColor),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Masukan token yang terkirim pada Email anda",
                    Icons.person_outline, false, _tokenTextController, 'token'),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Masukan Password Baru", Icons.person_outline,
                    true, _passwordTextController, 'token'),
                const SizedBox(
                  height: 20,
                ),
                ButtonAction(context, "Reset Password", () async {
                  final b = await _dioClient.resetPassowrd(
                      token: _tokenTextController.text,
                      password: _passwordTextController.text);
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text(b.toString()),
                      ),
                    );
                  });
                  context.replaceNamed('login');
                })
              ],
            ),
          ))),
    );
  }
}
