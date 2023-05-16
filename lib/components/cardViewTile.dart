import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';

import 'package:tbc_app/data/cardMenuTileMap.dart';
import 'package:tbc_app/theme/app_colors.dart';

class CardviewTile extends StatelessWidget {
  final id;
  const CardviewTile({
    super.key,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Card(
          color: AppColors.cardcolor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: SizedBox(
            height: 150,
            width: 500,
            child: InkWell(
              splashColor: AppColors.sidebar,
              onTap: () {
                context.goNamed(
                  cardmenuDetailsTile[id]['pageName'],
                );
              },
              child: Column(
                children: [
                  Expanded(
                      child: Center(
                          child: Text(
                    cardmenuDetailsTile[id]['title'],
                    style: const TextStyle(fontSize: 30),
                  )))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
