import 'dart:async';

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

class ClockColumn extends StatefulWidget {
  final int initDigit;
  final double height;
  final double width;

  const ClockColumn({Key key, this.initDigit, this.height: 60, this.width: 20}) : super(key: key);

  @override
  _ClockColumnState createState() => _ClockColumnState();
}

class _ClockColumnState extends State<ClockColumn> with SingleTickerProviderStateMixin {
  double opacity;
  double offset;

  int curDigit;
  int oldDigit;

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    opacity = 0.0;
    offset = 1.0;
    curDigit = widget.initDigit;
    oldDigit = -1;

    controller = new AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this)
      ..addListener(() {
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
      decoration: BoxDecoration(
        border: Border.all(),
      ),
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: Align(
              alignment: Alignment(0.0, offset),
              child: Text(curDigit.toString()),
            ),
          ),
          Opacity(
            opacity: 1.0 - opacity,
            child: Align(
              alignment: Alignment(0.0, offset - 1.0),
              child: Text(oldDigit >= 0 ? oldDigit.toString() : ""),
            ),
          ),
        ],
      ),
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
  GlobalKey<_ClockColumnState> keySecondFirstDigit = GlobalKey();
  GlobalKey<_ClockColumnState> keySecondLastDigit = GlobalKey();
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int second = DateTime.now().second;
      keySecondFirstDigit.currentState.setDigit(second ~/ 10);
      keySecondLastDigit.currentState.setDigit(second % 10);
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
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClockColumn(key: keySecondFirstDigit, initDigit: DateTime.now().second ~/ 10,),
            ClockColumn(key: keySecondLastDigit, initDigit: DateTime.now().second % 10,),
          ],
        ),
      ),
    );
  }
}
