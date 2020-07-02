import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'animation.dart';

class WorldClockExpandedPage extends StatelessWidget {
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
                Text("Chicago", style: TextStyle(fontSize: 30,),),
                Text('Local Time', style: TextStyle(fontSize: 24),)
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
          ),

      )
      );
  }
}
