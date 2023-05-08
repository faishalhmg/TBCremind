import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data/cardMenuTileMap.dart';
import '../../../theme/app_colors.dart';

class infoKeluarga extends StatelessWidget {
  const infoKeluarga({super.key});

  Widget cardviewdetail() {
    return Card(
      color: AppColors.cardcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text('name')),
                    Expanded(child: Text('name')),
                  ],
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
                color: AppColors.appBarColor,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text('Usia')),
                    Expanded(child: Text('tahun')),
                  ],
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
                color: AppColors.appBarColor,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text('Riwayat penyakit')),
                    Expanded(child: Text('n')),
                  ],
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
                color: AppColors.appBarColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cardmenuDetailsTile[0]['title']),
        backgroundColor: AppColors.appBarColor,
        iconTheme: IconThemeData(color: AppColors.buttonIconColor),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  context.go('/home/dataKeluarga/infoKeluarga/edit');
                },
                child: Icon(
                  Icons.edit,
                  size: 26.0,
                  color: AppColors.appBarIconColor,
                ),
              )),
        ],
      ),
      backgroundColor: AppColors.pageBackground,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'Data Keluarga',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 15,
            ),
            cardviewdetail(),
          ],
        ),
      ),
    );
  }
}
