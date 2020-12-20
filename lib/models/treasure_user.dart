class TreasureUser {
  TreasureUser({firstName, lastName, url, icon, birthday})
      : _firstName = firstName,
        _lastName = lastName,
        _avatarUrl = url,
        _birthday = birthday;
  String _firstName;
  String _lastName;
  String _avatarUrl;
  DateTime _birthday;

  String get avatarUrl => _avatarUrl;
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
}
