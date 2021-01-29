import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:dicitonary/screens/BookMarkPage.dart';
import 'package:dicitonary/screens/HistoryPage.dart';
import 'package:dicitonary/screens/ProfilePage.dart';
import 'package:dicitonary/screens/SearchPage.dart';
import 'package:dicitonary/services/variablers.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController animationController;
  Widget tabBody = Container();
  int index = 0;
  var subscription;
  var connectionStatus;
  DateTime currentBackPressTime;

  @override
  void initState() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Toast.show('Oops! check your Internet Connection.', context,
            duration: 6,
            gravity: Toast.TOP,
            backgroundColor: Colors.redAccent,
            textColor: Values.lightwhite);
      }
    });
    // checkInternetConnectivity();
    animationController = AnimationController(
        duration: Duration(milliseconds: 800), vsync: this);
    tabBody = SearchPage(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
    subscription.cancel();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Values.lightwhite,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        body: WillPopScope(
          onWillPop: willPop,
          child: FutureBuilder<bool>(
            future: getData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return new SizedBox();
              else {
                return Stack(
                  children: [
                    tabBody,
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 70,
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          bottomNavigationBar: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: CustomNavigationBar(
                              items: [
                                CustomNavigationBarItem(
                                  icon: Icons.search_outlined,
                                  showBadge: false,
                                ),
                                CustomNavigationBarItem(
                                  icon: Icons.history_outlined,
                                  showBadge: false,
                                ),
                                CustomNavigationBarItem(
                                  icon: Icons.bookmark_border_outlined,
                                  showBadge: false,
                                ),
                                CustomNavigationBarItem(
                                  icon: Icons.person_outline,
                                  showBadge: false,
                                ),
                              ],
                              isFloating: true,
                              scaleFactor: 0.3,
                              iconSize: 26,
                              currentIndex: index,
                              selectedColor: Values.greenPalette2,
                              unSelectedColor: Colors.grey[500],
                              elevation: 6,
                              onTap: (int x) {
                                print(x);
                                setState(() {
                                  index = x;
                                  if (x == 1) {
                                    animationController
                                        .reverse()
                                        .then<dynamic>((data) {
                                      if (!mounted) {
                                        return;
                                      }
                                      setState(() {
                                        tabBody = HistoryPage(
                                            animationController:
                                                animationController);
                                      });
                                    });
                                  } else if (x == 2) {
                                    animationController
                                        .reverse()
                                        .then<dynamic>((data) {
                                      if (!mounted) {
                                        return;
                                      }
                                      setState(() {
                                        tabBody = BookMarkPage(
                                          animationController:
                                              animationController,
                                        );
                                      });
                                    });
                                  } else if (x == 3) {
                                    animationController
                                        .reverse()
                                        .then<dynamic>((data) {
                                      if (!mounted) {
                                        return;
                                      }
                                      setState(() {
                                        tabBody = ProfilePage(
                                          gotobookmarkscreen: gotoBookmarks,
                                          animationController:
                                              animationController,
                                        );
                                      });
                                    });
                                  } else {
                                    animationController
                                        .reverse()
                                        .then<dynamic>((data) {
                                      if (!mounted) {
                                        return;
                                      }
                                      setState(() {
                                        tabBody = SearchPage(
                                          animationController:
                                              animationController,
                                        );
                                      });
                                    });
                                  }
                                });
                              },
                              strokeColor: Values.greenPalette3,
                              borderRadius: Radius.circular(16),
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  gotoBookmarks() {
    setState(() {
      index = 2;
    });
    animationController.reverse().then((value) {
      if (!mounted) return;
      setState(() {
        tabBody = BookMarkPage(
          animationController: animationController,
        );
      });
    });
  }

  void checkInternetConnectivity() {
    if (connectionStatus == ConnectivityResult.none) {
      return Toast.show('Please check your Internet Connection.', context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.TOP,
          backgroundColor: Colors.redAccent,
          textColor: Values.lightwhite);
    }
  }

  Future<bool> willPop() {
    final snackBar = SnackBar(
      content: Text(
        'Tap again to Exit.',
        style: GoogleFonts.roboto(
          color: Values.lightwhite,
        ),
      ),
    );
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return Future.value(false);
    } else {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return Future.value(true);
    }
  }
}
