import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/models/user.dart';

class UserState with ChangeNotifier {
  User _user;
  String _username = '';
  String _password = '';

  User get user => _user;
  String get username => _username;
  String get password => _password;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void setPassword(password) {
    _password = password;
    notifyListeners();
  }

  void setUsername(username) {
    _username = username;
    notifyListeners();
  }
}
