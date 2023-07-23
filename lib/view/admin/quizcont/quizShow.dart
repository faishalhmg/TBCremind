import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/bloc/efek_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/pasien_bloc.dart';
import 'package:tbc_app/data/Models/quiz/quizez.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';

import '../../../data/Models/quiz/quiz.dart';

class QuizShow extends StatefulWidget {
  int? quizid;
  QuizShow({this.quizid, super.key});

  @override
  State<QuizShow> createState() => _QuizShowState();
}

class _QuizShowState extends State<QuizShow> {
  final DioClient _dioClient = DioClient();
  Quizez? quiz;

  @override
  void initState() {
    getquiz();

    super.initState();
  }

  void getquiz() async {
    final data = await _dioClient.getQuizz(widget.quizid!);
    setState(() {
      quiz = data;
    });
  }

  Widget CardViewTextrich(String pertannyaan) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: AppColors.cardcolor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: 3000,
          height: 100,
          child: RichText(
              text: TextSpan(
                  text: pertannyaan,
                  style: TextStyle(color: Colors.black),
                  children: const <TextSpan>[])),
        ),
      ),
    );
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  @override
  Widget build(BuildContext context) {
    bool? jawaban;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data Kuis'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.appBarIconColor),
            onPressed: () => context.replaceNamed('dataKuis'),
          ),
          backgroundColor: AppColors.appBarColor,
          iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
          actions: <Widget>[],
        ),
        backgroundColor: AppColors.pageBackground,
        body: quiz != null
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(children: [
                    for (int index = 0;
                        index < quiz!.question!.length;
                        index++) ...[
                      Card(
                        color: AppColors.cardButtonColor,
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: CardViewTextrich(quiz!.question![index]
                                          ['quiz_id']
                                      .toString()
                                      .contains(widget.quizid.toString())
                                  ? quiz!.question![index]['question_text']
                                      .toString()
                                  : ''),
                            ),
                            Divider(
                              color: AppColors.statusBarColor,
                              indent: 10,
                              endIndent: 10,
                            ),
                            ListTile(
                              title: Text(quiz!.answer![quiz!.answer!
                                          .indexWhere((element) =>
                                              element["question_id"] ==
                                              quiz!.question![index]['id'])]
                                      ['answer_text']
                                  .toString()),
                              leading: quiz!.answer![quiz!.answer!.indexWhere(
                                              (element) =>
                                                  element["question_id"] ==
                                                  quiz!.question![index]
                                                      ['id'])]['is_correct']
                                          .toString() ==
                                      "1"
                                  ? Icon(Icons.check)
                                  : Icon(Icons.close),
                            ),
                            ListTile(
                              title: Text(quiz!.answer![quiz!.answer!
                                          .lastIndexWhere((element) =>
                                              element["question_id"] ==
                                              quiz!.question![index]['id'])]
                                      ['answer_text']
                                  .toString()),
                              leading: quiz!.answer![quiz!.answer!
                                              .lastIndexWhere((element) =>
                                                  element["question_id"] ==
                                                  quiz!.question![index]
                                                      ['id'])]['is_correct']
                                          .toString() ==
                                      "1"
                                  ? Icon(Icons.check)
                                  : Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ]),
                ))
            : Center(
                child: CircularProgressIndicator(
                color: AppColors.buttonColor,
              )));
  }
}
