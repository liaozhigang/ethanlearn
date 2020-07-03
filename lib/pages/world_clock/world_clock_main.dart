import 'dart:convert';
import 'dart:async';

import 'package:flutter_learning/pages/animation.dart';
import 'package:flutter_learning/pages/world_clock_expanded_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'search_page.dart';
import '../world_clock/model.dart';
import '../world_clock/location_clock.dart';


class WorldClockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "World CLock",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: "World Clock"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key : key);
  final String title;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Location> _locations;

  void loadLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("locations")) {
      String locationJsonString = prefs.getString("locations");
      print("locations: $locationJsonString");
      List locations = json.decode(locationJsonString);

      print(locations[0]);

      setState(() {
        _locations = List<Location>.from((locations).map((item) => Location.fromJson(item)).toList());
      });
    }
  }

  void saveLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map> locationsMap = _locations.map((l) => l.toJson()).toList();
    prefs.setString("locations", jsonEncode(locationsMap));
  }



  @override
  void initState() {
    super.initState();
    _locations = <Location>[];
    loadLocations();
  }

  int getUtcDiff(String utcOffset) {
    return int.parse(utcOffset.split(":").first);
  }

  Future<int> getTimeZone(String location) async {
    try {

      String url = "http://worldtimeapi.org/api/timezone/$location";
      Response response = await get(url);
      Map data = jsonDecode(response.body);

      print("request: $url, response: ${response.body}");
      return getUtcDiff(data['utc_offset']);
    }

    catch (e) {
      return -1;
    }
  }

  List<Widget> get locationClocks {
    return _locations.map((location) => LocationClock(location: location.englishName, utcOffset: location.utcOffset,)).toList();
  }

  void addLocationPressed() async {
    var result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return SearchPage();
        }
    ));

    if (result.toString().isNotEmpty) {
      int timezoneDiff = await getTimeZone(result.toString());
      Location location = Location(englishName: result.toString(), utcOffset: timezoneDiff);

      setState(() {
        _locations.add(location);
      });

      saveLocations();
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(
          () {
        if (newIndex > oldIndex) {
          newIndex -= 1;
        }
        final item = _locations.removeAt(oldIndex);
        _locations.insert(newIndex, item);
      },
    );
    saveLocations();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:ReorderableListView(
        onReorder: _onReorder,
        scrollDirection: Axis.vertical,
        children: List.generate(_locations.length, (index) {
          return Slidable(
            key: GlobalKey(),
            actionExtentRatio: 0.25,
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Expand',
                color: Colors.green,
                icon: Icons.input,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return AnimatedClockPage();
                  }));
                  ExpandedCityInfo.englishName = _locations[index].englishName.split('/').last;
                  ExpandedCityInfo.utcOffset = _locations[index].utcOffset;
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  setState(() {
                    _locations.removeAt(index);
                    saveLocations();
                  });
                },
              ),
            ],

            child: Card(
                margin: EdgeInsets.only(top: 1.0),
                child: LocationClock(location: _locations[index].englishName, utcOffset: _locations[index].utcOffset,)),
          );
        }),
      ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: addLocationPressed,
          icon: Icon(Icons.add_box),
          backgroundColor: Colors.blue,
          label: Text("choose location")
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


