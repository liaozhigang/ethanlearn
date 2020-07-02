import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning/pages/world_clock/model.dart';
import 'animation.dart';




class WorldClockExpandedPage extends StatefulWidget {



  @override
  _WorldClockExpandedPageState createState() => _WorldClockExpandedPageState();
}

class _WorldClockExpandedPageState extends State<WorldClockExpandedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('city name'),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/pages/world_clock/assets/day.png'),
                fit: BoxFit.cover,
              )
          ),
          child: Column(
            children: <Widget>[
              Text(ExpandedCityInfo.englishName.toString(), style: TextStyle(fontSize: 30,),),
              Text('Local Time', style: TextStyle(fontSize: 24),)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),

        )
    );
  }
}
