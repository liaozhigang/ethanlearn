import 'package:flutter/material.dart';

class HelloWorldPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hello, Flutter"),),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hello", style: Theme.of(context).textTheme.headline2,),
            SizedBox(height: 5.0,),
            Text("Flutter", style: Theme.of(context).textTheme.headline4,),
            SizedBox(height: 20.0,),
            FlutterLogo(size: 100,),
          ],
        ),
      ),
    );
  }
}
