import 'package:flutter_test/flutter_test.dart';
import 'package:blackbox/models/user_model.dart';

void main() {
  group('UserModel', () {
    late UserModel userModel;

    setUp(() {
      userModel = UserModel(email: 'test@example.com', password: 'password123');
    });

    test('should create user model with given email and password', () {
      expect(userModel.email, 'test@example.com');
      expect(userModel.password, 'password123');
    });

    test('should create user model with empty default values', () {
      final emptyUser = UserModel();
      expect(emptyUser.email, '');
      expect(emptyUser.password, '');
    });

    group('isValidEmail', () {
      test('should return true for valid email', () {
        expect(userModel.isValidEmail(), true);
      });

      test('should return true for email with dots and plus', () {
        userModel.email = 'john.doe+test@example.co.uk';
        expect(userModel.isValidEmail(), true);
      });

      test('should return false for email without @', () {
        userModel.email = 'testexample.com';
        expect(userModel.isValidEmail(), false);
      });

      test('should return false for email without domain', () {
        userModel.email = 'test@';
        expect(userModel.isValidEmail(), false);
      });

      test('should return false for empty email', () {
        userModel.email = '';
        expect(userModel.isValidEmail(), false);
      });

      test('should return false for email without TLD', () {
        userModel.email = 'test@example';
        expect(userModel.isValidEmail(), false);
      });
    });

    group('isValidPassword', () {
      test('should return true for valid password (6+ characters)', () {
        expect(userModel.isValidPassword(), true);
      });

      test('should return true for exactly 6 characters', () {
        userModel.password = '123456';
        expect(userModel.isValidPassword(), true);
      });

      test('should return false for password less than 6 characters', () {
        userModel.password = '12345';
        expect(userModel.isValidPassword(), false);
      });

      test('should return false for empty password', () {
        userModel.password = '';
        expect(userModel.isValidPassword(), false);
      });
    });

    group('copyWith', () {
      test('should create copy with updated email', () {
        final copy = userModel.copyWith(email: 'new@example.com');
        expect(copy.email, 'new@example.com');
        expect(copy.password, 'password123');
      });

      test('should create copy with updated password', () {
        final copy = userModel.copyWith(password: 'newpassword');
        expect(copy.email, 'test@example.com');
        expect(copy.password, 'newpassword');
      });

      test('should create copy with both values updated', () {
        final copy = userModel.copyWith(
          email: 'new@example.com',
          password: 'newpassword',
        );
        expect(copy.email, 'new@example.com');
        expect(copy.password, 'newpassword');
      });

      test('should retain original values when no parameters provided', () {
        final copy = userModel.copyWith();
        expect(copy.email, 'test@example.com');
        expect(copy.password, 'password123');
      });
    });
  });
}
