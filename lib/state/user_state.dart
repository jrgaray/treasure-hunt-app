import 'package:flutter/foundation.dart';
import 'package:treasure_hunt/models/treasure_user.dart';

class UserState with ChangeNotifier {
  TreasureUser _user = new TreasureUser();

  UserState() {
    _user = null;
  }

  TreasureUser get user => _user;

  void setUser(TreasureUser user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
