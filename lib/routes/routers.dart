import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/edukasi/edukasi.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/notifications.dart';
import 'package:tbc_app/service/SharedPreferenceHelper.dart';
import 'package:tbc_app/splash.dart';
import 'package:tbc_app/view/Homepage.dart';
import 'package:tbc_app/view/MainPage.dart';
import 'package:tbc_app/view/ResetPassword_View.dart';
import 'package:tbc_app/view/Signup_view.dart';
import 'package:tbc_app/view/admin/quizcont/quizPlus.dart';
import 'package:tbc_app/view/admin/quizcont/quizShow.dart';
import 'package:tbc_app/view/admin/user/DataUser.dart';

import 'package:tbc_app/view/admin/user/TambahUser.dart';
import 'package:tbc_app/view/afterResetPassword.dart';
import 'package:tbc_app/view/edukasi/ConfigEdukasi.dart';
import 'package:tbc_app/view/edukasi/editEdukasi.dart';
import 'package:tbc_app/view/kader/DataPasien.dart';
import 'package:tbc_app/view/kader/DataPasienFull.dart';
import 'package:tbc_app/view/kader/EfekObatPasien.dart';
import 'package:tbc_app/view/login_view.dart';
import 'package:tbc_app/view/pasien/DataKeluarga.dart';
import 'package:tbc_app/view/pasien/Kuisioner.dart';
import 'package:tbc_app/view/pasien/efek/configEfek.dart';
import 'package:tbc_app/view/pasien/haislKuis.dart';
import 'package:tbc_app/view/pasien/pengingat/PengingatObat.dart';
import 'package:tbc_app/view/edukasi/edukasiTBC.dart';
import 'package:tbc_app/view/pasien/efek/efekObat.dart';
import 'package:tbc_app/view/pasien/infokeluarga/infoKeluarga.dart';
import 'package:tbc_app/view/pasien/infokeluarga/infoKeluargaEdit.dart';
import 'package:tbc_app/view/pasien/pengambilan/configPengambilan.dart';
import 'package:tbc_app/view/pasien/pengambilan/pengambilanObat.dart';
import 'package:tbc_app/view/pasien/pengingat/tambahpengingat.dart';
import 'package:tbc_app/view/pasien/periksa/configPeriksa.dart';
import 'package:tbc_app/view/pasien/periksa/periksaDahak.dart';
import 'package:tbc_app/view/pk/DataKeluargaP.dart';
import 'package:tbc_app/view/pk/DataKeluargaPFull.dart';
import 'package:tbc_app/view/profile/profile.dart';
import 'package:tbc_app/view/profile/profileEdit.dart';

import '../view/admin/quizcont/QuizSet.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
SharedPref sharedPref = SharedPref();

