import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/bloc/edukasi_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/components/reusablecomp.dart';
import 'package:tbc_app/data/Models/edukasi/edukasi.dart';

import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/theme/app_colors.dart';
import 'package:video_player/video_player.dart';

class EdukasiTBCEdit extends StatefulWidget {
  int? id;
  EdukasiTBCEdit({super.key, this.id});

  @override
  State<EdukasiTBCEdit> createState() => _EdukasiTBCEditState();
}

class _EdukasiTBCEditState extends State<EdukasiTBCEdit> {
  final TextEditingController _judulTextController = TextEditingController();

  final TextEditingController _isiTextController = TextEditingController();
  DateTime date = DateTime.now();
  Edukasi? edukasi1;
  File? file;
  Uint8List? xfile;
  Image? image;
  Widget? widgets;
  bool _isVideoInitialized = false;
  bool _visible = true;
  ChewieController? chewieController;
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;

  bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final edukasiBloc = context.read<EdukasiBloc>();
      edukasiBloc.add(LoadEdukasi1Event(id: widget.id ?? 0));
    });
  }

  Future getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4', 'gif', 'png', 'jpeg', 'jpg'],
    );
    if (result != null) {
      setState(() {
        file = File(result.files.single.path!);
        _isVideoPlaying = false;
      });

      if (file!.path.endsWith('.mp4')) {
        VideoPlayerController videoPlayerController =
            VideoPlayerController.file(file!);

        await videoPlayerController.initialize();
        chewieController = ChewieController(
          videoPlayerController: videoPlayerController,
          autoInitialize: true,
          autoPlay: true,
          looping: false,
          showControls: true,
          allowPlaybackSpeedChanging: true,
          allowFullScreen: true,
          materialProgressColors: ChewieProgressColors(
            playedColor: AppColors.statusBarColor,
            handleColor: AppColors.buttonColor,
            backgroundColor: AppColors.statusBarColor,
            bufferedColor: AppColors.buttonColor,
          ),
          placeholder: Container(
            color: AppColors.cardcolor,
          ),
        );

        setState(() {
          _isVideoInitialized = true;
          _isVideoPlaying = true;
        });
      }
    }
  }

  void _toggleVideoPlayback() {
    setState(() {
      if (chewieController!.videoPlayerController.value.isPlaying) {
        chewieController?.pause();
        _isVideoPlaying = false;
      } else {
        chewieController?.play();
        _isVideoPlaying = true;
      }
    });
  }

  Widget _buildPlayPauseIcon() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: _isVideoPlaying
            ? IconButton(
                key: ValueKey<bool>(true),
                icon: Icon(
                  Icons.pause_circle_filled_sharp,
                  color: AppColors.buttonColor,
                  size: 70,
                ),
                onPressed: () {
                  _toggleVideoPlayback();
                  _visible = true;
                },
              )
            : IconButton(
                key: ValueKey<bool>(false),
                icon: Icon(
                  Icons.play_circle_fill_sharp,
                  color: AppColors.buttonColor,
                  size: 70,
                ),
                onPressed: () {
                  _toggleVideoPlayback();
                  _visible = false;
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EdukasiBloc, EdukasiState>(
      listener: (context, state) {
        if (state is Edukasi1LoadedState) {
          setState(() {
            edukasi1 = state.edukasi;
            if (edukasi1 != null && edukasi1!.media != null) {
              _videoPlayerController = VideoPlayerController.network(
                'https://tbc.restikol.my.id/assets/uploads/' +
                    edukasi1!.media.toString(),
              );
              _chewieController = ChewieController(
                videoPlayerController: _videoPlayerController!,
                autoInitialize: true,
                autoPlay: true,
                looping: false,
                showControls: true,
                allowPlaybackSpeedChanging: true,
                allowFullScreen: true,
                materialProgressColors: ChewieProgressColors(
                  playedColor: AppColors.statusBarColor,
                  handleColor: AppColors.buttonColor,
                  backgroundColor: AppColors.statusBarColor,
                  bufferedColor: AppColors.buttonColor,
                ),
                placeholder: Container(
                  color: AppColors.cardcolor,
                ),
              );
            }
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(menuDetails[5]['title']),
          backgroundColor: AppColors.appBarColor,
          iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
          actions: <Widget>[
            BlocProvider(
              create: (context) => UserBloc()..add(CheckSignInStatus()),
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (widget.id != 0) {
                    return BlocProvider(
                      create: (context) => EdukasiBloc(DioClient())
                        ..add(LoadEdukasi1Event(id: widget.id!)),
                      child: BlocBuilder<EdukasiBloc, EdukasiState>(
                        builder: (context, state) {
                          return Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: GestureDetector(
                                onTap: () async {
                                  var judul, isi;
                                  if (_judulTextController.text.isEmpty) {
                                    judul = state is Edukasi1LoadedState
                                        ? state.edukasi.judul
                                        : '-';
                                  } else {
                                    judul = _judulTextController.text;
                                  }
                                  if (_isiTextController.text.isEmpty) {
                                    isi = state is Edukasi1LoadedState
                                        ? state.edukasi.isi
                                        : '-';
                                  } else {
                                    isi = _isiTextController.text;
                                  }
                                  context.read<EdukasiBloc>().add(
                                      UpdateEdukasiEvent(
                                          id: widget.id!,
                                          judul: judul,
                                          isi: isi,
                                          // ignore: prefer_if_null_operators
                                          media: file != null ? file : null,
                                          created_by:
                                              state is Edukasi1LoadedState
                                                  ? state.edukasi.created_by!
                                                  : 0,
                                          update_at: date));
                                  context.pushReplacementNamed('showedukasi',
                                      extra: widget.id!);
                                },
                                child: const Icon(
                                  Icons.save_as_sharp,
                                  size: 26.0,
                                  color: AppColors.appBarIconColor,
                                ),
                              ));
                        },
                      ),
                    );
                  } else {
                    return Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          onTap: () async {
                            context.read<EdukasiBloc>().add(AddEdukasiEvent(
                                  judul: _judulTextController.text.toString(),
                                  isi: _isiTextController.text.toString(),
                                  media: file != null ? file : null,
                                  created_by: state is UserSignedIn
                                      ? state.userModel.id!
                                      : 0,
                                  created_at: date,
                                ));
                            context.pushReplacementNamed('edukasiTBC');
                          },
                          child: const Icon(
                            Icons.add_task_sharp,
                            size: 26.0,
                            color: AppColors.appBarIconColor,
                          ),
                        ));
                  }
                },
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.pageBackground,
        body: SingleChildScrollView(child: CardViewEdukasi()),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CardViewEdukasi() {
    return BlocProvider(
      create: (context) =>
          EdukasiBloc(DioClient())..add(LoadEdukasi1Event(id: widget.id!)),
      child: BlocBuilder<EdukasiBloc, EdukasiState>(
        builder: (context, state) {
          if (state is EdukasiLoadingState) {
            return const Padding(
              padding: EdgeInsets.all(150),
              child: Center(
                  child: CircularProgressIndicator(
                color: AppColors.statusBarColor,
              )),
            );
          }
          if (state is Edukasi1LoadedState) {
            Edukasi edukasi1 = state.edukasi;
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Wrap(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: AppColors.appBarColor,
                        child: InkWell(
                          onTap: () {
                            if (file != null && file!.path.endsWith('.mp4')) {
                            } else {
                              getImage();
                            }
                          },
                          onDoubleTap: () {
                            if (file != null && file!.path.endsWith('.mp4')) {
                              getImage();
                            }
                          },
                          onLongPress: () {
                            if (file != null && file!.path.endsWith('.mp4')) {
                              getImage();
                            }
                          },
                          child: Center(
                            child: SizedBox(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                alignment: Alignment.center,
                                fit: StackFit.passthrough,
                                children: [
                                  if (edukasi1.id != 0) ...[
                                    if (file != null)
                                      _isVideoInitialized
                                          ? Chewie(
                                              controller: chewieController!,
                                            )
                                          : Image.file(file!, fit: BoxFit.cover)
                                    else
                                      edukasi1.media.toString().contains('.mp4')
                                          ? Chewie(
                                              controller: _chewieController!,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  'https://tbc.restikol.my.id/assets/uploads/' +
                                                      edukasi1.media.toString(),
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                  ],
                                  if (file != null)
                                    _isVideoInitialized
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.33,
                                                  child: _buildPlayPauseIcon()),
                                            ],
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: const [
                                                Icon(
                                                  Icons
                                                      .play_circle_fill_rounded,
                                                  size: 80,
                                                  color: AppColors.buttonColor,
                                                ),
                                                Text(
                                                  '(Upload Media)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ])
                                  else
                                    _isVideoInitialized
                                        ? Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.33,
                                                  child: _buildPlayPauseIcon()),
                                            ],
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: const [
                                                Icon(
                                                  Icons.cloud_upload_sharp,
                                                  size: 80,
                                                  color: AppColors.buttonColor,
                                                ),
                                                Text(
                                                  '(Upload Media)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      backgroundColor:
                                                          AppColors.sidebar),
                                                ),
                                              ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 10,
                  ),
                  Card(
                    color: AppColors.cardcolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('judul')),
                                  Expanded(
                                      child: reusableTextField1(
                                          edukasi1.id != 0
                                              ? edukasi1.judul.toString()
                                              : '',
                                          _judulTextController)),
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
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: const Expanded(child: Text('isi')),
                                  ),
                                  Expanded(
                                      child: reusableTextField2(
                                          edukasi1.id != 0
                                              ? edukasi1.isi.toString()
                                              : '',
                                          _isiTextController)),
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
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: AppColors.appBarColor,
                      child: InkWell(
                        onTap: () {
                          if (file != null && file!.path.endsWith('.mp4')) {
                            _toggleVideoPlayback();
                          } else {
                            getImage();
                          }
                        },
                        child: Center(
                          child: SizedBox(
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              alignment: Alignment.center,
                              fit: StackFit.passthrough,
                              children: [
                                if (file != null) ...[
                                  _isVideoInitialized
                                      ? Chewie(
                                          controller: chewieController!,
                                        )
                                      : Image.file(file!, fit: BoxFit.cover)
                                ],
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (file != null) ...[
                                        file!.path.contains('.mp4')
                                            ? Icon(
                                                Icons.play_circle_fill_rounded,
                                                size: 80,
                                                color: AppColors.buttonColor,
                                              )
                                            : Icon(
                                                Icons.cloud_upload_sharp,
                                                size: 80,
                                                color: AppColors.buttonColor,
                                              ),
                                        Text('(Upload Media)'),
                                      ] else ...[
                                        Icon(
                                          Icons.cloud_upload_sharp,
                                          size: 80,
                                          color: AppColors.buttonColor,
                                        ),
                                        Text('(Upload Media)'),
                                      ]
                                    ]),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  indent: 10,
                  endIndent: 10,
                ),
                Card(
                  color: AppColors.cardcolor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0)),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                            child: Row(
                              children: [
                                const Expanded(child: Text('judul')),
                                Expanded(
                                    child: reusableTextField1(
                                        '', _judulTextController)),
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
                              children: [
                                const Expanded(child: Text('isi')),
                                Expanded(
                                    child: reusableTextField1(
                                        '', _isiTextController)),
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
                ),
              ],
            ),
          );
          ;
        },
      ),
    );
  }

  @override
  void dispose() {
    chewieController?.dispose();
    super.dispose();
  }
}
