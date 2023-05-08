import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:tbc_app/data/cardMenuTileMap.dart';
import 'package:tbc_app/theme/app_colors.dart';

class CardviewTile extends StatelessWidget {
  const CardviewTile({super.key, this.id});
  final id;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardcolor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SizedBox(
        height: 150,
        width: 500,
        child: InkWell(
          splashColor: AppColors.sidebar,
          onTap: () {
            context.go(cardmenuDetailsTile[id]['pageName']);
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
  }
}
