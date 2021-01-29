import 'package:dicitonary/screens/MailScreen.dart';
import 'package:dicitonary/services/variablers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  AssetImage helpasset = AssetImage('assets/contactusAsset.png');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Values.lightwhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.grey[600],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top:5.0),
          child: Text(
            'Help',
            style: GoogleFonts.roboto(
                fontSize: 24,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: helpasset,
                fit: BoxFit.contain,
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  'It looks like you are facing problems with our application. We are here to help you, so please get in touch with us.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(fontSize: 16, wordSpacing: 1)),
            ),
            SizedBox(height: 15),
            Center(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Color(0xFF575A89),
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(
                    builder: (context) {
                      return MailtoScreen();
                    },
                  ));
                },
                child: Text(
                  'Contact Us',
                  style: TextStyle(
                    color: Values.lightwhite,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
