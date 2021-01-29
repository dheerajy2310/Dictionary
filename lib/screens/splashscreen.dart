import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F3F8),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left:8),
            child: FlareActor(
              'assets/splashAnimFile.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: 'splash_anim',
            ),
          ),
        ),
      ),
    );
  }
}
