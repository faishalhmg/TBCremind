import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/components/reusablecomp.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final DioClient _dioClient = DioClient();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Forgot Password",
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
                reusableTextField("Masukan Email anda", Icons.person_outline,
                    false, _emailTextController, 'Email'),
                const SizedBox(
                  height: 20,
                ),
                ButtonAction(context, "Request Reset Password", () async {
                  if (_emailTextController.text.isNotEmpty &&
                      _emailTextController.text.contains('@')) {
                    final a = await _dioClient.forgotPassowrd(
                        email: _emailTextController.text);

                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text(a.toString()),
                        ),
                      );
                    });
                    return context.replaceNamed('afterresetpassword');
                  } else {
                    setState(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 3),
                          content: Text("masukan email anda !"),
                        ),
                      );
                    });
                  }
                })
              ],
            ),
          ))),
    );
  }
}
