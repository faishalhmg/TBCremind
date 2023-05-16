import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';

import 'package:tbc_app/routes/routers.dart';
import 'package:tbc_app/service/service_locator.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()
        ..add(
          CheckSignInStatus(),
        ),
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserSignedIn) {
            router.replaceNamed('home');
          } else if (state is UserSignedOut) {
            router.replaceNamed('login');
          }
        },
        child: MaterialApp.router(
          // routerDelegate: router.routerDelegate,
          // routeInformationParser: router.routeInformationParser,
          // routeInformationProvider: router.routeInformationProvider,
          debugShowCheckedModeBanner: false,
          title: 'TBC - APP',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
