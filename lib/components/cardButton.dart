import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/theme/app_colors.dart';

class CardButton extends StatelessWidget {
  int no;
  CardButton({Key? key, required this.no}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardButtonColor,
      elevation: 30.0,
      child: SizedBox(
        height: 150,
        width: 150,
        child: InkWell(
          onTap: () {
            context.go(menuDetails[no]['pageName']);
          },
          child: Center(
            child: Column(
              children: [
                Icon(menuDetails[no]['icon']),
                Text(menuDetails[no]['title'])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
