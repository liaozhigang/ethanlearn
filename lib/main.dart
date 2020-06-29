import 'package:flutter/material.dart';
import 'package:flutter_learning/pages/animation.dart';
import 'package:flutter_learning/pages/binary_clock.dart';
import 'package:flutter_learning/pages/drag_and_drop.dart';
import 'package:flutter_learning/pages/world_clock/world_clock_main.dart';

import 'pages/hello_world.dart';
import 'pages/lang/language.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Learn',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Ethan Flutter Learn Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Widget testPage(String title, String description, Widget page) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return page;
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          testPage("Hello Flutter", "First test page", HelloWorldPage()),
          testPage('World Clock', 'World time clock app', WorldClockPage()),
          testPage("Binary Clock", 'A binary digital clock', BinaryClockPage()),
          testPage('Drag and Drop', "A drag and drop application", DragAndDropPage()),
          testPage("Language Testing Page", 'A testing page that translates languages', LanguagePage()),
          testPage("Animated Clock", "an animated clock", AnimatedClockPage()),
        ],
      ),
    );
  }
}
