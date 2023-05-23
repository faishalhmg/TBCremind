import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/components/reusablecomp.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/routes/routers.dart';
import 'package:tbc_app/service/SharedPreferenceHelper.dart';
import 'package:tbc_app/theme/app_colors.dart';
import 'package:tbc_app/view/Signup_view.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final DioClient _dioClient = DioClient();

  SharedPref sharedPref = SharedPref();

  // Future<void> login() async {
  //   if (_formKey.currentState!.validate()) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: const Text('Processing Data'),
  //       backgroundColor: AppColors.cardButtonColor,
  //     ));
  //     try{
  //     dynamic res = await _dioClient.login(
  //         _emailTextController.text, _passwordTextController.text);
  //     ScaffoldMessenger.of(context).hideCurrentSnackBar();

  //     if (res['ErrorCode'] == null) {
  //       String accessToken = res["token"];
  //       GoRouter.of(context).go('home', extra: accessToken);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text('Error: ${res['message']}'),
  //         backgroundColor: Colors.red.shade300,
  //       ));
  //     }
  //     }catch (e){}
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(CheckSignInStatus()),
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: AppColors.appBarColor),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Form(
                key: _formKey,
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    return Column(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.fitHeight,
                          width: 240,
                          height: 240,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'TB-Remind',
                          style: TextStyle(
                              fontSize: 40, color: AppColors.appBarTextColor),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        reusableTextField(
                            "Masukan Nik atau email anda!",
                            Icons.person_outline,
                            false,
                            _emailTextController,
                            'NIK atau Email'),
                        const SizedBox(
                          height: 20,
                        ),
                        reusableTextField("Enter Password", Icons.lock_outline,
                            true, _passwordTextController, 'Password'),
                        const SizedBox(
                          height: 5,
                        ),
                        forgetPassword(context),
                        ButtonAction(context, "Masuk", () async {
                          if (state is UserSignedOut) {
                            if (_emailTextController.text != '' &&
                                _passwordTextController.text != '') {
                              try {
                                context.read<UserBloc>().add(SignIn(
                                    nikOremail: _emailTextController.text,
                                    password: _passwordTextController.text));
                                context
                                    .read<UserBloc>()
                                    .add(CheckSignInStatus());
                                const storage = FlutterSecureStorage();
                                var token = await storage.read(key: 'token');
                                if (token != '') {
                                  setState(() {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 3),
                                        content: Text(
                                            "Pencet sekali lagi! atau Email/nik/password salah"),
                                      ),
                                    );
                                    router.pushReplacementNamed('login');
                                  });
                                } else {
                                  setState(() {
                                    context.pushReplacementNamed('home');
                                  });
                                }
                              } catch (e) {
                                setState(() => ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 3),
                                      content: Text(e.toString()),
                                    )));
                              }
                            }
                            if (_emailTextController.text == '' &&
                                    _passwordTextController.text == '' ||
                                _emailTextController.text.length < 10 ||
                                _passwordTextController.text.length < 8) {
                              setState(() => ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    duration: Duration(seconds: 3),
                                    content: Text(
                                        'Silahkan Masukan email/nik dan password yang sesuai'),
                                  )));
                            }
                          }
                          if (state is UserSignedIn) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(
                            //         duration: Duration(seconds: 3),
                            //         content: Text(
                            //             'terjadi kesalahan pada server!')));
                            router.pushReplacementNamed('home');
                          }
                          // UserModel? user = await _iloginService.login(
                          //     _emailTextController.text,
                          //     _passwordTextController.text);
                          // context.push('/home', extra: user);
                        }),
                        signUpOption()
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            context.push('/signup');
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
          child: const Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.right,
          ),
          onPressed: () => context.go('/resetpassword')),
    );
  }
}
