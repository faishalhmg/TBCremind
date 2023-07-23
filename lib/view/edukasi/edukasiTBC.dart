import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tbc_app/bloc/bloc/bloc/edukasi_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/edukasi/edukasi.dart';

import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/routes/routers.dart';
import 'package:tbc_app/theme/app_colors.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EdukasiTBC extends StatefulWidget {
  EdukasiTBC({super.key});

  @override
  State<EdukasiTBC> createState() => _EdukasiTBCState();
}

class _EdukasiTBCState extends State<EdukasiTBC> {
  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  Future<Uint8List?> getVideoThumbnail(String videoUrl) async {
    try {
      Uint8List? thumbnailData = await VideoThumbnail.thumbnailData(
        video: videoUrl,
        imageFormat: ImageFormat.JPEG,
        quality: 100,
      );
      return thumbnailData;
    } catch (e) {
      print('Error generating thumbnail: $e');
      return null;
    }
  }

  bool isSearchOpen = false;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearchOpen ? Text(menuDetails[5]['title']) : null,
        backgroundColor: AppColors.appBarColor,
        iconTheme: const IconThemeData(color: AppColors.buttonIconColor),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(40, 3, 0, 0),
            child: IconButton(
              icon: Icon(Icons.search),
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
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserSignedIn) {
                    if (!state.userModel.role!.contains('pasien')) {
                      return GestureDetector(
                        onTap: () {
                          context.pushNamed('editEdukasi', extra: 0);
                          print(state.userModel.role);
                        },
                        child: const Icon(
                          Icons.lock_clock_rounded,
                          size: 26.0,
                          color: AppColors.appBarIconColor,
                        ),
                      );
                    }
                  }
                  return Container();
                },
              )),
        ],
      ),
      backgroundColor: AppColors.pageBackground,
      body: CardViewEdukasi(),
    );
  }

  Widget buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            searchQuery = value;
          });
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget CardViewEdukasi() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              EdukasiBloc(DioClient())..add(const LoadEdukasiEvent()),
        ),
        BlocProvider(
          create: (context) => UserBloc()..add(CheckSignInStatus()),
        ),
      ],
      child: BlocBuilder<EdukasiBloc, EdukasiState>(
        builder: (context, state) {
          if (state is EdukasiLoadingState) {
            return const Center(
                child: CircularProgressIndicator(
              color: AppColors.statusBarColor,
            ));
          }
          if (state is EdukasiLoadedState) {
            List edukasiList = state.edukasi;

            return ListView.builder(
              shrinkWrap: true,
              itemCount: edukasiList.length,
              itemBuilder: (BuildContext context, int index) {
                if (searchQuery.isNotEmpty &&
                    !edukasiList[index]['judul']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase())) {
                  return const SizedBox.shrink();
                }
                final dataedukasi = edukasiList[index]['id'];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      return Dismissible(
                        key: Key(dataedukasi),
                        confirmDismiss: (direction) async {
                          if (state is UserSignedIn &&
                              !state.userModel.role!.contains('pasien')) {
                            if (int.parse(edukasiList[index]['created_by']) ==
                                state.userModel.id) {
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
                                            Text(
                                                'Yakin Menghapus data Edukasi?'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        BlocProvider(
                                          create: (context) =>
                                              EdukasiBloc(DioClient())
                                                ..add(const LoadEdukasiEvent()),
                                          child: BlocBuilder<EdukasiBloc,
                                              EdukasiState>(
                                            builder: (context, state) {
                                              return TextButton(
                                                child: const Text(
                                                  'Hapus',
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .buttonColor),
                                                ),
                                                onPressed: () {
                                                  try {
                                                    context
                                                        .read<EdukasiBloc>()
                                                        .add(DeleteEdukasiEvent(
                                                            id: int.parse(
                                                                edukasiList[
                                                                        index]
                                                                    ['id']),
                                                            created_by: int.parse(
                                                                edukasiList[
                                                                        index][
                                                                    'created_by'])));
                                                  } catch (e) {
                                                    Navigator.of(context)
                                                        .pop(false);
                                                  }
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        TextButton(
                                          child: const Text('cancel',
                                              style: TextStyle(
                                                  color:
                                                      AppColors.buttonColor)),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              late BuildContext dialogContext;
                              showDialog<void>(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: AppColors.cardcolor,
                                      title:
                                          const Text('Tidak dapat menghapus'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                'Artikel edukasi ini bukan di buat olehmu! silahkan hubungi pemilik artikel atau hubungi admin'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text(
                                            "CANCEL",
                                            style: TextStyle(
                                                color: AppColors.buttonColor),
                                          ),
                                        )
                                      ],
                                    );
                                  });
                            }
                          }
                        },
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                context.pushReplacementNamed("showedukasi",
                                    extra:
                                        int.tryParse(edukasiList[index]['id']));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: AppColors.cardcolor,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Card(
                                        color: AppColors.appBarColor,
                                        child: Center(
                                          child: SizedBox(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              fit: StackFit.passthrough,
                                              children: [
                                                edukasiList[index]["media"]
                                                        .toString()
                                                        .contains('.mp4')
                                                    ? FutureBuilder<Uint8List?>(
                                                        future:
                                                            getVideoThumbnail(
                                                          'https://tbc.restikol.my.id/assets/uploads/' +
                                                              edukasiList[index]
                                                                      ["media"]
                                                                  .toString(),
                                                        ),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                                  .connectionState ==
                                                              ConnectionState
                                                                  .waiting) {
                                                            return CircularProgressIndicator(
                                                              color: AppColors
                                                                  .statusBarColor,
                                                            );
                                                          } else if (snapshot
                                                                  .hasData &&
                                                              snapshot.data !=
                                                                  null) {
                                                            return Image.memory(
                                                              snapshot.data!,
                                                              fit: BoxFit
                                                                  .fitWidth,
                                                            );
                                                          } else {
                                                            return Container(); // Tampilkan konten lain jika thumbnail tidak tersedia
                                                          }
                                                        },
                                                      )
                                                    : Image.network(
                                                        // ignore: prefer_interpolation_to_compose_strings
                                                        'https://tbc.restikol.my.id/assets/uploads/' +
                                                            edukasiList[index]
                                                                    ["media"]
                                                                .toString(),
                                                        fit: BoxFit.fitWidth,
                                                      ),
                                                edukasiList[index]["media"]
                                                        .toString()
                                                        .contains('.mp4')
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: const [
                                                            Icon(
                                                              Icons
                                                                  .play_circle_fill_rounded,
                                                              size: 80,
                                                              color: AppColors
                                                                  .buttonColor,
                                                            ),
                                                            Text(
                                                                '(Tumbnail Video)'),
                                                          ])
                                                    : Container()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        edukasiList[index]['judul'] ?? '',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        truncateWithEllipsis(
                                            40,
                                            edukasiList[index]['isi']
                                                .toString()),
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              indent: 10,
                              endIndent: 10,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
