import 'package:flutter/material.dart';

import 'package:tbc_app/theme/app_colors.dart';

class Cardview extends StatelessWidget {
  const Cardview({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: InkWell(
          splashColor: AppColors.sidebar,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Judul Notifikasi'),
                    SizedBox(
                      width: 150,
                    ),
                    Text('Tanggal')
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 120,
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Isi Notof'),
                    ],
                  ),
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('pengirim'),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
