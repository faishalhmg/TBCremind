import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/quiz/hasil_quiz.dart';
import 'package:tbc_app/data/Models/quiz/quiz.dart';
import 'package:tbc_app/data/Models/quiz/quizez.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';
import 'package:tbc_app/view/pasien/haislKuis.dart';

import '../../data/cardMenuTileMap.dart';

class kuisioner extends StatefulWidget {
  int? id;
  kuisioner({this.id, super.key});

  @override
  State<kuisioner> createState() => _kuisionerState();
}

class _kuisionerState extends State<kuisioner> {
  final DioClient _dioClient = DioClient();

  Quizez? quiz;
  bool? jawaban;

  @override
  void initState() {
    getquiz();

    super.initState();
  }

  List status = [];
  // void getstatus() async {
  //   final data = await _dioClient.getStatusQuiz();
  //   setState(() {
  //     status = data;
  //   });
  // }

  void getquiz() async {
    final data1 = await _dioClient.getStatusQuiz();
    setState(() {
      status = data1;
    });
    Quizez? data = await _dioClient.getQuizz(int.parse(status[0]['quiz_id']));
    setState(() {
      quiz = data;
    });
  }

  void postHasil() async {
    await _dioClient.postHasil(
        hasil_kuis: Hasil_kuis(
            id_pasien: widget.id,
            id_quiz: int.parse(status[0]['quiz_id']),
            hasil: userAnswers));
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

  int currentQuestionIndex = 0;
  List<int> userAnswers = [];

  void answerQuestion(int answerIndex) {
    setState(() {
      userAnswers.add(answerIndex);
      currentQuestionIndex++;

      if (currentQuestionIndex >= quiz!.question!.length) {
        // Kuis selesai, tampilkan hasil
        postHasil();
        showResultPage();
      }
    });
  }

  void backAnswerQuestion(int answerIndex) {
    setState(() {
      userAnswers.removeLast();
      currentQuestionIndex--;

      if (currentQuestionIndex >= quiz!.question!.length) {
        // Kuis selesai, tampilkan hasil
        postHasil();
        showResultPage();
      }
    });
  }

  void showResultPage() {
    // Lakukan sesuatu untuk menampilkan halaman hasil, misalnya:

    context.replaceNamed('hasilkuis', extra: int.parse(status[0]['quiz_id']));
  }

  @override
  Widget build(BuildContext context) {
    if (quiz == null) {
      return Scaffold(
          appBar: AppBar(
            title: Text(cardmenuDetailsTile[1]['title']),
            backgroundColor: AppColors.appBarColor,
            iconTheme: IconThemeData(color: AppColors.buttonIconColor),
          ),
          backgroundColor: AppColors.pageBackground,
          body: Center(
            child: const Center(
                child: CircularProgressIndicator(
              color: AppColors.statusBarColor,
            )),
          ));
    }
    int quizid = int.parse(quiz?.quiz![0]['id']);
    return Scaffold(
        appBar: AppBar(
          title: Text(cardmenuDetailsTile[1]['title']),
          backgroundColor: AppColors.appBarColor,
          iconTheme: IconThemeData(color: AppColors.buttonIconColor),
        ),
        backgroundColor: AppColors.pageBackground,
        body: currentQuestionIndex < quiz!.question!.length
            ? Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: CardViewTextrich(quiz!
                            .question![currentQuestionIndex]['quiz_id']
                            .toString()
                            .contains(quizid.toString())
                        ? quiz!.question![currentQuestionIndex]['question_text']
                            .toString()
                        : ''),
                  ),
                  Divider(
                    color: AppColors.statusBarColor,
                    indent: 10,
                    endIndent: 10,
                  ),
                  RadioListTile(
                    activeColor: AppColors.buttonColor,
                    title: Text(quiz!.answer![quiz!.answer!.indexWhere(
                            (element) =>
                                element["question_id"] ==
                                quiz!.question![currentQuestionIndex]
                                    ['id'])]['answer_text']
                        .toString()),
                    value: quiz!.answer![quiz!.answer!.indexWhere((element) =>
                                element["question_id"] ==
                                quiz!.question![currentQuestionIndex]
                                    ['id'])]['is_correct']
                            .toString()
                            .contains('1')
                        ? true
                        : false,
                    groupValue: jawaban,
                    onChanged: (value) {
                      setState(() {
                        jawaban = value;
                      });
                    },
                  ),
                  RadioListTile(
                    activeColor: AppColors.buttonColor,
                    title: Text(quiz!.answer![quiz!.answer!.lastIndexWhere(
                            (element) =>
                                element["question_id"] ==
                                quiz!.question![currentQuestionIndex]
                                    ['id'])]['answer_text']
                        .toString()),
                    value: quiz!.answer![quiz!.answer!.lastIndexWhere(
                                (element) =>
                                    element["question_id"] ==
                                    quiz!.question![currentQuestionIndex]
                                        ['id'])]['is_correct']
                            .toString()
                            .contains('1')
                        ? true
                        : false,
                    groupValue: jawaban,
                    onChanged: (value) {
                      setState(() {
                        jawaban = value;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentQuestionIndex > 0
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (jawaban == true) {
                                    backAnswerQuestion(1);
                                  } else {
                                    backAnswerQuestion(0);
                                  }
                                });
                              },
                              child: Text('Pertanyaan sebelumnya'),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll<Color>(
                                          AppColors.buttonColor)),
                            )
                          : Container(),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (jawaban == true) {
                            answerQuestion(1);
                          } else {
                            answerQuestion(0);
                          }
                        },
                        child:
                            currentQuestionIndex == quiz!.question!.length - 1
                                ? Text('selesai')
                                : Text('lanjut'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                AppColors.buttonColor)),
                      ),
                    ],
                  )
                ],
              )
            : Center(
                child: Text('Kuis telah selesai'),
              ));
  }
}
