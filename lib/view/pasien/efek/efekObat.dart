import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tbc_app/bloc/bloc/bloc/efek_bloc.dart';
import 'package:tbc_app/bloc/bloc/user_bloc.dart';
import 'package:tbc_app/data/Models/efek/efek.dart';
import 'package:tbc_app/data/Models/efek/efek_data_model.dart';
import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/data/dio/DioClient.dart';
import 'package:tbc_app/provider/efek_provider.dart';
import 'package:tbc_app/theme/app_colors.dart';
import 'package:tbc_app/view/pasien/efek/configEfek.dart';

class EfekObat extends StatefulWidget {
  const EfekObat({
    super.key,
  });

  @override
  State<EfekObat> createState() => _EfekObatState();
}

bool isSearchOpen = false;
String searchQuery = '';

class _EfekObatState extends State<EfekObat> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menuDetails[4]['title']),
        backgroundColor: AppColors.appBarColor,
        iconTheme: IconThemeData(color: AppColors.buttonIconColor),
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
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  context.pushNamed('configEfek');
                },
                child: Icon(
                  Icons.medical_services_sharp,
                  size: 26.0,
                  color: AppColors.appBarIconColor,
                ),
              )),
        ],
      ),
      backgroundColor: AppColors.pageBackground,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: EfekScheet(),
          ),
          Divider(
            indent: 10,
            endIndent: 10,
          )
        ],
      ),
    );
  }
}

class EfekScheet extends StatefulWidget {
  const EfekScheet({
    Key? key,
  }) : super(key: key);

  @override
  State<EfekScheet> createState() => _EfekScheetState();
}

class _EfekScheetState extends State<EfekScheet>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  AnimationController? _controller;
  Animation<double>? animation;
  bool expanded = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      )..addListener(() {
          setState(() {});
        });

      animation = Tween(
        begin: getSmallSize(),
        end: getBigSize(),
      ).animate(CurvedAnimation(
        parent: _controller!,
        curve: Curves.decelerate,
      ));
    });

    super.initState();
  }

  double getBigSize() => MediaQuery.of(context).size.height;

  double getSmallSize() {
    return MediaQuery.of(context).size.height * .8 -
        MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Selector<EfekModel, EfekModel>(
        shouldRebuild: (previous, next) {
          if (next.state is EfekCreate) {
            final state = next.state as EfekCreate;
            _listKey.currentState?.insertItem(state.index);
          } else if (next.state is EfekUpdate) {
            final state = next.state as EfekUpdate;
            if (state.index != state.newIndex) {
              _listKey.currentState?.insertItem(state.newIndex);
              _listKey.currentState?.removeItem(
                state.index,
                (context, animation) => CardViewEfek(
                  alarm: state.efek,
                  animation: animation,
                ),
              );
            }
          }
          return true;
        },
        selector: (_, model) => model,
        builder: (context, model, child) {
          return Column(
            children: [
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  if ((details.primaryDelta ?? 0) < 0 && !expanded) {
                    // dragging up, expand
                    _controller!.forward();
                  } else if ((details.primaryDelta ?? 0) > 0 && expanded) {
                    // dragging up, expand
                    _controller!.reverse();
                  }
                  setState(() {
                    expanded = !expanded;
                  });
                },
                child: Container(
                  width: double.infinity,
                  color: Colors.transparent,
                ),
              ),
              if (model.efeks != null)
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    // not recommended for a list with large number of items
                    shrinkWrap: true,
                    initialItemCount: model.efeks!.length,

                    itemBuilder: (context, index, animation) {
                      if (index >= model.efeks!.length) return Container();
                      final alarm = model.efeks![index];
                      if (searchQuery.isNotEmpty &&
                          !alarm.judul
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase())) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          CardViewEfek(
                              alarm: alarm,
                              animation: animation,
                              onDelete: () async {
                                _listKey.currentState?.removeItem(
                                  index,
                                  (context, animation) => CardViewEfek(
                                    alarm: alarm,
                                    animation: animation,
                                  ),
                                );
                                await model.deleteEfek(alarm, index);
                              },
                              onTap: () async {
                                context.goNamed('configEfek',
                                    extra: ModifyEfekScreenArg(alarm, index));
                              }),
                          const Divider(color: AppColors.statusBarColor),
                        ],
                      );
                    },
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

class CardViewEfek extends StatelessWidget {
  const CardViewEfek({
    Key? key,
    required this.alarm,
    required this.animation,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  final EfekDataModel alarm;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final Animation<double> animation;

  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: AppColors.cardcolor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${alarm.judul}', style: TextStyle(fontSize: 50)),
                Text(
                  'Tanggal Awal : ' +
                      '${alarm.p_awal.day}-${alarm.p_awal.month}-${alarm.p_awal.year}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Tanggal Selanjutnya : ' +
                      '${alarm.p_akhir!.day}-${alarm.p_akhir!.month}-${alarm.p_akhir!.year}',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: onTap,
                  icon: Icon(Icons.edit),
                  color: AppColors.buttonColor,
                  iconSize: 50,
                ),
                IconButton(
                  onPressed: () async {
                    if (onDelete != null) onDelete!();
                  },
                  icon: Icon(Icons.delete),
                  color: AppColors.buttonColor,
                  iconSize: 50,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
