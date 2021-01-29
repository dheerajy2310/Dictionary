import 'dart:async';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dicitonary/screens/definitionScreen.dart';
import 'package:dicitonary/services/variablers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:toast/toast.dart';

class Search extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  Search({
    Key key,
    this.animationController,
    this.animation,
  }) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _textEditingController = TextEditingController();
  bool isListening = false;
  bool isAvailable = true;
  String result = "";
  stt.SpeechToText _speech;

  @override
  void initState() {
    super.initState();
    // startSpeechRecognizer();
    _speech = stt.SpeechToText();
    initspeech();
  }

  initspeech() async {
    bool isAvailable = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
  }
  // startSpeechRecognizer() {
  //   speechRecognition = SpeechRecognition();

  //   speechRecognition.setAvailabilityHandler((result) {
  //     setState(() {
  //       print('available is ${result.toString()}');
  //       isAvailable = result;
  //     });
  //   });

  //   speechRecognition.setRecognitionStartedHandler(() {
  //     setState(() {
  //       isListening = true;
  //     });
  //   });

  //   speechRecognition.setRecognitionResultHandler((text) {
  //     setState(() {
  //       result = text;
  //     });
  //   });

  //   speechRecognition.setRecognitionCompleteHandler(() {
  //     setState(() {
  //       isListening = false;
  //     });
  //   });

  //   speechRecognition.activate().then((value) {
  //     setState(() {
  //       return isListening = value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0, 50 * (1 - widget.animation.value), 0),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            autocorrect: true,
                            enabled: true,
                            onEditingComplete: () {},
                            onFieldSubmitted: (value) {
                              print(value);
                              FocusScope.of(context).unfocus();
                            },
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              hintText: 'Enter a word',
                              contentPadding: const EdgeInsets.all(10.0),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Values.greenPalette3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Values.greenPalette3,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Values.greenPalette3),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            cursorColor: Colors.grey[600],
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.white.withOpacity(0.5),
                          onTap: () {
                            setState(() {
                              isListening = false;
                              result = "";
                            });
                            if (isAvailable) {
                              showModalBottomSheet(
                                elevation: 10,
                                isDismissible: true,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Values.lightwhite,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(height: 10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Speak a word',
                                                style: GoogleFonts.roboto(
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                (isListening)
                                                    ? 'Speak a word to find definition'
                                                    : 'Tap on the Speak button to speak',
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400),
                                              ),
                                            ),
                                            AvatarGlow(
                                              animate: isListening,
                                              endRadius: 75,
                                              glowColor:
                                                  Values.lightSimpleGreen,
                                              duration:
                                                  Duration(milliseconds: 1500),
                                              repeat: true,
                                              showTwoGlows: true,
                                              repeatPauseDuration:
                                                  Duration(milliseconds: 100),
                                              child: Material(
                                                elevation: 8.0,
                                                shape: CircleBorder(),
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      Values.greenPalette4,
                                                  radius: 40,
                                                  child: Icon(
                                                    isListening
                                                        ? Icons.mic
                                                        : Icons.mic_off,
                                                    size: 34,
                                                    color: isListening
                                                        ? Values.simpleGreen
                                                        : Colors.redAccent
                                                            .withOpacity(0.8),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  result.toString(),
                                                  style: GoogleFonts
                                                      .robotoCondensed(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 20,
                                                          color: Values
                                                              .greenPalette1),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  color: Color(0xFF575A89),
                                                  onPressed: () async {
                                                    setState(() {
                                                      isListening = true;
                                                      result = "";
                                                    });
                                                    _speech.listen(
                                                      listenFor:
                                                          Duration(seconds: 10),
                                                      onResult: (val) {
                                                        setState(() {
                                                          result = val
                                                              .recognizedWords;
                                                          if ((_speech
                                                                  .lastStatus ==
                                                              'notListening')) {
                                                            setState(() {
                                                              isListening =
                                                                  false;
                                                            });
                                                          }
                                                        });
                                                      },
                                                    );
                                                    // Timer(Duration(seconds: 10),
                                                    //     () {
                                                    //   setState(() {
                                                    //     isListening = false;
                                                    //   });
                                                    // });

                                                    // if (_speech.lastStatus ==
                                                    //     'notListening') {
                                                    //   setState(() {
                                                    //     isListening = false;
                                                    //   });
                                                    // }

                                                    // startListening();
                                                    // speechRecognition
                                                    //     .listen(locale: "en_US")
                                                    //     .then((value) {
                                                    //   print(value);
                                                    //   setState(() {
                                                    //     result = value;
                                                    //   });
                                                    // });
                                                    // speechRecognition
                                                    //     .setRecognitionResultHandler(
                                                    //         (text) {
                                                    //   setState(() {
                                                    //     result = text;
                                                    //   });
                                                    // });
                                                    // speechRecognition
                                                    //     .setRecognitionCompleteHandler(
                                                    //         () {
                                                    //   setState(() {
                                                    //     isListening = false;
                                                    //     result = result;
                                                    //   });
                                                    // });
                                                  },
                                                  child: Text(
                                                    'Speak',
                                                    style: TextStyle(
                                                      color: Values.lightwhite,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  color: Color(0xFF575A89),
                                                  onPressed: () {
                                                    setState(() {
                                                      isListening = false;
                                                    });
                                                    _speech.stop();
                                                  },
                                                  child: Text(
                                                    'Stop',
                                                    style: TextStyle(
                                                      color: Values.lightwhite,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  color: Color(0xFF575A89),
                                                  onPressed: () {
                                                    setState(() {
                                                      _textEditingController
                                                          .text = result;
                                                      result = "";
                                                      Navigator.of(context)
                                                          .pop();
                                                    });
                                                  },
                                                  child: Text(
                                                    'Submit',
                                                    style: TextStyle(
                                                      color: Values.lightwhite,
                                                      letterSpacing: 1,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            } else {
                              Toast.show(
                                  'Oops!, You are now unable to perform this action :(',
                                  context,
                                  duration: 3,
                                  gravity: Toast.TOP);
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 5),
                            child: Center(
                              child: Icon(
                                (isAvailable) ? Icons.mic : Icons.mic_off,
                                size: 28,
                                color: Values.greenPalette1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Color(0xFF575A89),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              Icons.read_more_sharp,
                              color: Values.lightwhite,
                              size: 23,
                            ),
                          ],
                        ),
                      ),
                    ),
                    onPressed: () async {
                      var word = _textEditingController.text.trim();
                      if (word == "") {
                        Toast.show('Enter a Word', context,
                            duration: 3, gravity: Toast.TOP);
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.none) {
                        Toast.show(
                            'Please check your Internet Connection.', context,
                            duration: 5,
                            gravity: Toast.TOP,
                            backgroundColor: Colors.redAccent);
                      } else {
                        Navigator.of(context)
                            .push(new MaterialPageRoute(builder: (context) {
                          return DefinitionScreen(
                            word: word.trim(),
                            cameFormBookmarkScreen: false,
                          );
                        }));
                        _textEditingController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void speak() async {
    _speech.listen(
      onResult: (val) => setState(() {
        result = val.recognizedWords;
      }),
    );
  }

  void stopspeaking() {
    _speech.stop();
  }
}
