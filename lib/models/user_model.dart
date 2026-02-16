/// User model representing user data in the application.
class UserModel {
  String email;
  String password;

  UserModel({
    this.email = '',
    this.password = '',
  });

  /// Validates the email format.
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validates the password (minimum 6 characters).
  bool isValidPassword() {
    return password.length >= 6;
  }

  /// Creates a copy of the user model with updated fields.
  UserModel copyWith({
    String? email,
    String? password,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
