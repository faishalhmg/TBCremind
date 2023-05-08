import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/components/reusablecomp.dart';
import 'package:tbc_app/theme/app_colors.dart';

import '../../data/cardMenuTileMap.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _jkTextController = TextEditingController();
  TextEditingController _alamatTextController = TextEditingController();
  TextEditingController _usiaTextController = TextEditingController();
  TextEditingController _nohpTextController = TextEditingController();
  TextEditingController _goldarTextController = TextEditingController();
  TextEditingController _bbTextController = TextEditingController();
  TextEditingController _kadertbTextController = TextEditingController();
  TextEditingController _pmoTextController = TextEditingController();
  TextEditingController _petkesehatanTextController = TextEditingController();
  String selectedValue = "Laki-Laki";
  static const List<String> list = <String>['Laki-Laki', 'Perempuan'];

  Widget cardviewprofil() {
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
                    const Expanded(child: Text('Jenis Kelamin')),
                    Expanded(
                        child: DropdownButton<String>(
                      dropdownColor: AppColors.cardcolor,
                      underline: Container(height: 0, color: Colors.white),
                      hint: const Text("Pilih Jenis Kelamin"),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                        _jkTextController.text = value!;
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                    const Expanded(child: Text('Alamat')),
                    Expanded(
                        child: reusableTextField1(
                            "Alamat", _alamatTextController)),
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
                                  "usia", _usiaTextController)),
                          const Text(" Tahun"),
                        ],
                      ),
                    ),
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
                    const Expanded(child: Text('No Hp')),
                    Expanded(
                        child: reusableTextField1("nohp", _nohpTextController)),
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
                    const Expanded(child: Text('Golongan Darah')),
                    Expanded(
                        child: reusableTextField1(
                            "goldar", _goldarTextController)),
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
                    const Expanded(child: Text('Berat Badan')),
                    Expanded(
                        child: reusableTextField1(
                            "Berat Badan", _bbTextController)),
                  ],
                ),
              ),
              const Divider(
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

  Widget cardviewprofilext() {
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
                    const Expanded(child: Text('KaderTB')),
                    Expanded(
                        child: reusableTextField1(
                            "KaderTB", _kadertbTextController)),
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
                    const Expanded(child: Text('PMO')),
                    Expanded(
                        child: reusableTextField1("PMO", _pmoTextController)),
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
                    const Expanded(child: Text('Pet Kesehatan')),
                    Expanded(
                      child: reusableTextField1(
                          "Pet Kesehatan", _petkesehatanTextController),
                    ),
                  ],
                ),
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
        title: Text("Profile Edit"),
        backgroundColor: AppColors.appBarColor,
        iconTheme: IconThemeData(color: AppColors.buttonIconColor),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  context.go("/home/profile");
                },
                child: Icon(
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
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://www.flaticon.com/free-icon/account_3033143?term=user&page=1&position=34&origin=search&related_id=3033143'),
              radius: 40.0,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Nama Pasien',
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Nik Pasien',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 15,
            ),
            cardviewprofil(),
            const SizedBox(
              height: 15,
            ),
            cardviewprofilext(),
          ],
        ),
      ),
    );
  }
}