final GoRouter router = GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'mainpage',
        pageBuilder: (context, state) => NoTransitionPage(child: SplashPage()),
      ),
      GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LoginScreen()),
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
                    const NoTransitionPage(child: ResetPassword()),
                routes: [
                  GoRoute(
                      path: 'afterresetpassword',
                      name: 'afterresetpassword',
                      pageBuilder: (context, state) =>
                          const NoTransitionPage(child: AfterResetPassword())),
                ]),
          ]),
      GoRoute(
          path: '/home',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (context) => UserBloc()..add(CheckSignInStatus()),
              child: HomePage(),
            );
          },
          routes: [
            GoRoute(
                path: 'dataPasien',
                name: 'dataPasien',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: DataPasien());
                },
                routes: [
                  GoRoute(
                      path: 'dataPasienFull',
                      name: 'dataPasienFull',
                      pageBuilder: (context, state) {
                        return NoTransitionPage(
                            child: DataPasienFull(
                          email: state.queryParams['email'],
                          id: state.queryParams['id'],
                        ));
                      },
                      routes: [
                        GoRoute(
                            path: 'dataEPFull',
                            name: 'dataEPFull',
                            pageBuilder: (context, state) {
                              return NoTransitionPage(
                                  child: EfekObatPasien(
                                tawal: state.queryParams['awal'],
                                takhir: state.queryParams['akhir'],
                                dosis: state.queryParams['dosis'],
                                efek: state.queryParams['efek'],
                              ));
                            }),
                      ]),
                ]),
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
                        return NoTransitionPage(
                            child: kuisioner(
                          id: state.extra as int?,
                        ));
                      },
                      routes: [
                        GoRoute(
                          path: 'hasilkuis',
                          name: 'hasilkuis',
                          pageBuilder: (context, state) {
                            return NoTransitionPage(
                                child: hasilKuis(
                              id: state.extra as int?,
                            ));
                          },
                        )
                      ])
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
                },
                routes: [
                  GoRoute(
                    path: 'configPengambilan',
                    name: 'configPengambilan',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                          child: ConfigPengambilan(
                        arg: state.extra as ModifyAlarmPengambilanScreenArg?,
                      ));
                    },
                  )
                ]),
            GoRoute(
                path: 'efekObat',
                name: 'efekObat',
                pageBuilder: (context, state) {
                  return NoTransitionPage(child: EfekObat());
                },
                routes: [
                  GoRoute(
                    path: 'configEfek',
                    name: 'configEfek',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                          child: ConfigEfek(
                              arg: state.extra as ModifyEfekScreenArg?));
                    },
                  )
                ]),
            GoRoute(
                path: 'edukasiTBC',
                name: 'edukasiTBC',
                pageBuilder: (context, state) {
                  return NoTransitionPage(child: EdukasiTBC());
                },
                routes: [
                  GoRoute(
                      path: 'showedukasi',
                      name: 'showedukasi',
                      pageBuilder: (context, state) {
                        return NoTransitionPage(
                            child: EdukasiTBCShow(
                          id: state.extra as int?,
                        ));
                      },
                      routes: [
                        GoRoute(
                            path: 'editEdukasi',
                            name: 'editEdukasi',
                            pageBuilder: (context, state) {
                              return NoTransitionPage(
                                  child: EdukasiTBCEdit(
                                id: state.extra as int?,
                              ));
                            }),
                      ]),
                ]),
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
            GoRoute(
                path: 'dataKeluargaP',
                name: 'dataKeluargaP',
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: DataKeluargaP());
                },
                routes: [
                  GoRoute(
                    path: 'dataKeluargaPFull',
                    name: 'dataKeluargaPFull',
                    pageBuilder: (context, state) {
                      return NoTransitionPage(
                          child: DataKeluargaPFull(
                        email: state.queryParams['email'],
                        id: state.queryParams['id'],
                      ));
                    },
                  ),
                ]),
            GoRoute(
              path: 'dataUser',
              name: 'dataUser',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: DataUser());
              },
              routes: [
                GoRoute(
                  path: 'tambahUser',
                  name: 'tambahUser',
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                        child: DataUserTambah(
                      dioClient: DioClient(),
                    ));
                  },
                ),
              ],
              // routes: [
              //   GoRoute(
              //     path: 'dataUserFull',
              //     name: 'dataUserFull',
              //     pageBuilder: (context, state) {
              //       return NoTransitionPage(
              //           child: DataUserFull(
              //         email: state.queryParams['email'],
              //         id: state.queryParams['id'],
              //       ));
              //     },
              //   ),
              // ]
            ),
            GoRoute(
              path: 'dataKuis',
              name: 'dataKuis',
              pageBuilder: (context, state) {
                return const NoTransitionPage(child: DataKuis());
              },
              routes: [
                GoRoute(
                  path: 'kuisPlus',
                  name: 'kuisPlus',
                  pageBuilder: (context, state) {
                    return NoTransitionPage(child: QuizPlus());
                  },
                ),
                GoRoute(
                  path: 'kuisShow',
                  name: 'kuisShow',
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                        child: QuizShow(
                      quizid: state.extra as int?,
                    ));
                  },
                ),
              ],
            ),
          ]),
    ]);
