class UserCredentials {
  UserCredentials({username, password})
      : _username = username,
        _password = password;
  String _username;
  String _password;

  /// Returns the user's username.
  String get username => _username;

  /// Returns the user's password.
  String get password => _password;

  /// Sets a user's username.
  set setUsername(username) => _username = username;

  /// Sets a user's password.
  set setPassword(password) => _password = password;
}
