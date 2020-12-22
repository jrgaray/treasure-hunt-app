import 'package:treasure_hunt/models/treasure_chart.dart';

class TreasureUser {
  TreasureUser({charts, uid, firstName, lastName, url, birthday, email})
      : _uid = uid,
        _firstName = firstName,
        _lastName = lastName,
        _avatarUrl = url,
        _email = email,
        _charts = charts,
        _birthday = birthday;

  String _uid;
  String _email;
  String _firstName;
  String _lastName;
  String _avatarUrl;
  DateTime _birthday;
  List<TreasureChart> _charts;
  TreasureUser.fromFirebase(Map data) {
    _uid = data["uid"];
    _email = data["email"];
    _firstName = data["firstName"];
    _lastName = data["lastName"];
    _avatarUrl = data["url"];
    _birthday = data["birthday"].toDate();
    _charts = data["charts"];
  }

  List<TreasureChart> get charts => _charts;
  String get uid => _uid;
  String get avatarUrl => _avatarUrl;
  String get email => _email;
  String get fullName => '$_firstName $_lastName';
  String get initials =>
      '${_firstName[0].toUpperCase()} ${_lastName[0].toUpperCase()}';
  DateTime get birthday => _birthday;

  Map toMap() {
    return {
      "uid": _uid,
      "firstName": _firstName,
      "lastName": _lastName,
      "avatarUrl": avatarUrl,
      "birthday": birthday
    };
  }

  void clearUser() {
    this._uid = null;
    this._email = null;
    this._firstName = null;
    this._lastName = null;
    this._avatarUrl = null;
    this._birthday = null;
    this._charts = null;
  }
}
