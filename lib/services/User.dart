import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier {
  String username;
  final bool isMale;

  User(this.username, this.isMale);

  static updateName(String name) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool x = preferences.getBool('male');
    _user = User(name,x);
  }

  static String getName() {
    return _user.username;
  }

  static bool getGender() {
    return _user.isMale;
  }

  /////////

  // String _username;
  // bool _isMale;

  // get username => username;

  // set username(String value) {
  //   _username = value;
  //   notifyListeners();
  // }

  // get isMale => isMale;

  // set isMale(bool state) {
  //   isMale = state;
  //   notifyListeners();
  // }

  // updateUsername(String value) {
  //   username = value;
  //   notifyListeners();
  //   updategender();
  // }

  // updategender() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   isMale = preferences.getBool('male');
  //   notifyListeners();
  // }
}

User _user;
