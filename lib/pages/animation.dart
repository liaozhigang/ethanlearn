import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_learning/pages/world_clock/model.dart';

class ClockColumn extends StatefulWidget {
  final int initDigit;
  final double height;
  final double width;
  final double fontSize;

  const ClockColumn({Key key, this.initDigit, this.height: 60, this.width: 20, this.fontSize: 20}) : super(key: key);

  @override
  _ClockColumnState createState() => _ClockColumnState();
}

class _ClockColumnState extends State<ClockColumn> with SingleTickerProviderStateMixin {
  double opacity;
  double offset;

  int curDigit;
  int oldDigit;

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    opacity = 0.0;
    offset = 1.0;
    curDigit = widget.initDigit;
    oldDigit = -1;

    controller = new AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic))..addListener(() {
      setState(() {
        opacity = controller.value;
        offset = 1.0 - controller.value;
      });
    });

    controller.forward();
  }

  void setDigit(int d) {
    if (d == curDigit) {
      return;
    }

    oldDigit = curDigit;
    curDigit = d;
    controller.reset();
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      decoration: BoxDecoration(
//        border: Border.all(),
//      ),
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: Align(
              alignment: Alignment(0.0, offset),
              child: Text(curDigit.toString(), style: TextStyle(fontSize: widget.fontSize * animation.value)),
            ),
          ),
          Opacity(
            opacity: 1.0 - opacity,
            child: Align(
              alignment: Alignment(0.0, offset - 1.0),
              child: Text(oldDigit >= 0 ? oldDigit.toString() : "", style: TextStyle(fontSize: (1.0 + animation.value - 2*controller.value)* widget.fontSize),),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedClockPage extends StatefulWidget {
  final String title;

  AnimatedClockPage({Key key, this.title:"Animated Clock"}) : super(key: key);
  @override
  _AnimatedClockPageState createState() => _AnimatedClockPageState();
}

class _AnimatedClockPageState extends State<AnimatedClockPage> {
  GlobalKey<_ClockColumnState> keySecondFirstDigit = GlobalKey();
  GlobalKey<_ClockColumnState> keySecondLastDigit = GlobalKey();
  GlobalKey<_ClockColumnState> keyMinuteFirstDigit = GlobalKey();
  GlobalKey<_ClockColumnState> keyMinuteLastDigit = GlobalKey();
  GlobalKey<_ClockColumnState> keyHourFirstDigit = GlobalKey();
  GlobalKey<_ClockColumnState> keyHourLastDigit = GlobalKey();
  Timer timer;

  var cityName = ExpandedCityInfo.englishName ??  "Local";
  DateTime cityTime = DateTime.now().toUtc().add(Duration(hours: ExpandedCityInfo.utcOffset ?? 0));

  bool get dayOrNight {
    return cityTime.hour > 7 && cityTime.hour < 20;
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int second = DateTime.now().second;
      int minute = DateTime.now().minute;
      int hour = cityTime.hour;
      keySecondFirstDigit.currentState.setDigit(second ~/ 10);
      keySecondLastDigit.currentState.setDigit(second % 10);
      keyMinuteFirstDigit.currentState.setDigit(minute ~/ 10);
      keyMinuteLastDigit.currentState.setDigit(minute % 10);
      keyHourFirstDigit.currentState.setDigit(hour ~/ 10);
      keyHourLastDigit.currentState.setDigit(hour % 10);

    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: dayOrNight ? AssetImage('lib/pages/world_clock/assets/day.png') : AssetImage('lib/pages/world_clock/assets/night.png'),
              fit: BoxFit.cover,
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(cityName, style: TextStyle(fontSize: 30,),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClockColumn(key: keyHourFirstDigit, width: 30, height: 90, fontSize: 40, initDigit: cityTime.hour ~/ 10,),
                  ClockColumn(key: keyHourLastDigit, width: 30, height: 90, fontSize: 40, initDigit: cityTime.hour % 10,),
                  Text(':', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  ClockColumn(key: keyMinuteFirstDigit, width: 30, height: 90, fontSize: 40, initDigit: DateTime.now().minute ~/ 10,),
                  ClockColumn(key: keyMinuteLastDigit, width: 30, height: 90, fontSize: 40, initDigit: DateTime.now().minute % 10,),
                  Text(':', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
                  ClockColumn(key: keySecondFirstDigit, width: 30, height: 90, fontSize: 40, initDigit: DateTime.now().second ~/ 10,),
                  ClockColumn(key: keySecondLastDigit, width: 30, height: 90, fontSize: 40, initDigit: DateTime.now().second % 10,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ClockAnimation extends StatefulWidget {
  final int utcOffset;

  ClockAnimation(this.utcOffset);

  @override
  _ClockAnimationState createState() => _ClockAnimationState();
}

class _ClockAnimationState extends State<ClockAnimation> {
  GlobalKey<_ClockColumnState> keySecondFirstDigit = GlobalKey();
  GlobalKey<_ClockColumnState> keySecondLastDigit = GlobalKey();
  GlobalKey<_ClockColumnState> keyMinuteFirstDigit = GlobalKey();
  GlobalKey<_ClockColumnState> keyMinuteLastDigit = GlobalKey();
  GlobalKey<_ClockColumnState> keyHourFirstDigit = GlobalKey();
  GlobalKey<_ClockColumnState> keyHourLastDigit = GlobalKey();
  Timer timer;


  DateTime cityTime = DateTime.now();


  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int second = DateTime.now().second;
      int minute = DateTime.now().minute;
      int hour = DateTime.now().hour + widget.utcOffset;
      keySecondFirstDigit.currentState.setDigit(second ~/ 10);
      keySecondLastDigit.currentState.setDigit(second % 10);
      keyMinuteFirstDigit.currentState.setDigit(minute ~/ 10);
      keyMinuteLastDigit.currentState.setDigit(minute % 10);
      keyHourFirstDigit.currentState.setDigit(hour ~/ 10);
      keyHourLastDigit.currentState.setDigit(hour % 10);

    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ClockColumn(key: keyHourFirstDigit, width: 20, height: 60, fontSize: 25, initDigit: cityTime.hour ~/ 10,),
          ClockColumn(key: keyHourLastDigit, width: 20, height: 60, fontSize: 25, initDigit: cityTime.hour % 10,),
          Text(':', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ClockColumn(key: keyMinuteFirstDigit, width: 20, height: 60, fontSize: 25, initDigit: DateTime.now().minute ~/ 10,),
          ClockColumn(key: keyMinuteLastDigit, width: 20, height: 60, fontSize: 25, initDigit: DateTime.now().minute % 10,),
          Text(':', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          ClockColumn(key: keySecondFirstDigit, width: 20, height: 60, fontSize: 25, initDigit: DateTime.now().second ~/ 10,),
          ClockColumn(key: keySecondLastDigit, width: 20, height: 60, fontSize: 25, initDigit: DateTime.now().second % 10,),
        ],
      ),
    );
  }
}


