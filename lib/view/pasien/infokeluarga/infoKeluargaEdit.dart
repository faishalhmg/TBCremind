import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/components/reusablecomp.dart';

import '../../../data/cardMenuTileMap.dart';
import '../../../theme/app_colors.dart';

class InfoKeluargaEdit extends StatefulWidget {
  const InfoKeluargaEdit({super.key});

  @override
  State<InfoKeluargaEdit> createState() => _InfoKeluargaEditState();
}

class _InfoKeluargaEditState extends State<InfoKeluargaEdit> {
  final TextEditingController _namaTextController = TextEditingController();
  final TextEditingController _usiaTextController = TextEditingController();
  final TextEditingController _riwayatTextController = TextEditingController();
  final TextEditingController _jeinsTextController = TextEditingController();
  String selectedValue = "Ayah";
  static const List<String> list = <String>[
    'Ayah',
    'Ibu',
    'Anak',
    'Istri',
    'suami'
  ];
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
                    Expanded(
                        child: Row(
                      children: [
                        const Text('nama '),
                        Expanded(
                            child: DropdownButton<String>(
                          icon: Icon(Icons.arrow_downward_sharp),
                          dropdownColor: AppColors.cardcolor,
                          underline: Container(
                            height: 0,
                            color: Colors.white,
                          ),
                          hint: const Text("Pilih Jenis Kelamin"),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                            _jeinsTextController.text = value!;
                          },
                          items: list
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        )),
                      ],
                    )),
                    Expanded(
                        child: reusableTextField1("nama", _namaTextController)),
                  ],
                ),
              ),
              const Divider(
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
                    const Expanded(child: Text('Usia')),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: reusableTextField1(
                                "Usia", _usiaTextController)),
                        const Text(" Tahun"),
                      ],
                    )),
                  ],
                ),
              ),
              const Divider(
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
                    Expanded(child: const Text('Riwayat penyakit')),
                    Expanded(
                        child: reusableTextField1(
                            "Riwayat Penyakit", _riwayatTextController)),
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
        title: Text("Edit Informasi Keluarga"),
        backgroundColor: AppColors.appBarColor,
        iconTheme: IconThemeData(color: AppColors.buttonIconColor),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  context.go("/home/dataKeluarga/infoKeluarga");
                },
                child: const Icon(
                  Icons.save_sharp,
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
            const Text(
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
