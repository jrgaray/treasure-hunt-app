import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/models/treasure_user.dart';

class UserState with ChangeNotifier {
  TreasureUser _user;

  TreasureUser get user => _user;

  void setUser(TreasureUser user) {
    _user = user;
    notifyListeners();
  }
}
