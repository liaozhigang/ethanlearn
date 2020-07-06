import 'package:flutter/material.dart';
import 'package:flutter_learning/pages/animation.dart';
import 'dart:async';

class Location {
  final String englishName;
  final String chineseName;
  final int utcOffset;

  Location({this.englishName, this.chineseName, this.utcOffset});

  Location.fromJson(Map<String, dynamic> json):
        englishName = json['englishName'],
        chineseName = json['chineseName'],
        utcOffset = json['utcOffset'];

  Map<String, dynamic> toJson() => {
    'englishName': englishName,
    'chineseName': chineseName,
    'utcOffset': utcOffset,
  };
}


class ExpandedCityInfo{
  static String englishName;
  static String chineseName;
  static int utcOffset;
}




class AnimatedClocks extends StatefulWidget {
  Timer timer;

  @override
  _AnimatedClocksState createState() => _AnimatedClocksState();
}

class _AnimatedClocksState extends State<AnimatedClocks> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

