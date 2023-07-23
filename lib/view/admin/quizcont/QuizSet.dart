import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/bloc/efek_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/pasien_bloc.dart';
import 'package:tbc_app/data/Models/quiz/status_quiz.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

import '../../../data/Models/quiz/quiz.dart';

class DataKuis extends StatefulWidget {
  const DataKuis({super.key});

  @override
  State<DataKuis> createState() => _DataKuisState();
}

class _DataKuisState extends State<DataKuis> {
  final DioClient _dioClient = DioClient();

  @override
  void initState() {
    getstatus();
    getquiz();

    super.initState();
  }

  void getquiz() async {
    final data = await _dioClient.getQuiz();
    setState(() {
      quiz = data;
    });
  }

  void getstatus() async {
    final data = await _dioClient.getStatusQuiz();
    setState(() {
      status = data;
    });
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  List status = [];
  List quiz = [];
  bool isSearchOpen = false;
  String searchQuery = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data Kuis'),
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
                    context.replaceNamed('kuisPlus');
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
        body: status.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: quiz.length,
                    itemBuilder: (context, index) {
                      if (searchQuery.isNotEmpty &&
                          !quiz[index]["quiz_title"]
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase())) {
                        return const SizedBox.shrink();
                      }
                      final key = quiz[index]['id'];
                      return Dismissible(
                        key: Key(key),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: AppColors.cardcolor,
                                  title: const Text('Hapus Edukasi'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text('Yakin Menghapus data kuis?'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text(
                                        'Hapus',
                                        style: TextStyle(
                                            color: AppColors.buttonColor),
                                      ),
                                      onPressed: () async {
                                        await _dioClient.deleteQuiz(
                                            quizId: int.parse(key));
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('cancel',
                                          style: TextStyle(
                                              color: AppColors.buttonColor)),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                context.replaceNamed("kuisShow",
                                    extra: int.parse(quiz[index]['id']));
                              },
                              child: Card(
                                color: AppColors.cardcolor,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.quiz,
                                                color:
                                                    AppColors.buttonIconColor,
                                                size: 50,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0)),
                                              Text(
                                                truncateWithEllipsis(
                                                    30,
                                                    "Judul Quiz : " +
                                                        quiz[index]
                                                                ["quiz_title"]
                                                            .toString()),
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ),

                                          // Text(
                                          //   truncateWithEllipsis(
                                          //       19,
                                          //       pasienList[index]['role']
                                          //           .toString()),
                                          //   style: TextStyle(fontSize: 20),
                                          // ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              if (!status[0]['quiz_id']
                                                  .toString()
                                                  .contains(quiz[index]["id"]
                                                      .toString())) {
                                                return await showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            AppColors.cardcolor,
                                                        title: const Text(
                                                            'Active Quiz'),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: ListBody(
                                                            children: <Widget>[
                                                              Text(
                                                                  'Anda yakin untuk menjadikan quiz ini active untuk pasien?'),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                              'Activate',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .buttonColor),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              await _dioClient.updateStatusQuiz(
                                                                  id: 1,
                                                                  id_quiz: int.parse(
                                                                      quiz[index]
                                                                          [
                                                                          "id"]));
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true);
                                                              setState(() {
                                                                getstatus();
                                                              });
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: const Text(
                                                                'cancel',
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .buttonColor)),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false);
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    });
                                              } else {
                                                return null;
                                              }
                                            },
                                            icon: status[0]['quiz_id']
                                                    .toString()
                                                    .contains(quiz[index]["id"]
                                                        .toString())
                                                ? Icon(
                                                    Icons.brightness_1,
                                                    color: Colors.green,
                                                  )
                                                : Icon(
                                                    Icons.brightness_1,
                                                    color: Colors.red,
                                                  ),
                                            color: AppColors.buttonColor,
                                            iconSize: 50,
                                          ),
                                        ],
                                      ),
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
                    }),
              )
            : Center(
                child: CircularProgressIndicator(
                color: AppColors.buttonColor,
              )));
  }
}
