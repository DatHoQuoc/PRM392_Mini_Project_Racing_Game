import 'package:flutter/foundation.dart';

import '../core/constants/app_strings.dart';

/// Authentication state for the Login screen.
///
/// Validation is hard-coded (demo credentials) — no backend. Holds whether the
/// user is logged in and the last error message; the View only renders and
/// navigates based on this state.
class AuthViewModel extends ChangeNotifier {
  String  _username   = '';
  bool    _isLoggedIn = false;
  String? _error;

  String  get username   => _username;
  bool    get isLoggedIn => _isLoggedIn;
  String? get error      => _error;

  /// Validate [username]/[password] against the demo credentials.
  /// Returns true on success; sets [error] and returns false otherwise.
  bool login(String username, String password) {
    final user = username.trim();
    if (user == AppStrings.demoUsername && password == AppStrings.demoPassword) {
      _username   = user;
      _isLoggedIn = true;
      _error      = null;
      notifyListeners();
      return true;
    }
    _error = 'Wrong credentials. Try ${AppStrings.demoHint}';
    notifyListeners();
    return false;
  }

  void logout() {
    _username   = '';
    _isLoggedIn = false;
    _error      = null;
    notifyListeners();
  }
}
