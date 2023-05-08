import 'package:flutter/material.dart';

import 'package:tbc_app/components/cardviewNotif.dart';
import 'package:tbc_app/theme/app_colors.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
        backgroundColor: AppColors.appBarColor,
        iconTheme: IconThemeData(color: AppColors.buttonIconColor),
      ),
      backgroundColor: AppColors.pageBackground,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Cardview(),
          ),
          Divider(
            indent: 20,
            endIndent: 20,
          )
        ],
      ),
    );
  }
}
