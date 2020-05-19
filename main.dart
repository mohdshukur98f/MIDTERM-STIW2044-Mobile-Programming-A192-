import 'dart:convert';
import 'package:midterm_visitmalaysia/location.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:midterm_visitmalaysia/infopage.dart';
//import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
//import 'package:progress_dialog/progress_dialog.dart';
//import 'package:midterm_visitmalaysia/location.dart';
//import 'dart:async';
//import 'dart:io';
// import 'package:estocksystem/cartpage.dart';
// import 'package:estocksystem/user.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  List locationdata;
  double screenHeight, screenWidth;
  String selectedType = "Kedah";
  String curtype;
  // var _tapPosition;

  List<String> listType = [
    "Kedah",
    "Kelantan",
    "Perlis",
  ];

  void initState() {
    super.initState();
    this.loadPref();
    _loadData(selectedType);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (locationdata == null) {
      return MaterialApp(
          title: 'Materia App',
          home: Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                title: Text(
                  'VISIT MALAYSIA 2020',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.lightGreenAccent,
              ),
              body: Container(
                child: Column(
                  children: <Widget>[
                    //SizedBox(height: 5.0),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'SORT BY:   ',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Loading Locations",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )));
    } else {
      return MaterialApp(
          title: 'Materia App',
          home: Scaffold(
              resizeToAvoidBottomPadding: false,
              appBar: AppBar(
                title: Text(
                  'VISIT MALAYSIA 2020',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.lightGreenAccent,
              ),
              body: Container(
                child: Column(
                  children: <Widget>[
                    //SizedBox(height: 5.0),
                    Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'SORT BY:   ',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            DropdownButton(
                              value: selectedType,
                              onChanged: (newValue) {
                                setState(() async {
                                  selectedType = newValue;
                                  savepref(selectedType);
                                  _sortItem(selectedType);
                                  print(selectedType);
                                });
                              },
                              items: listType.map((selectedType) {
                                return DropdownMenuItem(
                                  child: new Text(selectedType,
                                      style: TextStyle(color: Colors.blue)),
                                  value: selectedType,
                                );
                              }).toList(),
                            ),
                          ]),
                    ),
                    Flexible(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (screenWidth / screenHeight) / 0.7,
                          children: List.generate(locationdata.length, (index) {
                            return Container(
                                child: InkWell(
                                    onTap: () => _showInfo(index),
                                    onTapDown: _storePosition,
                                    child: Card(
                                        elevation: 10,
                                        child: Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Column(
                                            //mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                height: screenHeight / 5.5,
                                                width: screenWidth / 1,
                                                child: ClipOval(
                                                    child: CachedNetworkImage(
                                                  fit: BoxFit.scaleDown,
                                                  imageUrl:
                                                      "http://slumberjer.com/visitmalaysia/images/${locationdata[index]['imagename']}",
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                )),
                                              ),
                                              SizedBox(height: 15),
                                              Text("Location: ",
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              Text(
                                                  locationdata[index]
                                                      ['loc_name'],
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                              SizedBox(height: 10),
                                              Text(
                                                "State: " +
                                                    locationdata[index]
                                                        ['state'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ))));
                          })),
                    ),
                  ],
                ),
              )));
    }
  }

  void _loadData(String selectedType) {
    String urlLoadJobs =
        "https://slumberjer.com/visitmalaysia/load_destinations.php";
    http.post(urlLoadJobs, body: {
      "state": selectedType,
    }).then((res) {
      setState(() {
        var extractdata = json.decode(res.body);
        locationdata = extractdata["locations"];
        print(locationdata);
      });
    }).catchError((err) {
      print(err);
    });
  }

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String select = (prefs.getString('selectedType')) ?? '';

    if (select.length > 1) {
      setState(() {
        selectedType = select;
      });
    }
  }

  Future<void> savepref(String selectedType) async {
    String select = selectedType;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //save preference
    await prefs.setString('selectedType', select);

    print("test" + select);
  }

  void _sortItem(String selectedType) {
    try {
      String urlLoadJobs =
          "https://slumberjer.com/visitmalaysia/load_destinations.php";
      http.post(urlLoadJobs, body: {
        "state": selectedType,
      }).then((res) {
        setState(() {
          // curtype = selectedType;
          var extractdata = json.decode(res.body);
          locationdata = extractdata["locations"];
        });
      }).catchError((err) {
        print(err);
      });
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _storePosition(TapDownDetails details) {
    // _tapPosition = details.globalPosition;
  }

  void _showInfo(int index) async {
    Location _location = new Location(
      pid: locationdata[index]['pid'],
      locname: locationdata[index]['loc_name'],
      state: locationdata[index]['state'],
      description: locationdata[index]['description'],
      latitude: locationdata[index]['latitude'],
      longitude: locationdata[index]['longitude'],
      url: locationdata[index]['url'],
      contact: locationdata[index]['contact'],
      address: locationdata[index]['address'],
      imagename: locationdata[index]['imagename'],
    );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => InfoPage(
                  location: _location,
                )));
  }
}
