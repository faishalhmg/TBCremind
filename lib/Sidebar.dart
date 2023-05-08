import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/theme/app_colors.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TBC-APP'),
        backgroundColor: AppColors.appBarColor,
        iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  context.go('/notification');
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
            DrawerHeader(
                decoration: const BoxDecoration(color: AppColors.cardcolor),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://www.flaticon.com/free-icon/account_3033143?term=user&page=1&position=34&origin=search&related_id=3033143'),
                      radius: 40.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          child: Text(
                            'user',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25.0),
                          ),
                        ),
                        const Divider(
                          height: 3,
                          indent: 10,
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
                        SizedBox(
                          child: Row(children: const [
                            Text(
                              'edit profile',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 25.0),
                            ),
                          ]),
                        ),
                      ],
                    )
                  ],
                )),
            const Divider(
              indent: 10,
              color: AppColors.appBarColor,
              endIndent: 10,
            ),
            ListTile(
              leading: const Icon(
                Icons.question_mark_sharp,
              ),
              title: const Text('Bantuan', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Here you can give your route to navigate
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app_outlined),
              title: const Text('Keluar', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Here you can give your route to navigate
              },
            )
          ],
        ),
      ),
    );
  }
}
