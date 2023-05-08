import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tbc_app/theme/app_colors.dart';
import 'package:tbc_app/view/pasien/haislKuis.dart';

import '../../data/cardMenuTileMap.dart';

class kuisioner extends StatefulWidget {
  const kuisioner({super.key});

  @override
  State<kuisioner> createState() => _kuisionerState();
}

class _kuisionerState extends State<kuisioner> {
  Widget CardViewTextrich() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: AppColors.cardcolor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: 3000,
          height: 100,
          child: RichText(
              text: TextSpan(text: 'Pertanyaan', children: const <TextSpan>[])),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Jawaban jawaban = Jawaban.jawaban1;
    return Scaffold(
      appBar: AppBar(
        title: Text(cardmenuDetailsTile[1]['title']),
        backgroundColor: AppColors.appBarColor,
        iconTheme: IconThemeData(color: AppColors.buttonIconColor),
      ),
      backgroundColor: AppColors.pageBackground,
      body: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CardViewTextrich(),
          ),
          Divider(
            color: AppColors.statusBarColor,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            title: const Text('jawaban1'),
            leading: Radio<Jawaban>(
//Start copy
              fillColor:
                  MaterialStateColor.resolveWith((states) => Color(0xFFcd8241)),
              focusColor:
                  MaterialStateColor.resolveWith((states) => Color(0xFFcd8241)),
// End copy
              value: Jawaban.jawaban1,
              groupValue: jawaban,
              onChanged: (Jawaban? value) {
                setState(() {
                  jawaban = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('jawaban2'),
            leading: Radio<Jawaban>(
//Start copy
              fillColor:
                  MaterialStateColor.resolveWith((states) => Color(0xFFcd8241)),
              focusColor:
                  MaterialStateColor.resolveWith((states) => Color(0xFFcd8241)),
// End copy
              value: Jawaban.jawaban2,
              groupValue: jawaban,
              onChanged: (Jawaban? value) {
                setState(() {
                  jawaban = value!;
                });
              },
            ),
          ),
          Center(
              child: ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const hasilKuis()));
            },
            child: Text('lanjut'),
            style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll<Color>(AppColors.buttonColor)),
          ))
        ],
      ),
    );
  }
}

enum Jawaban { jawaban1, jawaban2 }
