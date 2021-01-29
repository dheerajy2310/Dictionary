import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:dicitonary/services/bookmarks.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:dicitonary/services/variablers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:substring_highlight/substring_highlight.dart';
import 'package:toast/toast.dart';

class DefinitionScreen extends StatefulWidget {
  final String word;
  final bool cameFormBookmarkScreen;

  const DefinitionScreen({Key key, this.word, this.cameFormBookmarkScreen})
      : super(key: key);
  @override
  _DefinitionScreenState createState() => _DefinitionScreenState();
}

class _DefinitionScreenState extends State<DefinitionScreen> {
  StreamingSharedPreferences _streamingSharedPreferences;
  List bookmarks = List();
  List<String> history = List<String>();
  FlutterTts flutterTts = FlutterTts();
  AssetImage asset404 = AssetImage('assets/404asset.png');
  var data;
  var connectionStatus;
  var subscription;
  bool marked = false;

  callStreamingSharedPreferences() async {
    _streamingSharedPreferences = await StreamingSharedPreferences.instance;
  }

  void checkInternetConnectivity() {
    if (connectionStatus == ConnectivityResult.none) {
      return Toast.show('Oops! check your Internet Connection.', context,
          duration: 6,
          gravity: Toast.TOP,
          backgroundColor: Colors.redAccent,
          textColor: Values.lightwhite);
    }
  }

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
    callStreamingSharedPreferences();
    data = callApi(widget.word);
    checkWetherBookmarked(widget.word);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Values.lightwhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 28,
            color: Values.greenPalette2,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: FutureBuilder(
            future: data,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data['error'] != 'undefined word')
                  return wordView(snapshot.data);
                else
                  return Column(
                    children: [
                      Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.45,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: asset404,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        'Word not found :(',
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 18, color: Colors.grey[700]),
                      ),
                    ],
                  );
              }
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineSpinFadeLoader,
                    color: Values.greenPalette1,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  callApi(String word) async {
    var owlBoturl = "https://owlbot.info/api/v4/dictionary/";
    var wordNetUrl =
        "https://aplet123-wordnet-search-v1.p.rapidapi.com/master?word=";
    var response = await http.get(wordNetUrl + word, headers: {
      "x-rapidapi-key": ''//use rapid-API key
    });
    print(response.body);
    var body = jsonDecode(response.body);
    if (body['error'] != 'undefined word') {
      history = _streamingSharedPreferences
          .getStringList('history', defaultValue: []).getValue();

      if (history.contains(word)) {
        setState(() {
          history.remove(word);
        });
      }
      history.insert(0, word);
      _streamingSharedPreferences
          .setStringList('history', history)
          .then((value) => print('history updated'));
    }
    return (body);
  }

  Widget wordView(data) {
    /////change the definition if it is null
    var text = data['definition']
        .toString()
        .replaceAll('\;', '\;\n')
        .replaceAll('S:', '\n➜');
    if (data['definition'] == "" || data['definition'] == null) {
      text = 'Definition not Found for ${widget.word}';
    }
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.word.toString().substring(0, 1).toUpperCase() +
                      widget.word.toString().substring(1),
                  style: GoogleFonts.robotoCondensed(
                      color: Colors.black87,
                      fontSize: 38,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.volume_up_outlined,
                    size: 24,
                    color: Colors.indigoAccent,
                  ),
                  onPressed: () {
                    speak(widget.word);
                  },
                ),
                (!widget.cameFormBookmarkScreen)
                    ? IconButton(
                        icon: Icon(
                            (!marked) ? Icons.bookmark_border : Icons.bookmark,
                            size: 28,
                            color: Values.lightSimpleGreen),
                        onPressed: () {
                          bookmarks = _streamingSharedPreferences.getStringList(
                              'bookmarks',
                              defaultValue: []).getValue();
                          setState(() {
                            marked = !marked;
                            if (marked == true) {
                              Toast.show(
                                  '${widget.word} added to Bookmarks.', context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.TOP);
                              if (!bookmarks.contains(widget.word))
                                bookmarks.add(widget.word);
                              bookmarks.sort();
                              _streamingSharedPreferences
                                  .setStringList('bookmarks', bookmarks)
                                  .then((value) => print('done'));
                            } else {
                              Toast.show(
                                  '${widget.word} removed from Bookmarks.',
                                  context,
                                  duration: Toast.LENGTH_SHORT,
                                  gravity: Toast.TOP);
                              if (bookmarks.contains(widget.word)) {
                                bookmarks.remove(widget.word);
                                bookmarks.sort();
                                _streamingSharedPreferences
                                    .setStringList('bookmarks', bookmarks)
                                    .then((value) => print('done'));
                              }
                            }
                            print(_streamingSharedPreferences.getStringList(
                                'bookmarks',
                                defaultValue: []).getValue());
                          });
                        },
                      )
                    : SizedBox(),
              ],
            ),
            SubstringHighlight(
              text: text,
              term: widget.word,
              textStyle: GoogleFonts.robotoCondensed(
                color: Colors.grey[600],
                fontSize: 18,
              ),
              textStyleHighlight: GoogleFonts.robotoCondensed(
                color: Values.greenPalette1,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }

  void speak(String word) async {
    await flutterTts.speak(word);
    Toast.show('speaking...', context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
  }

  void checkWetherBookmarked(String word) {
    List list = Bookmark.retrieveList();
    print('list is ${list.toString()}');
    if (list.contains(word)) {
      setState(() {
        marked = true;
      });
    } else {
      setState(() {
        marked = false;
      });
    }
  }
}
