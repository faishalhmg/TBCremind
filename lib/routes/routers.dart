import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/notifications.dart';
import 'package:tbc_app/service/SharedPreferenceHelper.dart';
import 'package:tbc_app/view/Homepage.dart';
import 'package:tbc_app/view/ResetPassword_View.dart';
import 'package:tbc_app/view/Signup_view.dart';
import 'package:tbc_app/view/login_view.dart';
import 'package:tbc_app/view/pasien/DataKeluarga.dart';
import 'package:tbc_app/view/pasien/Kuisioner.dart';
import 'package:tbc_app/view/pasien/PengingatObat.dart';
import 'package:tbc_app/view/pasien/edukasiTBC.dart';
import 'package:tbc_app/view/pasien/efekObat.dart';
import 'package:tbc_app/view/pasien/infokeluarga/infoKeluarga.dart';
import 'package:tbc_app/view/pasien/infokeluarga/infoKeluargaEdit.dart';
import 'package:tbc_app/view/pasien/pengambilanObat.dart';
import 'package:tbc_app/view/pasien/pengingat/tambahpengingat.dart';
import 'package:tbc_app/view/pasien/periksa/configPeriksa.dart';
import 'package:tbc_app/view/pasien/periksaDahak.dart';
import 'package:tbc_app/view/profile/profile.dart';
import 'package:tbc_app/view/profile/profileEdit.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
SharedPref sharedPref = SharedPref();

final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
          path: '/',
          name: 'login',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: const LoginScreen()),
          routes: [
            GoRoute(
                path: 'signup',
                name: 'signup',
                pageBuilder: (context, state) => NoTransitionPage(
                        child: SignUpScreen(
                      dioClient: DioClient(),
                    ))),
            GoRoute(
                path: 'resetpassword',
                name: 'resetpassword',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ResetPassword())),
          ]),
      GoRoute(
          path: '/home',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (context) => UserBloc(),
              child: HomePage(),
            );
          },
          routes: [
            GoRoute(
                path: 'notification',
                name: 'notification',
                builder: (context, state) {
                  return const Notifications();
                }),
            GoRoute(
                path: 'dataKeluarga',
                name: 'dataKeluarga',
                builder: (context, state) {
                  return const Datakeluarga();
                },
                routes: [
                  GoRoute(
                    path: 'infoKeluarga',
                    name: 'infoKeluarga',
                    builder: (context, state) {
                      return infoKeluarga();
                    },
                    routes: [
                      GoRoute(
                          path: 'edit',
                          name: 'editkeluarga',
                          builder: (context, state) {
                            return InfoKeluargaEdit();
                          }),
                    ],
                  ),
                  GoRoute(
                      path: 'Kuisioner',
                      name: 'kuisioner',
                      pageBuilder: (context, state) {
                        return const NoTransitionPage(child: kuisioner());
                      })
                ]),
            GoRoute(
                path: 'pengingatObat',
                name: 'pengingatObat',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: PengingatObat());
                },
                routes: [
                  GoRoute(
                    path: 'tambah',
                    name: 'tambahpengingat',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                          child: TambahPengingat(
                        arg: state.extra as ModifyAlarmScreenArg?,
                      ));
                    },
                  )
                ]),
            GoRoute(
                path: 'periksaDahak',
                name: 'periksaDahak',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: PeriksaDahak());
                },
                routes: [
                  GoRoute(
                    path: 'configPeriksa',
                    name: 'configPeriksa',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                          child: ConfigPeriksa(
                        arg: state.extra as ModifyAlarmPeriksaScreenArg?,
                      ));
                    },
                  )
                ]),
            GoRoute(
                path: 'pengambilanObat',
                name: 'pengambilanObat',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: PengambilanObat());
                }),
            GoRoute(
                path: 'efekObat',
                name: 'efekObat',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: EfekObat());
                }),
            GoRoute(
                path: 'edukasiTBC',
                name: 'edukasiTBC',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: EdukasiTBC());
                }),
            GoRoute(
                path: 'profile',
                name: 'profile',
                builder: (context, state) {
                  return BlocProvider(
                    create: (context) => UserBloc()..add(CheckSignInStatus()),
                    child: Profile(),
                  );
                },
                routes: [
                  GoRoute(
                      path: 'edit',
                      name: 'edit',
                      builder: (context, state) {
                        return EditProfile();
                      }),
                ]),
          ]),
    ]);
