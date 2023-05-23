import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tbc_app/data/Models/alarm/data_model/alarm_data_model.dart';
import 'package:tbc_app/data/Models/user/user_model.dart';
import 'package:tbc_app/data/buttonMenuMap.dart';
import 'package:tbc_app/data/cardMenuTileMap.dart';
import 'package:tbc_app/helper/alarm_helper.dart';
import 'package:tbc_app/provider/alarm_provider.dart';
import 'package:tbc_app/theme/app_colors.dart';
import 'package:tbc_app/view/pasien/pengingat/tambahpengingat.dart';

class PengingatObat extends StatelessWidget {
  const PengingatObat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(menuDetails[1]['title']),
          backgroundColor: AppColors.appBarColor,
          iconTheme: IconThemeData(color: AppColors.buttonIconColor),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed('tambahpengingat');
                  },
                  child: Icon(
                    Icons.lock_clock_rounded,
                    size: 26.0,
                    color: AppColors.appBarIconColor,
                  ),
                )),
          ],
        ),
        backgroundColor: AppColors.pageBackground,
        body: AlarmScheet());
  }
}

class AlarmScheet extends StatefulWidget {
  const AlarmScheet({
    Key? key,
  }) : super(key: key);

  @override
  State<AlarmScheet> createState() => _AlarmScheetState();
}

class _AlarmScheetState extends State<AlarmScheet>
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
      child: Selector<AlarmModel, AlarmModel>(
        shouldRebuild: (previous, next) {
          if (next.state is AlarmCreated) {
            final state = next.state as AlarmCreated;
            _listKey.currentState?.insertItem(state.index);
          } else if (next.state is AlarmUpdated) {
            final state = next.state as AlarmUpdated;
            if (state.index != state.newIndex) {
              _listKey.currentState?.insertItem(state.newIndex);
              _listKey.currentState?.removeItem(
                state.index,
                (context, animation) => CardViewWidget(
                  alarm: state.alarm,
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
                    child: Padding(
                      padding: EdgeInsets.all(10),
                    )),
              ),
              if (model.alarms != null)
                Expanded(
                  child: AnimatedList(
                    key: _listKey,
                    // not recommended for a list with large number of items
                    shrinkWrap: true,
                    initialItemCount: model.alarms!.length,

                    itemBuilder: (context, index, animation) {
                      if (index >= model.alarms!.length) return Container();
                      final alarm = model.alarms![index];

                      return Column(
                        children: [
                          CardViewWidget(
                              alarm: alarm,
                              animation: animation,
                              onDelete: () async {
                                _listKey.currentState?.removeItem(
                                  index,
                                  (context, animation) => CardViewWidget(
                                    alarm: alarm,
                                    animation: animation,
                                  ),
                                );
                                await model.deleteAlarm(alarm, index);
                              },
                              onTap: () async {
                                context.goNamed('tambahpengingat',
                                    extra: ModifyAlarmScreenArg(alarm, index));
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

class CardViewWidget extends StatelessWidget {
  const CardViewWidget({
    Key? key,
    required this.alarm,
    required this.animation,
    this.onDelete,
    this.onTap,
  }) : super(key: key);

  final AlarmDataModel alarm;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation.drive(
        Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).chain(CurveTween(curve: Curves.elasticInOut)),
      ),
      child: Card(
        elevation: 10,
        color: AppColors.cardcolor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                    'Judul',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    alarm.weekdays.isEmpty
                        ? 'Never'
                        : alarm.weekdays.length == 7
                            ? 'Everyday'
                            : alarm.weekdays
                                .map((weekday) =>
                                    fromWeekdayToStringShort(weekday))
                                .join(', '),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: onTap,
                    icon: Icon(Icons.punch_clock),
                    color: AppColors.buttonColor,
                    iconSize: 50,
                  ),
                  IconButton(
                    onPressed: () async {
                      if (onDelete != null) onDelete!();
                    },
                    icon: Icon(Icons.lock_clock_outlined),
                    color: AppColors.buttonColor,
                    iconSize: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
