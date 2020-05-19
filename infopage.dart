import 'dart:async';

import 'package:flutter/material.dart';
import 'package:midterm_visitmalaysia/location.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:geocoder/geocoder.dart';

class InfoPage extends StatefulWidget {
  final Location location;

  const InfoPage({Key key, this.location, int index}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  double screenHeight, screenWidth;

  @override
  Widget build(BuildContext context) {
    
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.location.locname,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightGreenAccent,
      ),
      body: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              //SizedBox(height: 15),
              GestureDetector(
                  onTap: () => _onImageDisplay(widget.location.imagename),
                  child: Container(
                    height: screenHeight / 3.5,
                    width: screenWidth / 0,
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl:
                          "http://slumberjer.com/visitmalaysia/images/${widget.location.imagename}",
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),
                  )),

              Container(
                height: screenHeight / 1.65,
                width: screenWidth / 1.0,
                color: Colors.lightGreen,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(40, 10, 40, 5),
                  child: Column(
                    children: <Widget>[
                      Table(
                        defaultColumnWidth: FlexColumnWidth(2.2),
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text("Location: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ))),
                              ),
                              TableCell(
                                child: Container(
                                  height: 30,
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 1,
                                      child: Text(
                                        widget.location.locname,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    child: Text("Description: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ))),
                              ),
                              TableCell(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  height: 200,
                                  child: Container(
                                      alignment: Alignment.topLeft,
                                      height: 30,
                                      child: SingleChildScrollView(
                                          child: Text(
                                        widget.location.description,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ))),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    child: Text("URL: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ))),
                              ),
                              TableCell(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  height: 50,
                                  child: SingleChildScrollView(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop(false);
                                        _urlLaunch(widget.location.url);
                                      },
                                      child: Text(
                                        widget.location.url,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 40,
                                    child: Text("Address: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ))),
                              ),
                              TableCell(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  height: 70,
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 1,
                                      child: SingleChildScrollView(
                                          child: Text(
                                        widget.location.address,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ))),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text("CALL US: ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ))),
                              ),
                              TableCell(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  height: 30,
                                  child: SingleChildScrollView(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop(false);
                                        _urlLaunch(widget.location.contact);
                                      },
                                      child: Text(
                                        widget.location.contact,
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(),
            ],
          ))),
    );
  }

  Future<void> _urlLaunch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

   _onImageDisplay(String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: new Container(
              color: Colors.white,
              height: screenHeight / 2.2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      height: screenWidth / 1.3,
                      width: screenWidth / 1.3,
                      decoration: BoxDecoration(
                          //border: Border.all(color: Colors.black),
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  "http://slumberjer.com/visitmalaysia/images/${name}")))),
                ],
              ),
            ));
      },
    );
  }
}
