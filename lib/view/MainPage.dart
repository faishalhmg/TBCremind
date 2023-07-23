import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/routes/routers.dart';
import 'package:tbc_app/splash.dart';
import 'package:tbc_app/view/Homepage.dart';
import 'package:tbc_app/view/login_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => UserBloc()..add(CheckSignInStatus()),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserSignedIn) {
              router.replaceNamed('home');
            } else {
              router.replaceNamed('login');
            }
            return const SplashPage();
          },
        ),
      ),
    );
  }
}
