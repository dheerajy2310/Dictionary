import 'package:dicitonary/screens/ContactusScreen.dart';
import 'package:dicitonary/services/variablers.dart';
import 'package:flutter/material.dart';
import 'package:dicitonary/services/User.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dicitonary/services/bookmarks.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

GlobalKey<ProfileViewState> _myKey = GlobalKey();

class ProfilePage extends StatefulWidget {
  final void Function() gotobookmarkscreen;
  final AnimationController animationController;

  const ProfilePage(
      {Key key, this.animationController, this.gotobookmarkscreen})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    addlistViews();
    super.initState();
  }

  addlistViews() {
    const int count = 6;
    listViews.add(ProfileHeadText(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 0, 1, curve: Curves.fastOutSlowIn))),
    ));
    listViews.add(ProfileView(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 1, 1, curve: Curves.fastOutSlowIn))),
    ));
    listViews.add(BookmarksView(
      gotoBookmarksScreen: widget.gotobookmarkscreen,
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 2, 1, curve: Curves.fastOutSlowIn))),
    ));
    listViews.add(InviteFriends(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 3, 1, curve: Curves.fastOutSlowIn))),
    ));
    listViews.add(RatingView(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 4, 1, curve: Curves.fastOutSlowIn))),
    ));
    listViews.add(HelpView(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 5, 1, curve: Curves.fastOutSlowIn))),
    ));
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Values.lightwhite,
      child:
          Scaffold(backgroundColor: Colors.transparent, body: showListview()),
    );
  }

  showListview() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }
}

class ProfileHeadText extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  const ProfileHeadText({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform:
                new Matrix4.translationValues(0, 50 * (1 - animation.value), 0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Profile',
                style: GoogleFonts.roboto(
                    fontSize: 24,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  ProfileView({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  AssetImage maleavatar = AssetImage('assets/maleavatar.png');
  AssetImage femaleavatar = AssetImage('assets/femaleavatar.png');
  bool isMale = User.getGender();
  String username = User.getName();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: new Matrix4.translationValues(
                0, 50 * (1 - widget.animation.value), 0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 45,
                        child: FlutterSwitch(
                          activeTextFontWeight: FontWeight.w400,
                          inactiveTextFontWeight: FontWeight.w400,
                          toggleSize: 30,
                          toggleColor: Color(0xFFD0CDE1),
                          showOnOff: true,
                          activeColor: Values.lightSimpleGreen,
                          inactiveColor: Values.lightSimpleGreen,
                          activeTextColor: Values.lightwhite,
                          inactiveTextColor: Values.lightwhite,
                          width: 120,
                          borderRadius: 35,
                          padding: 8,
                          activeText: 'Male',
                          inactiveText: 'Female',
                          value: isMale,
                          onToggle: (bool state) {
                            changeGender(state);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: (!isMale) ? maleavatar : femaleavatar,
                              fit: BoxFit.contain)),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Text(
                      username.toUpperCase(),
                      style: GoogleFonts.roboto(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600]),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      splashColor: Colors.white.withOpacity(0.3),
                      onTap: () {
                        changename();
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 17.5, bottom: 8, right: 8, top: 10),
                            child: Text(
                              'Change UserName',
                              style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void changeGender(bool state) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isMale = state;
    });
    preferences.setBool('male', isMale);
    User.updateName(User.getName());
  }

  void changename() {
    TextEditingController usernameController = TextEditingController();
    final GlobalKey<FormState> _key = new GlobalKey<FormState>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Enter new username',
            style: GoogleFonts.roboto(fontWeight: FontWeight.w500),
          ),
          content: Form(
            key: _key,
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) return '* UserName required.';
                if (value.length < 5)
                  return 'Username must exceed 4 characters';
                return null;
              },
              onSaved: (value) {
                setState(() {
                  usernameController.text = value.trim();
                });
              },
              controller: usernameController,
              style: GoogleFonts.roboto(
                  color: Colors.grey[800],
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500),
              cursorColor: Colors.grey[600],
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                isDense: true,
                hintText: 'Enter new Username',
                hintStyle: GoogleFonts.roboto(
                    color: Colors.grey[800],
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w400),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: Values.greenPalette3, width: 1.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: Values.greenPalette3, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      BorderSide(color: Values.greenPalette3, width: 1.5),
                ),
              ),
            ),
          ),
          actions: [
            FlatButton(
                onPressed: () async {
                  var name = usernameController.text;
                  if (!_key.currentState.validate()) return;
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.setString('username', name);
                  User.updateName(preferences.getString('username'));
                  Navigator.pop(context);
                  setState(() {
                    username = name;
                  });
                  usernameController.clear();
                },
                child: Text(
                  'Update Username',
                  style: GoogleFonts.roboto(
                    color: Color(0xFF575A89),
                    fontWeight: FontWeight.w400,
                  ),
                )),
          ],
        );
      },
    );
  }
}

class BookmarksView extends StatelessWidget {
  final void Function() gotoBookmarksScreen;
  final AnimationController animationController;
  final Animation animation;

  const BookmarksView(
      {Key key,
      this.animationController,
      this.animation,
      this.gotoBookmarksScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform:
                new Matrix4.translationValues(0, 50 * (1 - animation.value), 0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  // height: 45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        height: 1,
                        color: Color(0xFF575A89),
                      ),
                      InkWell(
                        splashColor: Colors.white.withOpacity(0.3),
                        onTap: () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            gotoBookmarksScreen();
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Bookmarks',
                                style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                height: 35,
                                width: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.grey[400].withOpacity(0.5),
                                ),
                                child: Center(
                                  child: Text(
                                    '${Bookmark.retrieveList().length.toString()}',
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class InviteFriends extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  const InviteFriends({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform:
                new Matrix4.translationValues(0, 50 * (1 - animation.value), 0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        height: 1,
                        color: Color(0xFF575A89),
                      ),
                      InkWell(
                        splashColor: Colors.white.withOpacity(0.3),
                        onTap: () {
                          Share.share(
                              'Hello, Check out this awesome animated GoDictionary - The Free English Pocket Dictionary App and install through this link\n\n https://play.google.com/store/apps/details?id=com.dheeraj.dicitonary');
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Invite Friends',
                                style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class HelpView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  const HelpView({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform:
                new Matrix4.translationValues(0, 50 * (1 - animation.value), 0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        height: 1,
                        color: Color(0xFF575A89),
                      ),
                      InkWell(
                        splashColor: Colors.white.withOpacity(0.3),
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                            builder: (context) {
                              return ContactUsScreen();
                            },
                          ));
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Help',
                                style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RatingView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  RatingView({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform:
                new Matrix4.translationValues(0, 50 * (1 - animation.value), 0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        height: 1,
                        color: Color(0xFF575A89),
                      ),
                      InkWell(
                        splashColor: Colors.white.withOpacity(0.3),
                        onTap: () {
                          launch(
                              'https://play.google.com/store/apps/details?id=com.dheeraj.dicitonary');
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'Rate Us',
                                style: GoogleFonts.roboto(
                                    fontSize: 18,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
