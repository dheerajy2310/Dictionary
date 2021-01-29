import 'package:dicitonary/screens/searchbutton.dart';
import 'package:flutter/material.dart';
import 'package:dicitonary/services/User.dart';
import 'package:dicitonary/services/variablers.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  final AnimationController animationController;
  SearchPage({Key key, this.animationController}) : super(key: key);

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  bool loading1 = false;

  @override
  void initState() {
    super.initState();
    addlistviews();
  }

  addlistviews() {
    const int count = 3;
    listViews.add(GreetingText(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 0, 1, curve: Curves.fastOutSlowIn))),
    ));
    listViews.add(Head1text(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 1, 1, curve: Curves.fastOutSlowIn))),
    ));
    listViews.add(Search(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 2, 1, curve: Curves.fastOutSlowIn))),
    ));
    listViews.add(ImageinSearchPage(
      animationController: widget.animationController,
      animation: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: widget.animationController,
          curve: Interval((1 / count) * 3, 1, curve: Curves.fastOutSlowIn))),
    ));
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Values.lightwhite,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: showListview()),
    );
  }

  stoploading() {
    setState(() {
      loading1 = false;
    });
  }

  startloading() {
    setState(() {
      loading1 = true;
    });
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

class GreetingText extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  const GreetingText({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    String greeting = greetingmessage();
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform:
                Matrix4.translationValues(0, 50 * (1 - animation.value), 0),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              // child: Center(child: Text(greeting+User.getName())),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(greeting + ',',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600])),
                  SizedBox(height: 4),
                  Text(
                    User.getName().toString().substring(0, 1).toUpperCase() +
                        User.getName().toString().substring(1),
                    style: GoogleFonts.roboto(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[900]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String greetingmessage() {
    var datetime = DateTime.now().hour;
    if (datetime < 12)
      return 'Good Morning ';
    else if (datetime < 17)
      return 'Good Afternoon ';
    else
      return 'Good Evening ';
  }
}

class Head1text extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  const Head1text({Key key, this.animationController, this.animation})
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Tap the Submit Button to get the Definitions:',
                    style: GoogleFonts.robotoCondensed(
                      letterSpacing: 0.5,
                      color: Colors.grey[600],
                      fontSize: 13,
                    )),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ImageinSearchPage extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  ImageinSearchPage({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AssetImage searchasset1 = AssetImage('assets/searchAsset.png');
    // AssetImage searchasset = AssetImage('assets/searchAsset2.png');
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform:
                new Matrix4.translationValues(0, 50 * (1 - animation.value), 0),
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: searchasset1,
                    fit: BoxFit.contain,
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
