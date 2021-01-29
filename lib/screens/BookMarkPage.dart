import 'package:connectivity/connectivity.dart';
import 'package:dicitonary/screens/definitionScreen.dart';
import 'package:dicitonary/services/bookmarks.dart';
import 'package:dicitonary/services/variablers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import 'package:toast/toast.dart';

class BookMarkPage extends StatefulWidget {
  final AnimationController animationController;

  const BookMarkPage({Key key, this.animationController}) : super(key: key);
  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  var bookmarks;
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  @override
  void initState() {
    addlistViews();
    super.initState();
  }

  addlistViews() {
    const int count = 2;
    listViews.add(BookMarkHeading(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 0, 1, curve: Curves.fastOutSlowIn))),
    ));
    listViews.add(BookMarkListView(
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

class BookMarkHeading extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  const BookMarkHeading({Key key, this.animationController, this.animation})
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
                'Bookmarks',
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

class BookMarkListView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;
  const BookMarkListView({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _BookMarkListViewState createState() => _BookMarkListViewState();
}

class _BookMarkListViewState extends State<BookMarkListView> {
  bool loading = false;

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
              child: Container(
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
                    future: callBookmarkslist(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if ((snapshot.data.length != 0)) {
                          return Container(
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return Container(
                                  color: Colors.grey.withOpacity(0.5),
                                  height: 1,
                                  width: MediaQuery.of(context).size.width,
                                );
                              },
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                List bookmarkList = snapshot.data;
                                // return Container(
                                //   child: Row(
                                //     mainAxisAlignment:
                                //         MainAxisAlignment.spaceBetween,
                                //     children: [
                                //       Padding(
                                //         padding: const EdgeInsets.all(12.0),
                                //         child: Text(
                                //           bookmarkList[index],
                                //           style: GoogleFonts.roboto(
                                //             fontSize: 18,
                                //             color: Colors.black87,
                                //           ),
                                //         ),
                                //       ),
                                //       IconButton(
                                //           icon: Icon(
                                //             Icons.delete_outline,
                                //             color: Colors.red[400],
                                //           ),
                                //           onPressed: () async {
                                //             setState(() {
                                //               loading = true;
                                //             });
                                //             StreamingSharedPreferences
                                //                 _streamingSharedPreferences =
                                //                 await StreamingSharedPreferences
                                //                     .instance;
                                //             setState(() {
                                //               bookmarkList.removeAt(index);
                                //               _streamingSharedPreferences
                                //                   .setStringList(
                                //                       'bookmarks', bookmarkList);
                                //               Bookmark.updateList();
                                //             });
                                //             await Future.delayed(
                                //                 Duration(milliseconds: 1500));
                                //             setState(() {
                                //               bookmarkList =
                                //                   Bookmark.retrieveList();
                                //               loading = false;
                                //             });
                                //           }),
                                //     ],
                                //   ),
                                // );
                                return ListTile(
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
                                          backgroundColor: Colors.redAccent);
                                    } else {
                                      Navigator.of(context)
                                          .push(new MaterialPageRoute(
                                        builder: (context) {
                                          return DefinitionScreen(
                                            word: bookmarkList[index],
                                            cameFormBookmarkScreen: true,
                                          );
                                        },
                                      ));
                                    }
                                  },
                                  dense: true,
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      bookmarkList[index],
                                      style: GoogleFonts.roboto(
                                        fontSize: 18,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: Colors.red[400],
                                      ),
                                      onPressed: () async {
                                        calldeletion(index, bookmarkList);
                                        // setState(() {
                                        //   loading = true;
                                        // });
                                        // StreamingSharedPreferences
                                        //     _streamingSharedPreferences =
                                        //     await StreamingSharedPreferences
                                        //         .instance;
                                        // setState(() {
                                        //   bookmarkList.removeAt(index);
                                        //   _streamingSharedPreferences
                                        //       .setStringList(
                                        //           'bookmarks', bookmarkList);
                                        //   Bookmark.updateList();
                                        // });
                                        // await Future.delayed(
                                        //     Duration(milliseconds: 1500));
                                        // setState(() {
                                        //   bookmarkList = Bookmark.retrieveList();
                                        //   loading = false;
                                        // });
                                      }),
                                );
                              },
                            ),
                          );
                        } else {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              child: Text(
                                'No Bookmarks Made yet.',
                                style: GoogleFonts.robotoCondensed(
                                    fontSize: 18, color: Colors.grey[700]),
                              ),
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: notfoundasset,
                                      fit: BoxFit.contain)),
                            ),
                          );
                        }
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
            ));
      },
    );
  }

  callBookmarkslist() async {
    await Bookmark.updateList();
    return Bookmark.retrieveList();
  }

  void calldeletion(index, bookmarkList) async {
    setState(() {
      loading = true;
    });
    StreamingSharedPreferences _streamingSharedPreferences =
        await StreamingSharedPreferences.instance;
    setState(() {
      bookmarkList.removeAt(index);
      bookmarkList.sort();
      _streamingSharedPreferences.setStringList('bookmarks', bookmarkList);
      Bookmark.updateList();
    });
    await Future.delayed(Duration(milliseconds: 1500));
    setState(() {
      bookmarkList = Bookmark.retrieveList();
      loading = false;
    });
  }
}
