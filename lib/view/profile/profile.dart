import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';

import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/cardMenuTileMap.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/service/SharedPreferenceHelper.dart';
import 'package:tbc_app/theme/app_colors.dart';

class Profile extends StatefulWidget {
  Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final DioClient _dioClient = DioClient();

  SharedPref sharedPref = SharedPref();

  Widget cardviewprofil() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Card(
          color: AppColors.cardcolor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
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
                        Expanded(
                            child: Text(state is UserSignedIn
                                ? state.userModel.jk!
                                : '-')),
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
                        Expanded(
                            child: Text(state is UserSignedIn
                                ? state.userModel.alamat!
                                : '-')),
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
                        Expanded(
                            child: Text(state is UserSignedIn
                                ? state.userModel.usia.toString()
                                : '-')),
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
                        Expanded(
                            child: Text(state is UserSignedIn
                                ? state.userModel.no_hp!
                                : '-')),
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
                        Expanded(
                            child: Text(state is UserSignedIn
                                ? state.userModel.goldar!
                                : '-')),
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
                        Expanded(
                            child: Text(state is UserSignedIn
                                ? state.userModel.bb!
                                : '-')),
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
      },
    );
  }

  Widget cardviewprofilext() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Card(
          color: AppColors.cardcolor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
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
                        Expanded(
                            child: Text(state is UserSignedIn
                                ? state.userModel.kaderTB!
                                : '-')),
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
                        Expanded(
                            child: Text(state is UserSignedIn
                                ? state.userModel.pmo!
                                : '-')),
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
                        Expanded(
                            child: Text(state is UserSignedIn
                                ? state.userModel.pet_kesehatan!
                                : '-')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
                  onTap: () async {
                    context.pushReplacementNamed('edit');
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
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserSignedIn) {
              return Padding(
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
                      state is UserSignedIn ? state.userModel.username! : '-',
                      style: TextStyle(fontSize: 25),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      state is UserSignedIn ? state.userModel.nik! : '-',
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
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
