import 'dart:convert';


import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _filter;


  @override
  void initState() {
    _filter = TextEditingController();
    loadTimezones();

    super.initState();
  }


  void loadTimezones() async {
    String data = await DefaultAssetBundle.of(context).loadString(
        "pages/world_clock/assets/timezones.json");
    setState(() {
      mainDataList = json.decode(data);
      newDataList = List.from(mainDataList);
    });
  }

  List<dynamic> newDataList;
  List<dynamic> mainDataList;

  onItemChanged(String value) {
    setState(() {
      newDataList = mainDataList
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose location"),),
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: _filter,
                decoration: InputDecoration(
                    hintText: "Search here...",
                    border: OutlineInputBorder()
                ),
                onChanged: onItemChanged,
              )
          ),
          if(newDataList == null) Container() else
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(4.0),
                children: newDataList.map((data) {
                  return ListTile(
                    title: Text(data.split('/').last),
                    subtitle: Text(data.split('/').first),
                    onTap: () => Navigator.of(context).pop(data),
                  );
                }).toList(),
              ),
            )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

}
