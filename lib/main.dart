import 'dart:convert';
import 'dart:io';

import 'package:dicitonary/screens/Homepage.dart';
import 'package:dicitonary/screens/WelcomeScreen.dart';
import 'package:dicitonary/screens/splashscreen.dart';
import 'package:dicitonary/services/User.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_splashscreen/simple_splashscreen.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:dicitonary/services/bookmarks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  bool isMale;
  bool isFirst = true;
  SharedPreferences preferences;
  StreamingSharedPreferences streamingSharedPreferences;
  @override
  void initState() {
    super.initState();
    Bookmark.updateList();
    getusername();
  }

  getusername() async {
    streamingSharedPreferences = await StreamingSharedPreferences.instance;
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isFirst = streamingSharedPreferences
          .getBool('isFirst', defaultValue: true)
          .getValue();
    });
    User.updateName(preferences.getString('username'));
    Future.delayed(Duration(seconds: 2));
    isMale = preferences.getBool('male');
    print('gender is $isMale');
    if (isMale == null) {
      preferences.setBool('male', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Simple_splashscreen(
      context: context,
      splashscreenWidget: SplashScreen(),
      gotoWidget: (!isFirst) ? HomePage() : WelcomeScreen(),
      timerInSeconds: 4,
    );
  }

  
}
