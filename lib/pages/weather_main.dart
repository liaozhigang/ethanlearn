import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
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
  int temperature;
  String location = "Chicago";
  String weatherType = 'Cloud';
  int woeid = 44418;    //woeid represented where on earth id
  String abbreviation = '';
  String unrecognizedInput = '';


  String getUrl = "https://www.metaweather.com/api/location/search/?query=";
  String getLocationUrl = "https://www.metaweather.com/api/location/";


  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;

  @override
  void initState() {
    super.initState();
    searchLocation();
  }

  void searchWoeid(String input) async {
    try{
      var searchResult = await http.get(getUrl + input);
      var result = json.decode(searchResult.body)[0];

      setState(() {
        location = result["title"];
        woeid = result['woeid'];
        unrecognizedInput = '';
      });
    }
    catch(error){
      setState(() {
        unrecognizedInput = 'Sorry, no data for this city. Try another one';
      });
    }
  }

  void searchLocation() async {
    var locationResult = await http.get(getLocationUrl + woeid.toString());
    var result = json.decode(locationResult.body);

    var consolidatedWeather = result['consolidated_weather'];
    var data = consolidatedWeather[0];

    setState(() {
      temperature = data["the_temp"].round();
      weatherType = data['weather_state_name'].toString().split(' ').last.toLowerCase();
      abbreviation = data['weather_state_abbr'];
    });
  }


  void onTextFieldSubmitted(String input) async {
    await searchWoeid(input);
    await searchLocation();
  }


  _getCurrentLocation() {                                           // geolocator
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
      onTextFieldSubmitted(place.locality);
    } catch (e) {
      print(e);
    }
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
      child: temperature == null ? Center(child: CircularProgressIndicator(),) : Scaffold(
        appBar: AppBar(
          actions:<Widget> [
            GestureDetector(
              onTap: (){
                _getCurrentLocation();
                },
              child: Icon(Icons.my_location, size: 40,),
            ),
          ],
          backgroundColor: Colors.transparent, elevation: 0.0,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Center(
                  child: Image.network('https://www.metaweather.com/static/img/weather/png/$abbreviation.png', width: 100,),
                ),
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
                ),
                Text(
                  unrecognizedInput,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 15),
                )
              ],
            ),
          ]
        ),
      ),
    );
  }
}