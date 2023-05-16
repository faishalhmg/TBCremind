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
        height: 160,
        width: 100,
        child: InkWell(
          splashColor: AppColors.sidebar,
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Wrap(
                  spacing: 150,
                  children: [
                    const Icon(Icons.notifications),
                    const Text('Judul Notifikasi'),
                    const Text('Tanggal')
                  ],
                ),
                const SizedBox(
                  height: 100,
                  width: 100,
                  child: Text('Isi Notof'),
                ),
                const SizedBox(
                  child: Text('pengirim'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
