import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/notifications.dart';
import 'package:tbc_app/view/Homepage.dart';
import 'package:tbc_app/view/MainPage.dart';
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
import 'package:tbc_app/view/pasien/periksaDahak.dart';
import 'package:tbc_app/view/profile/profile.dart';
import 'package:tbc_app/view/profile/profileEdit.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router =
    GoRouter(initialLocation: '/', navigatorKey: _rootNavigatorKey, routes: [
  GoRoute(
      path: '/',
      pageBuilder: (context, state) => NoTransitionPage(child: const MainPage()
          //   child: FlutterSplashScreen.fadeIn(
          // backgroundColor: Colors.white,
          // onInit: () {
          //   debugPrint("On Init");
          // },
          // onEnd: () {
          //   debugPrint("On End");
          // },
          // childWidget: SizedBox(
          //   height: 200,
          //   width: 200,
          //   child: Text('TBC-Remind'),
          // ),
          // onAnimationEnd: () => debugPrint("On Fade In End"),
          // defaultNextScreen: const LoginScreen(),
          // setNextScreenAsyncCallback: () async {
          //   String? token = await CredentialStore.getBrearerToken();

          //   if (token != null && token.isNotEmpty) {
          //     return const Dashboard();
          //   } else {
          //     return SSOScreen();
          //   }
          // },
          // )
          ),
      routes: [
        GoRoute(
            path: 'login',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: LoginScreen())),
        GoRoute(
            path: 'signup',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SignUpScreen())),
        GoRoute(
            path: 'resetpassword',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ResetPassword())),
      ]),
  GoRoute(
      path: '/home',
      pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
      routes: [
        GoRoute(
          path: 'notification',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: Notifications()),
        ),
        GoRoute(
            path: 'dataKeluarga',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: Datakeluarga()),
            routes: [
              GoRoute(
                path: 'infoKeluarga',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: infoKeluarga()),
                routes: [
                  GoRoute(
                    path: 'edit',
                    pageBuilder: (context, state) =>
                        const NoTransitionPage(child: InfoKeluargaEdit()),
                  ),
                ],
              ),
              GoRoute(
                path: 'Kuisioner',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: kuisioner()),
              )
            ]),
        GoRoute(
          path: 'pengingatObat',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: PengingatObat()),
        ),
        GoRoute(
          path: 'periksaDahak',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: PeriksaDahak()),
        ),
        GoRoute(
          path: 'pengambilanObat',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: PengambilanObat()),
        ),
        GoRoute(
          path: 'efekObat',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: EfekObat()),
        ),
        GoRoute(
          path: 'edukasiTBC',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: EdukasiTBC()),
        ),
        GoRoute(
            path: 'profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: Profile()),
            routes: [
              GoRoute(
                path: 'edit',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: EditProfile()),
              ),
            ]),
      ]),
]);
