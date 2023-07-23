import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tbc_app/data/Models/alarm/periksa_model/periksa_data_model.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/helper/alarm_helper.dart';
import 'package:tbc_app/provider/periksa_provider.dart';
import 'package:tbc_app/theme/app_colors.dart';
import 'package:tbc_app/view/pasien/pengingat/PengingatObat.dart';
import 'package:tbc_app/view/pasien/periksa/configPeriksa.dart';

class PeriksaDahak extends StatefulWidget {
  const PeriksaDahak({
    super.key,
  });

  @override
  State<PeriksaDahak> createState() => _PeriksaDahakState();
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

bool isSearchOpen = false;
String searchQuery = '';

class _PeriksaDahakState extends State<PeriksaDahak> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menuDetails[2]['title']),
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
                  context.pushNamed('configPeriksa');
                },
                child: Icon(
                  Icons.add_box_sharp,
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
            padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
            child: PeriksaScheet(),
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

class PeriksaScheet extends StatefulWidget {
  const PeriksaScheet({
    Key? key,
  }) : super(key: key);

  @override
  State<PeriksaScheet> createState() => _PeriksaScheetState();
}

class _PeriksaScheetState extends State<PeriksaScheet>
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
      child: Selector<PeriksaModel, PeriksaModel>(
        shouldRebuild: (previous, next) {
          if (next.state is PeriksaCreated) {
            final state = next.state as PeriksaCreated;
            _listKey.currentState?.insertItem(state.index);
          } else if (next.state is PeriksaUpdate) {
            final state = next.state as PeriksaUpdate;
            if (state.index != state.newIndex) {
              _listKey.currentState?.insertItem(state.newIndex);
              _listKey.currentState?.removeItem(
                state.index,
                (context, animation) => CardViewDahak(
                  alarm: state.periksa,
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
              if (model.periksas != null)
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    // not recommended for a list with large number of items
                    shrinkWrap: true,
                    initialItemCount: model.periksas!.length,

                    itemBuilder: (context, index, animation) {
                      if (index >= model.periksas!.length) return Container();
                      final alarm = model.periksas![index];
                      if (searchQuery.isNotEmpty &&
                          !alarm.lokasi
                              .toString()
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase())) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          CardViewDahak(
                              alarm: alarm,
                              animation: animation,
                              onDelete: () async {
                                _listKey.currentState?.removeItem(
                                  index,
                                  (context, animation) => CardViewDahak(
                                    alarm: alarm,
                                    animation: animation,
                                  ),
                                );
                                await model.deletePeriksa(alarm, index);
                              },
                              onTap: () async {
                                context.goNamed('configPeriksa',
                                    extra: ModifyAlarmPeriksaScreenArg(
                                        alarm, index));
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

class CardViewDahak extends StatelessWidget {
  const CardViewDahak({
    Key? key,
    required this.alarm,
    required this.animation,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  final PeriksaDataModel alarm;
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
                Text(
                  fromTimeToString(alarm.time),
                  style: TextStyle(fontSize: 50),
                ),
                Text(
                  'Tanggal Awal : ' +
                      '${alarm.date1.day}-${alarm.date1.month}-${alarm.date1.year}',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'Tanggal Selanjutnya : ' +
                      '${alarm.date2!.day}-${alarm.date2!.month}-${alarm.date2!.year}',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Lokasi : ' +
                      truncateWithEllipsis(20, alarm.lokasi.toString()),
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: onTap,
                  icon: Icon(Icons.edit_calendar),
                  color: AppColors.buttonColor,
                  iconSize: 50,
                ),
                IconButton(
                  onPressed: () async {
                    if (onDelete != null) onDelete!();
                  },
                  icon: Icon(Icons.event_busy),
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
