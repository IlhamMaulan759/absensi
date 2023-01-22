import 'dart:async';
import 'package:absensi_apps/constant/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class launcher extends StatefulWidget {
  @override
  _launcherState createState() => _launcherState();
}

class _launcherState extends State<launcher>
    with SingleTickerProviderStateMixin {

  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;

  starTime() async{
    var _duration = new Duration(seconds: 10);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage(){
    Navigator.of(context).pushReplacementNamed(HOME_SCREEN);
  }

  @override
  void initState(){
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    starTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyanAccent[500],
      body: Container(
        decoration: BoxDecoration(color: Colors.cyanAccent[500]),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                new Image.asset(
                  'gambar/logoabsensi.png',
                  width: animation.value * 200,
                  height: animation.value * 200,
                ),
                new Padding(
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
