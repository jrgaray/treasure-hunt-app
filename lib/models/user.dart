class User {
  User(
      {String firstName,
      String lastName,
      String url,
      String icon,
      DateTime birthday})
      : _firstName = firstName,
        _lastName = lastName,
        _avatarUrl = url,
        _icon = icon,
        _birthday = birthday;
  String _firstName;
  String _lastName;
  String _icon;
  String _avatarUrl;
  DateTime _birthday;

  String get firstName => _firstName;
  String get lastName => _lastName;
  String get avatarUrl => _avatarUrl;
  String get fullName => '$_firstName $_lastName';
  String get initials =>
      '${_firstName[0].toUpperCase()} ${_lastName[0].toUpperCase()}';
  DateTime get birthday => _birthday;
  String get icon => _icon;
}
