import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tbc_app/data/cardMenuTileMap.dart';
import 'package:tbc_app/theme/app_colors.dart';

class hasilKuis extends StatelessWidget {
  const hasilKuis({super.key});

  Widget cardviewdhasil() {
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
                    Expanded(child: Text('Jumlah keluarga')),
                    Expanded(child: Text('orang')),
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
                    Expanded(child: Text('Hasil Kuis Pola TB')),
                    Expanded(child: Text('xxxxxxx')),
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
        title: Text(cardmenuDetailsTile[1]['title']),
        backgroundColor: AppColors.appBarColor,
        iconTheme: IconThemeData(color: AppColors.buttonIconColor),
      ),
      backgroundColor: AppColors.pageBackground,
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Text(
            'Hasil Kuisioner',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: cardviewdhasil(),
          )
        ],
      ),
    );
  }
}
