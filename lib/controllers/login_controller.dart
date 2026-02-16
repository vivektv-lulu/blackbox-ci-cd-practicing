import 'package:flutter/material.dart';
import '../core/constants/app_strings.dart';
import '../models/user_model.dart';

/// Login controller for handling login state and business logic.
class LoginController extends ChangeNotifier {
  final UserModel _user = UserModel(email: '', password: '');
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  // Getters
  UserModel get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;

  /// Updates the email field.
  void setEmail(String email) {
    _user.email = email;
    notifyListeners();
  }

  /// Updates the password field.
  void setPassword(String password) {
    _user.password = password;
    notifyListeners();
  }

  /// Validates the login credentials.
  String? validate() {
    if (_user.email.isEmpty || _user.password.isEmpty) {
      return AppStrings.pleaseEnterBothFields;
    }
    if (!_user.isValidEmail()) {
      return AppStrings.pleaseEnterValidEmail;
    }
    if (!_user.isValidPassword()) {
      return AppStrings.passwordMinLength;
    }
    return null;
  }

  /// Performs the login operation.
  Future<bool> login() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Validate credentials
    final validationError = validate();
    if (validationError != null) {
      _errorMessage = validationError;
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Simulate successful login (in real app, this would call an API)
    _isLoading = false;
    _isLoggedIn = true;
    notifyListeners();
    return true;
  }

  /// Logs out the user.
  void logout() {
    _isLoggedIn = false;
    _user.email = '';
    _user.password = '';
    notifyListeners();
  }

  /// Clears any error messages.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
