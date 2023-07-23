import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/service/SharedPreferenceHelper.dart';
import 'package:tbc_app/theme/app_colors.dart';

class CardButton extends StatelessWidget {
  int no;
  CardButton({
    Key? key,
    required this.no,
  }) : super(key: key);

  final DioClient _dioClient = DioClient();
  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardButtonColor,
      elevation: 30.0,
      child: SizedBox(
        height: 120,
        width: 120,
        child: InkWell(
          onTap: () async {
            context.goNamed(menuDetails[no]['pageName']);
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  menuDetails[no]['icon'],
                  size: 50,
                  color: AppColors.buttonColor,
                ),
                Text(
                  menuDetails[no]['title'],
                  style: TextStyle(color: AppColors.appBarTextColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
