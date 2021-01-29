import 'package:dicitonary/screens/Homepage.dart';
import 'package:dicitonary/services/User.dart';
import 'package:dicitonary/services/variablers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var username;
  var welcomeImage = AssetImage('assets/welcomePageAsset.png');
  final GlobalKey<FormState> _key = new GlobalKey<FormState>();
  bool loading = false;
  TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      backgroundColor: Values.white,
      body: ModalProgressHUD(
        opacity: 0.4,
        inAsyncCall: loading,
        progressIndicator: Container(
          height: 50,
          width: 50,
          child: LoadingIndicator(
            indicatorType: Indicator.lineSpinFadeLoader,
            color: Values.greenPalette1,
          ),
        ),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CustomPaint(
              painter: BackgroundPainter(),
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.125),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Welcome...',
                          style: GoogleFonts.roboto(
                              fontSize: 36,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.5),
                        ),
                      ),
                      // SizedBox(height: 10),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: welcomeImage,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Hello, What is your name ?',
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: _key,
                          child: TextFormField(
                            validator: (value) {

                              if (value.isEmpty) return '* UserName required.';
                              if (value.length < 5)
                                return '* Username must exceed 4 characters';
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
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 14),
                              isDense: true,
                              hintText: 'Enter your name',
                              hintStyle: GoogleFonts.roboto(
                                  color: Colors.grey[800],
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w400),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Values.greenPalette3, width: 1.5),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Values.greenPalette3, width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                    color: Values.greenPalette3, width: 1.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Color(0xFF575A89),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'SUBMIT ',
                                    style: GoogleFonts.roboto(
                                        color: Values.lightwhite,
                                        letterSpacing: 2,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Values.lightwhite,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onPressed: () async {
                            print(usernameController.text);
                            if (!_key.currentState.validate())
                              return;
                            else {
                              setState(() {
                                loading = true;
                              });
                              StreamingSharedPreferences
                                  streamingSharedPreferences =
                                  await StreamingSharedPreferences.instance;
                              SharedPreferences preferences =
                                  await SharedPreferences.getInstance();
                              preferences.setString(
                                  'username', usernameController.text);
                              User.updateName(
                                  preferences.getString('username'));
                              streamingSharedPreferences.setBool(
                                  'isFirst', false);
                              await Future.delayed(Duration(seconds: 3));
                              setState(() {
                                loading = false;
                              });
                              Navigator.of(context).push(
                                  new MaterialPageRoute(builder: (context) {
                                return HomePage();
                              }));
                              usernameController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;
    var height = size.height;
    Paint paint = Paint();

    Path background = Path();
    background.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Values.white;
    canvas.drawPath(background, paint);

    Path curve = Path();
    curve.lineTo(width * 0.15, 0);
    curve.quadraticBezierTo(
        width * 0.25, height * 0.13, width * 0.35, height * 0.08);
    curve.quadraticBezierTo(
        width * 0.4, height * 0.065, width * 0.45, height * 0.12);
    curve.quadraticBezierTo(
        width * 0.525, height * 0.18, width * 0.6, height * 0.158);
    curve.quadraticBezierTo(
        width * 0.8, height * 0.1, width * 0.9, height * 0.2);
    curve.quadraticBezierTo(width * 0.95, height * 0.24, width, height * 0.25);
    curve.lineTo(width, 0);
    paint.color = Values.lightSimpleGreen;
    canvas.drawPath(curve, paint);

    Path curve2 = Path();
    curve2.moveTo(0, height);
    curve2.lineTo(0, height * 0.9);
    curve2.quadraticBezierTo(
        width * 0.1, height * 0.87, width * 0.185, height * 0.92);
    curve2.quadraticBezierTo(
        width * 0.25, height * 0.96, width * 0.35, height * 0.93);
    curve2.quadraticBezierTo(
        width * 0.45, height * 0.915, width * 0.5, height * 0.95);
    curve2.quadraticBezierTo(
        width * 0.55, height * 0.97, width * 0.625, height * 0.965);
    curve2.quadraticBezierTo(
        width * 0.675, height * 0.9675, width * 0.7, height);

    paint.color = Values.lightSimpleGreen;
    canvas.drawPath(curve2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
