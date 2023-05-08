import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/data/cardMenuTileMap.dart';
import 'package:tbc_app/theme/app_colors.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
                    const Expanded(child: Text('Jenis Kelamin')),
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
                    const Expanded(child: Text('Pesawaran')),
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
                    const Expanded(child: Text('20' + ' Tahun')),
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
                    const Expanded(child: Text('08xxxxxxxxx')),
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
                    const Expanded(child: Text('O')),
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
                    const Expanded(child: Text('65' + ' Kg')),
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
                    const Expanded(child: Text('Hendra')),
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
                    const Expanded(child: Text('Asbiq')),
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
                    const Expanded(child: Text('Yuan')),
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
        title: Text("Profile"),
        backgroundColor: AppColors.appBarColor,
        iconTheme: IconThemeData(color: AppColors.buttonIconColor),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  context.go("/home/profile/edit");
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
