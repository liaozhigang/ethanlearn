import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_learning/pages/animation.dart';

class LocationClock extends StatefulWidget {
  final int utcOffset;
  final String location;

  const LocationClock({Key key, this.location, this.utcOffset: -100}) : super(key: key);

  @override
  _LocationClockState createState() => _LocationClockState();
}

class _LocationClockState extends State<LocationClock> {
  Timer _timer;
  DateTime curTime;
  int displayTimeHour;

  String padTime(int time) {
    return time.toString().padLeft(2, "0");
  }

  String formatTime(DateTime dt) {
    return "${padTime(dt.hour)}:${padTime(dt.minute)}:${padTime(dt.second)}";
  }

  bool get dayOrNight {
    return curTime.hour > 7 && curTime.hour < 20;
  }

  @override
  void initState() {
    super.initState();
    updateCurTime();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        updateCurTime();
      });
    });
  }

  void updateCurTime() {
    curTime = DateTime.now().toUtc().add(Duration(hours: widget.utcOffset));
    displayTimeHour = curTime.hour.toInt() - DateTime.now().hour.toInt();
  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get displayLocation {
    String location = widget.location.split("/").last; // It may contain "_" in the middle
    return location.replaceAll("_", " ");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: dayOrNight ? Colors.white: Colors.black87,
      ),
      child: ListTile(
        title: ClockAnimation(displayTimeHour),       //formatTime(curTime)
        subtitle: Text(displayLocation, style: TextStyle(color: dayOrNight ? Colors.black87: Colors.white70),),
      ),
    );
  }
}