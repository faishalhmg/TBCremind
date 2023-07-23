import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/bloc/efek_bloc.dart';
import 'package:tbc_app/bloc/bloc/bloc/pasien_bloc.dart';
import 'package:tbc_app/components/reusablecomp.dart';
import 'package:tbc_app/data/dio/AuthorizationInterceptor.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/data/dio/LoggerInterceptor.dart';
import 'package:tbc_app/service/StorageService.dart';
import 'package:tbc_app/theme/app_colors.dart';

import '../../../data/Models/quiz/quiz.dart';

class QuizPlus extends StatefulWidget {
  const QuizPlus({super.key});

  @override
  State<QuizPlus> createState() => _QuizPlusState();
}

class _GroupControllers {
  TextEditingController pertanyaan = TextEditingController();
  TextEditingController jawaban1 = TextEditingController();
  TextEditingController hasil1 = TextEditingController();
  TextEditingController jawaban2 = TextEditingController();
  TextEditingController hasil2 = TextEditingController();
  void dispose() {
    pertanyaan.dispose();
    jawaban1.dispose();
    hasil1.dispose();
    jawaban2.dispose();
    hasil2.dispose();
  }
}

class _QuizPlusState extends State<QuizPlus> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://tbc.restikol.my.id/',
      connectTimeout: Duration(seconds: 5000),
      receiveTimeout: Duration(seconds: 3000),
      responseType: ResponseType.json,
    ),
  )..interceptors.addAll([
      AuthorizationInterceptor(),
      LoggerInterceptor(),
      LogInterceptor(responseBody: true, requestBody: true)
    ]);
  List<_GroupControllers> _groupControllers = [];
  List<TextField> _pertanyaanFields = [];
  List<TextField> _jawaban1Fields = [];
  List<TextField> _hasil1Fields = [];
  List<TextField> _jawaban2Fields = [];
  List<TextField> _hasil2Fields = [];
  TextEditingController _titleTextController = TextEditingController();
  @override
  void dispose() {
    for (final controller in _groupControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  final DioClient _dioClient = DioClient();
  @override
  void initState() {
    getquiz();

    super.initState();
  }

  void getquiz() async {
    final data = await _dioClient.getQuiz();
    setState(() {
      quiz = data;
    });
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  List quiz = [];
  void request() async {
    final StorageService _storageService = StorageService();
    String? token = await _storageService.readSecureData('token');
    Response response;
    final formData = FormData.fromMap({
      'quiz_title': "${_titleTextController.text}",
      for (var index = 0; index < _groupControllers.length; index++)
        'questions[$index][question_text]':
            "${_groupControllers[index].pertanyaan.text}",
      for (var index = 0; index < _groupControllers.length; index++)
        'questions[$index][answers][0][answer_text]':
            "${_groupControllers[index].jawaban1.text}",
      for (var index = 0; index < _groupControllers.length; index++)
        'questions[$index][answers][0][is_correct]':
            _groupControllers[index].hasil1.text,
      for (var index = 0; index < _groupControllers.length; index++)
        'questions[$index][answers][1][answer_text]':
            "${_groupControllers[index].jawaban2.text}",
      for (var index = 0; index < _groupControllers.length; index++)
        'questions[$index][answers][1][is_correct]':
            _groupControllers[index].hasil2.text,
    });
    response = await dio.post('QuizController',
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }),
        data: formData);
    print(response.data.toString());
    context.replaceNamed("dataKuis");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Data Kuis'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.appBarIconColor),
            onPressed: () => context.replaceNamed('dataKuis'),
          ),
          backgroundColor: AppColors.appBarColor,
          iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    return await showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: AppColors.cardcolor,
                            title: const Text('Active Quiz'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                      'Yakin menyimpan data quiz?, harap periksa dikarenakan data quiz tidak bisa diubah kembali, jika ingin mengubah data quiz harap delete quiz sebelumnya dan membuat yang baru'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text(
                                  'Simpan',
                                  style:
                                      TextStyle(color: AppColors.buttonColor),
                                ),
                                onPressed: () async {
                                  Navigator.of(context).pop(true);
                                  request();
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
                  child: const Icon(
                    Icons.save,
                    size: 26.0,
                    color: AppColors.appBarIconColor,
                  ),
                )),
          ],
        ),
        backgroundColor: AppColors.pageBackground,
        body: Column(
          children: [
            _addTile(),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(child: Text('Judul Quiz')),
                  Expanded(
                      child: reusableTextField1("title", _titleTextController)),
                ],
              ),
            ),
            Expanded(child: _listView()),
          ],
        ));
  }

  Widget _addTile() {
    return ListTile(
      title: Icon(
        Icons.add,
        color: AppColors.sidebar,
      ),
      tileColor: AppColors.buttonColor,
      onTap: () {
        final group = _GroupControllers();

        final pertanyaanField =
            _generateTextField(group.pertanyaan, "pertanyaan");
        final jawaban1Field = _generateTextField(group.jawaban1, "jawaban1");
        final hasil1Field = _generateTextField1(group.hasil1, "hasil1");
        final jawaban2Field = _generateTextField(group.jawaban2, "jawaban2");
        final hasil2Field = _generateTextField1(group.hasil2, "hasil2");
        setState(() {
          _groupControllers.add(group);
          _pertanyaanFields.add(pertanyaanField);
          _jawaban1Fields.add(jawaban1Field);
          _hasil1Fields.add(hasil1Field);
          _jawaban2Fields.add(jawaban2Field);
          _hasil2Fields.add(hasil2Field);
        });
      },
    );
  }

  TextField _generateTextField1(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
      ],
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: hint,
      ),
    );
  }

  TextField _generateTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: hint,
      ),
    );
  }

  Widget _listView() {
    final children = [
      for (var i = 0; i < _groupControllers.length; i++)
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: AppColors.cardcolor,
                margin: EdgeInsets.all(5),
                child: InputDecorator(
                  child: Column(
                    children: [
                      _pertanyaanFields[i],
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      Row(
                        children: [
                          Expanded(child: _jawaban1Fields[i]),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Expanded(child: _hasil1Fields[i])
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(bottom: 10)),
                      Row(
                        children: [
                          Expanded(child: _jawaban2Fields[i]),
                          Padding(padding: EdgeInsets.only(left: 10)),
                          Expanded(child: _hasil2Fields[i])
                        ],
                      ),
                    ],
                  ),
                  decoration: InputDecoration(
                    labelText: i.toString(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
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
        )
    ];
    return SingleChildScrollView(
      child: Column(
        children: children,
      ),
    );
  }
}
