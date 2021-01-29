import 'package:connectivity/connectivity.dart';
import 'package:dicitonary/screens/definitionScreen.dart';
import 'package:dicitonary/services/history.dart';
import 'package:dicitonary/services/variablers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:toast/toast.dart';

class HistoryPage extends StatefulWidget {
  final AnimationController animationController;

  const HistoryPage({Key key, this.animationController}) : super(key: key);
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    addlistViews();
    super.initState();
  }

  addlistViews() {
    const int count = 2;
    listViews.add(HistoryHeading(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 0, 1, curve: Curves.fastOutSlowIn))),
    ));
    listViews.add(HistoryListView(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 1, 1, curve: Curves.fastOutSlowIn))),
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

class HistoryHeading extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  const HistoryHeading({Key key, this.animationController, this.animation})
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: GoogleFonts.roboto(
                        fontSize: 24,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HistoryListView extends StatefulWidget {
  final Animation animation;
  final AnimationController animationController;
  HistoryListView({Key key, this.animation, this.animationController})
      : super(key: key);

  @override
  _HistoryListViewState createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  bool loading = false;
  List historylist = List();
  List temp = List();

  gethistory() async {
    StreamingSharedPreferences _streamedSharedPreferences =
        await StreamingSharedPreferences.instance;
    temp = _streamedSharedPreferences
        .getStringList('history', defaultValue: []).getValue();
  }

  @override
  void initState() {
    gethistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AssetImage notfoundasset = AssetImage('assets/notFoundasset.png');
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: new Matrix4.translationValues(
                0, 50 * (1 - widget.animation.value), 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                        onPressed: () async {
                          (temp.length != 0)
                              ? showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      title: Text(
                                        'Are you sure..',
                                        style: GoogleFonts.roboto(
                                            fontWeight: FontWeight.w500),
                                      ),
                                      content: Text(
                                        'Do you want to Clear the History ?',
                                        style: GoogleFonts.roboto(
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () async {
                                            setState(() {
                                              loading = true;
                                              historylist = [];
                                              temp = [];
                                            });
                                            StreamingSharedPreferences
                                                _streamedSharedPreferences =
                                                await StreamingSharedPreferences
                                                    .instance;
                                            _streamedSharedPreferences
                                                .setStringList('history', []);

                                            setState(() {
                                              loading = false;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Yes',
                                            style: GoogleFonts.roboto(
                                              color: Values.simpleGreen,
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'No',
                                            style: GoogleFonts.roboto(
                                              color: Values.simpleGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  })
                              : showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      content: Text(
                                        'No History Found.',
                                        style: GoogleFonts.roboto(
                                            letterSpacing: 1,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      actions: [
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Close',
                                            style: GoogleFonts.roboto(
                                              color: Values.simpleGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                        },
                        child: Text(
                          'Clear History',
                          style: GoogleFonts.robotoCondensed(
                              color: Color(0xFF575A89),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ModalProgressHUD(
                    inAsyncCall: loading,
                    opacity: 0,
                    progressIndicator: Center(
                      child: Container(
                        height: 50,
                        width: 50,
                        child: LoadingIndicator(
                          indicatorType: Indicator.lineSpinFadeLoader,
                          color: Values.greenPalette1,
                        ),
                      ),
                    ),
                    child: FutureBuilder(
                      future: callHistoryList(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return (snapshot.data.length != 0)
                              ? Container(
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    separatorBuilder: (context, index) {
                                      return Container(
                                        color: Colors.grey.withOpacity(0.5),
                                        height: 1,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      );
                                    },
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      historylist = snapshot.data;
                                      return ListTile(
                                        subtitle: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            historylist[index],
                                            style: GoogleFonts.roboto(
                                              fontSize: 18,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          var connectivityResult =
                                              await (Connectivity()
                                                  .checkConnectivity());
                                          if (connectivityResult ==
                                              ConnectivityResult.none) {
                                            Toast.show(
                                                'Please check your Internet Connection.',
                                                context,
                                                duration: 5,
                                                gravity: Toast.TOP,
                                                backgroundColor:
                                                    Colors.redAccent);
                                          } else {
                                            var word = historylist[index];
                                            Navigator.of(context)
                                                .push(new MaterialPageRoute(
                                              builder: (context) {
                                                return DefinitionScreen(
                                                  word: word,
                                                  cameFormBookmarkScreen: false,
                                                );
                                              },
                                            ));
                                            StreamingSharedPreferences
                                                _streamingSharedPreferences =
                                                await StreamingSharedPreferences
                                                    .instance;
                                            // historylist = _streamingSharedPreferences
                                            //     .getStringList('history',
                                            //         defaultValue: []).getValue();
                                            setState(() {
                                              var temp = historylist[index];
                                              historylist.remove(temp);
                                              historylist.insert(0, temp);
                                              _streamingSharedPreferences
                                                  .setStringList(
                                                      'history', historylist);
                                            });
                                          }
                                        },
                                        trailing: IconButton(
                                          icon: Icon(
                                            Icons.clear_outlined,
                                            color: Colors.red[400],
                                          ),
                                          onPressed: () async {
                                            calldeletion(index, historylist);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width: MediaQuery.of(context).size.width,
                                  child: Container(
                                    child: Text(
                                      'No History Found yet.',
                                      style: GoogleFonts.robotoCondensed(
                                          fontSize: 18,
                                          color: Colors.grey[700]),
                                    ),
                                    alignment: Alignment.bottomCenter,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: notfoundasset,
                                            fit: BoxFit.contain)),
                                  ),
                                );
                        } else
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
              ],
            ),
          ),
        );
      },
    );
  }

  callHistoryList() async {
    await History.updateHistory();
    return History.retrieveHistory();
  }

  void calldeletion(int index, List historylist) async {
    setState(() {
      loading = true;
    });
    StreamingSharedPreferences _streamingSharedPreferences =
        await StreamingSharedPreferences.instance;
    setState(() {
      historylist.removeAt(index);
      _streamingSharedPreferences.setStringList('history', historylist);
      History.updateHistory();
    });
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      historylist = History.retrieveHistory();
      loading = false;
    });
  }
}
