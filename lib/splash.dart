import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/theme/app_colors.dart';

import 'package:tbc_app/view/splashscreen.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(CheckSignInStatus()),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return EasySplashScreen(
            logo: Image.asset("assets/images/logo.png"),
            title: const Text(
              "TBC Remind App",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.pageBackground,
            showLoader: true,
            loadingText: const Text("Loading..."),
            navigator: state is UserSignedIn ? 'home' : 'login',
            durationInSeconds: 5,
          );
        },
      ),
    );
  }
}
