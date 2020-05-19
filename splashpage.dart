import 'package:flutter/material.dart';

import 'main.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Visit Malaysia 2020',
      home: Scaffold(
          body: Container(
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/splash.jpg'),
                        fit: BoxFit.cover))),
            pageTitle(),
            Container(height: 1000, child: ProgressIndicator()),
          ],
        ),
      )),
    );
  }

  Widget pageTitle() {
    return Container(
      //color: Color.fromRGBO(255, 200, 200, 200),
      margin: EdgeInsets.only(top: 250),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.airplanemode_active,
                size: 50,
                color: Colors.red,
              ),
              Text(
                " Visit Malaysia",
                style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
          Text(
                '  2020',
                style: TextStyle(
                    fontSize: 45,
                    color: Colors.red,
                    fontWeight: FontWeight.w900),
              ),
        ],
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //updating states
          if (animation.value > 0.99) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => MainPage()));
          }
        });
      });
    controller.repeat();
  }

  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      width: 60,
      child: CircularProgressIndicator(
        value: animation.value,
        //backgroundColor: Colors.brown,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    ));
  }
}
