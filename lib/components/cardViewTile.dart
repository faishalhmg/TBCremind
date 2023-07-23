import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';

import 'package:tbc_app/data/cardMenuTileMap.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

class CardviewTile extends StatefulWidget {
  final id;
  const CardviewTile({
    super.key,
    this.id,
  });

  @override
  State<CardviewTile> createState() => _CardviewTileState();
}

class _CardviewTileState extends State<CardviewTile> {
  final DioClient _dioClient = DioClient();
  List hasil = [];

  List status = [];
  int? id_pasien;
  @override
  void initState() {
    getHasil();
    super.initState();
  }

  void getHasil() async {
    final data1 = await _dioClient.getStatusQuiz();
    setState(() {
      status = data1;
    });
    final data = await _dioClient.getHasil(int.parse(status[0]['quiz_id']));
    setState(() {
      hasil = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserSignedIn) {
          return Card(
            color: AppColors.cardcolor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: SizedBox(
              height: 150,
              width: 500,
              child: InkWell(
                splashColor: AppColors.sidebar,
                onTap: () {
                  if (cardmenuDetailsTile[widget.id]['pageName'] ==
                      'kuisioner') {
                    if (hasil[0]['id_pasien'].toString() ==
                        state.userModel.id.toString()) {
                      context.replaceNamed(
                        'hasilkuis',
                        extra: int.tryParse(status[0]['quiz_id']),
                      );
                    } else {
                      context.replaceNamed(
                        cardmenuDetailsTile[widget.id]['pageName'],
                        extra: state.userModel.id,
                      );
                    }
                  } else {
                    context.goNamed(
                      cardmenuDetailsTile[widget.id]['pageName'],
                    );
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                        child: Center(
                            child: Text(
                      cardmenuDetailsTile[widget.id]['title'],
                      style: const TextStyle(fontSize: 30),
                    )))
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(
            child: CircularProgressIndicator(
          color: AppColors.buttonColor,
        ));
      },
    );
  }
}
