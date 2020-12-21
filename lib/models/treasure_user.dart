class TreasureUser {
  TreasureUser({firstName, lastName, url, birthday, email})
      : _firstName = firstName,
        _lastName = lastName,
        _avatarUrl = url,
        _email = email,
        _birthday = birthday;

  String _email;
  String _firstName;
  String _lastName;
  String _avatarUrl;
  DateTime _birthday;
  TreasureUser.fromFirebase(Map data) {
    _email = data["email"];
    _firstName = data["firstName"];
    _lastName = data["lastName"];
    _avatarUrl = data["url"];
    _birthday = data["birthday"].toDate();
  }

  String get avatarUrl => _avatarUrl;
  String get email => _email;
  String get fullName => '$_firstName $_lastName';
  String get initials =>
      '${_firstName[0].toUpperCase()} ${_lastName[0].toUpperCase()}';
  DateTime get birthday => _birthday;
  Map toMap() {
    return {
      "firstName": _firstName,
      "lastName": _lastName,
      "avatarUrl": avatarUrl,
      "birthday": birthday
    };
  }

  void clearUser() {
    this._email = null;
    this._firstName = null;
    this._lastName = null;
    this._avatarUrl = null;
    this._birthday = null;
  }
}
