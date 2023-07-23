import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/bloc/efek_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/pasien_bloc.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

class DataUser extends StatefulWidget {
  const DataUser({super.key});

  @override
  State<DataUser> createState() => _DataUserState();
}

class _DataUserState extends State<DataUser> {
  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  bool isSearchOpen = false;
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data User'),
          backgroundColor: AppColors.appBarColor,
          iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(40, 3, 0, 0),
              child: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    isSearchOpen = !isSearchOpen;
                  });
                },
              ),
            ),
            if (isSearchOpen)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(40, 3, 0, 0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    context.pushReplacementNamed('tambahUser');
                  },
                  child: const Icon(
                    Icons.add,
                    size: 26.0,
                    color: AppColors.appBarIconColor,
                  ),
                )),
          ],
        ),
        backgroundColor: AppColors.pageBackground,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocProvider(
            create: (context) =>
                PasienBloc(DioClient())..add(const LoadPasienEvent()),
            child: BlocBuilder<PasienBloc, PasienState>(
              builder: (context, state) {
                if (state is PasienLoadingState) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: AppColors.statusBarColor,
                  ));
                }
                if (state is UserPasienState) {
                  List pasienList = state.userModel.toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: pasienList.length,
                    itemBuilder: (context, index) {
                      if (searchQuery.isNotEmpty &&
                          !pasienList[index]
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase())) {
                        return const SizedBox.shrink();
                      }
                      return BlocProvider(
                        create: (context) => EfekBloc(DioClient())
                          ..add(LoadEfekEvent(
                              id: int.parse(pasienList[index]['id']))),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                // context.goNamed("DataUserFull", queryParams: {
                                //   'email':
                                //       pasienList[index]['email'].toString(),
                                //   'id': pasienList[index]['id'].toString()
                                // });
                              },
                              child: Card(
                                color: AppColors.cardcolor,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.account_box_sharp, size: 100),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            truncateWithEllipsis(
                                                19,
                                                pasienList[index]['nama']
                                                    .toString()),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Text(
                                            truncateWithEllipsis(
                                                19,
                                                pasienList[index]['role']
                                                    .toString()),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              indent: 10,
                              endIndent: 10,
                              thickness: 1,
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
                return Container();
              },
            ),
          ),
        ));
  }
}
