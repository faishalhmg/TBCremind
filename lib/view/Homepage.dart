// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/components/cardButton.dart';
import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/routes/routers.dart';
import 'package:tbc_app/service/SharedPreferenceHelper.dart';

import 'package:tbc_app/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key,
  });

  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc()..add(CheckSignInStatus()),
        child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          // if (state is UserSignedIn) {
          // if (state is UserSignedOut) {
          //   state is UserSignedOut;
          //   return Scaffold(
          //     backgroundColor: AppColors.pageBackground,
          //     body: Container(
          //       child: Center(
          //         child: Builder(builder: (context) {
          //           context.pushReplacementNamed('login');
          //           return RefreshProgressIndicator(
          //             color: AppColors.appBarColor,
          //             backgroundColor: AppColors.buttonColor,
          //           );
          //         }),
          //       ),
          //     ),
          //   );
          // }
          return Scaffold(
            appBar: AppBar(
              title: const Text('TB - Remind'),
              backgroundColor: AppColors.appBarColor,
              iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
              actions: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () async {
                        context.goNamed('notification');
                      },
                      child: const Icon(
                        Icons.notifications,
                        size: 26.0,
                        color: AppColors.appBarIconColor,
                      ),
                    )),
              ],
            ),
            drawer: Drawer(
              elevation: 10.0,
              backgroundColor: AppColors.cardcolor,
              child: ListView(
                children: <Widget>[
                  Row(
                    children: [
                      const Expanded(
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://www.flaticon.com/free-icon/account_3033143?term=user&page=1&position=34&origin=search&related_id=3033143'),
                          radius: 40.0,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Text(
                              state is UserSignedIn
                                  ? state.userModel.username!
                                  : '-',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 25.0),
                            ),
                          ),
                          const Divider(
                            color: AppColors.appBarColor,
                            endIndent: 10,
                          ),
                          const Text(
                            'Role',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 14.0),
                          ),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                context.goNamed('profile');
                              },
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.edit,
                                    size: 12,
                                  ),
                                  Text(
                                    'edit profile',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                        fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                  const Divider(
                    indent: 10,
                    color: AppColors.appBarColor,
                    endIndent: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.question_mark_sharp,
                    ),
                    title:
                        const Text('Bantuan', style: TextStyle(fontSize: 18)),
                    onTap: () {
                      // Here you can give your route to navigate
                    },
                  ),
                  ListTile(
                      leading: const Icon(Icons.exit_to_app_outlined),
                      title:
                          const Text('Keluar', style: TextStyle(fontSize: 18)),
                      onTap: () async {
                        context.read<UserBloc>().add(SignOut());
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        final storage = new FlutterSecureStorage();
                        storage.deleteAll();
                        pref.remove('nikOremail');
                        pref.remove('token');
                        router.goNamed('login');
                      }),
                ],
              ),
            ),
            backgroundColor: const Color(0xFFffd275),
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.fitHeight,
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (var x = 0; x < menuDetails.length; x++) ...[
                          CardButton(
                            no: x,
                          )
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
            // return Scaffold(
            //   backgroundColor: AppColors.pageBackground,
            //   body: Container(
            //     child: Center(
            //       child: Builder(builder: (context) {
            //         return RefreshProgressIndicator(
            //           color: AppColors.appBarColor,
            //           backgroundColor: AppColors.buttonColor,
            //         );
            //       }),
            //     ),
            //   ),
            // );

            ));
  }
}
