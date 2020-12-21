import 'package:flutter/foundation.dart';
import 'package:treasure_hunt/models/treasure_user.dart';

class UserState with ChangeNotifier {
  TreasureUser _user = new TreasureUser();
  bool _hasUser;

  UserState() {
    _user = null;
  }

  TreasureUser get user => _user;
  bool get hasUser => _hasUser;

  void setUser(TreasureUser user) {
    _user = user;
  }

  void clearUser() {
    _user = null;
    _hasUser = false;
  }
}
