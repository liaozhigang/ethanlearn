import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class WeatherMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Application',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
      ),
      home: WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  int temperature = 0;
  String location = "Chicago";
  String weatherType = 'Cloud';
  int woeid = 44418;    //woeid represented where on earth id

  String getUrl = "https://www.metaweather.com/api/location/search/?query=";
  String getLocationUrl = "https://www.metaweather.com/api/location/";

  void searchWoeid(String input) async {
    var searchResult = await http.get(getUrl + input);
    var result = json.decode(searchResult.body)[0];

    setState(() {
      location = result["title"];
      woeid = result['woeid'];
    });
  }

  void searchLocation() async {
    var searchResult = await http.get(getLocationUrl + woeid.toString());
    var result = json.decode(searchResult.body);

    var consolidatedWeather = result['consolidated_weather'];
    var data = consolidatedWeather[0];

    setState(() {
      temperature = data["the_temp"].round();
      weatherType = data['weather_state_name'].toString().split(' ').last.toLowerCase();

    });
  }


  void onTextFieldSubmitted(String input){
    searchWoeid(input);
    searchLocation();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/pages/weather/assets/cloud.png'),      //$weatherType
          fit: BoxFit.cover,
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Center(
                  child: Text(
                    temperature.toString() + " \u2103",    // \u2109 for Fahrenheit
                    style: TextStyle(fontSize: 50),),
                ),
                Center(
                  child: Text(
                    location,
                    style: TextStyle(fontSize: 40),),
                ),
                Center(
                  child: Text(
                    weatherType,
                    style: TextStyle(fontSize: 40),),
                ),
              ]
            ),
            Column(
              children: [
                Container(
                  width: 350,
                  child: TextField(
                    onSubmitted: (String input){
                      onTextFieldSubmitted(input);
                    },
                    style: TextStyle(
                      fontSize: 20
                    ),
                    decoration: InputDecoration(
                      hintText: "Search for another location",
                      hintStyle: TextStyle(fontSize: 20),
                      prefixIcon: Icon(Icons.search)
                    ),
                  ),
                )
              ],
            ),
          ]
        ),
      ),
    );
  }
}