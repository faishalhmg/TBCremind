import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/components/cardViewTile.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/cardMenuTileMap.dart';
import 'package:tbc_app/theme/app_colors.dart';

class Datakeluarga extends StatelessWidget {
  const Datakeluarga({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(CheckSignInStatus()),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Data Keluarga'),
              backgroundColor: AppColors.appBarColor,
              iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
            ),
            backgroundColor: AppColors.pageBackground,
            body: ListView.builder(
              itemCount: cardmenuDetailsTile.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CardviewTile(
                        id: index,
                      ),
                    ),
                    const Divider(
                      indent: 20,
                      endIndent: 20,
                    )
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
