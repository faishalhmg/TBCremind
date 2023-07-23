import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tbc_app/bloc/bloc/bloc/edukasi_bloc.dart';
import 'package:tbc_app/data/Models/edukasi/edukasi.dart';

import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/service/StorageService.dart';
import 'package:tbc_app/theme/app_colors.dart';
import 'package:video_player/video_player.dart';

import '../../bloc/bloc/user_bloc.dart';

class EdukasiTBCShow extends StatefulWidget {
  int? id;
  EdukasiTBCShow({super.key, this.id});

  @override
  State<EdukasiTBCShow> createState() => _EdukasiTBCShowState();
}

class _EdukasiTBCShowState extends State<EdukasiTBCShow> {
  Edukasi? edukasi1;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;
  bool _visible = true;
  bool _isVideoPlaying = false;
  String? roles;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final edukasiBloc = context.read<EdukasiBloc>();
      edukasiBloc.add(LoadEdukasi1Event(id: widget.id ?? 0));
    });
  }

  void _toggleVideoPlayback() {
    setState(() {
      if (_chewieController!.videoPlayerController.value.isPlaying) {
        _chewieController?.pause();
        _isVideoPlaying = false;
      } else {
        _chewieController?.play();
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

  // ignore: non_constant_identifier_names
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
      child: BlocProvider(
        create: (context) => UserBloc()..add(CheckSignInStatus()),
        child: BlocBuilder<EdukasiBloc, EdukasiState>(
          builder: (context, state) {
            if (state is EdukasiLoadingState) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(menuDetails[5]['title']),
                  backgroundColor: AppColors.appBarColor,
                  iconTheme:
                      const IconThemeData(color: AppColors.buttonIconColor),
                  actions: <Widget>[
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserSignedIn) {
                          if (!state.userModel.role!.contains('pasien')) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: GestureDetector(
                                onTap: () {
                                  context.pushReplacementNamed('editEdukasi',
                                      extra: widget.id);
                                },
                                child: const Icon(
                                  Icons.lock_clock_rounded,
                                  size: 26.0,
                                  color: AppColors.appBarIconColor,
                                ),
                              ),
                            );
                          }
                        }
                        return Container();
                      },
                    )
                  ],
                ),
                backgroundColor: AppColors.pageBackground,
                body: Center(
                    child: CircularProgressIndicator(
                  color: AppColors.statusBarColor,
                )),
              );
            }
            if (state is Edukasi1LoadedState) {
              if (edukasi1 != null) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(edukasi1?.judul.toString() ?? ''),
                    backgroundColor: AppColors.appBarColor,
                    iconTheme:
                        const IconThemeData(color: AppColors.buttonIconColor),
                    leading: BackButton(
                      onPressed: () {
                        context.pushReplacementNamed('edukasiTBC');
                      },
                    ),
                    actions: <Widget>[
                      BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserSignedIn) {
                            if (!state.userModel.role!.contains('pasien')) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    context.pushReplacementNamed('editEdukasi',
                                        extra: widget.id);
                                  },
                                  child: const Icon(
                                    Icons.lock_clock_rounded,
                                    size: 26.0,
                                    color: AppColors.appBarIconColor,
                                  ),
                                ),
                              );
                            }
                          }
                          return Container();
                        },
                      )
                    ],
                  ),
                  backgroundColor: AppColors.pageBackground,
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    child: Wrap(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Card(
                              color: AppColors.appBarColor,
                              child: Center(
                                child: SizedBox(
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    fit: StackFit.passthrough,
                                    children: [
                                      edukasi1!.media
                                              .toString()
                                              .contains('.mp4')
                                          ? Chewie(
                                              controller: _chewieController!,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  'https://tbc.restikol.my.id/assets/uploads/' +
                                                      edukasi1!.media
                                                          .toString(),
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) => Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                    ],
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
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(edukasi1!.isi.toString()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(menuDetails[5]['title']),
                backgroundColor: AppColors.appBarColor,
                iconTheme:
                    const IconThemeData(color: AppColors.buttonIconColor),
                actions: <Widget>[],
              ),
              backgroundColor: AppColors.pageBackground,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }
}
