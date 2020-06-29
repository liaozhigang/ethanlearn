import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class AnimatedClockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Animated Clock",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Animation(title: 'An animated clock'),
    );
  }
}

class Animation extends StatefulWidget {
  final String title;

  Animation({Key key, this.title}) : super(key: key);
  @override
  _AnimationState createState() => _AnimationState();
}

class _AnimationState extends State<Animation> {
  GetTime _now = GetTime();

  @override
  void initState() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _now = GetTime();
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          child:
            Text(_now.curTime[0].toString()),
      ),
    );
  }
}


class GetTime{

  List<String> curTime;

  List<String> getTime(){
    DateTime now = DateTime.now();
    String hhmm = DateFormat('Hm').format(now).replaceAll(':', '');

    curTime = hhmm.split('').map((e) => int.parse(e).toString()).toList();
    return curTime;
  }

}

class ClockColumn extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Container(
      child: null
    );
  }
}

