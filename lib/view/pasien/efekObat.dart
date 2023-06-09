// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/theme/app_colors.dart';

class EfekObat extends StatelessWidget {
  const EfekObat({
    super.key,
  });

  Widget CardViewEfekObat() {
    return Card(
      elevation: 10,
      color: AppColors.cardcolor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Catatan 1',
                  style: TextStyle(fontSize: 40),
                ),
                Text(
                  'Pemakaian Awal',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Pemakaian Terakhir',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  color: AppColors.buttonColor,
                  iconSize: 35,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  color: AppColors.buttonColor,
                  iconSize: 35,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menuDetails[4]['title']),
        backgroundColor: AppColors.appBarColor,
        iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  // context.go('/notification');
                },
                child: const Icon(
                  Icons.lock_clock_rounded,
                  size: 26.0,
                  color: AppColors.appBarIconColor,
                ),
              )),
        ],
      ),
      backgroundColor: AppColors.pageBackground,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        children: [
          CardViewEfekObat(),
          const Divider(
            indent: 10,
            endIndent: 10,
          )
        ],
      ),
    );
  }
}
