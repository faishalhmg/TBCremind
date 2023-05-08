import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/components/cardButton.dart';
import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('TB - Remind'),
        backgroundColor: AppColors.appBarColor,
        iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  context.go('/home/notification');
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
                        user.email!,
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
                        onTap: () {
                          context.go('/home/profile');
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
              title: const Text('Bantuan', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Here you can give your route to navigate
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app_outlined),
              title: const Text('Keluar', style: TextStyle(fontSize: 18)),
              onTap: () => FirebaseAuth.instance.signOut().then((value) {
                print('Sign Out');
                context.go('/');
              }),
            )
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
                width: 200,
                height: 200,
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
                    CardButton(no: x)
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
