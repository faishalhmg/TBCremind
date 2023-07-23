import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tbc_app/theme/app_colors.dart';

class EfekObatPasien extends StatelessWidget {
  final String? tawal;
  final String? takhir;
  final String? dosis;
  final String? efek;
  const EfekObatPasien(
      {super.key, this.tawal, this.takhir, this.dosis, this.efek});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pasien'),
        backgroundColor: AppColors.appBarColor,
        iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
          ),
        ],
      ),
      backgroundColor: AppColors.pageBackground,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 50, 8, 0),
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: AppColors.sidebar,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
                        child: Row(
                          children: [
                            Text('Tanggal awal : '),
                            Text(tawal ?? '-')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
                        child: Row(
                          children: [
                            Text('Tanggal akhir : '),
                            Text(takhir ?? '-')
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                        child: Row(
                          children: [Text('Dosis : '), Text(dosis ?? '-')],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color.fromARGB(80, 255, 223, 153),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * (3 / 10),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(efek!.contains("null")
                              ? 'efek obat terhadap pasien belum di tambahkan'
                              : efek!),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
