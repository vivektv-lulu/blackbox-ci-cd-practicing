import 'package:flutter_test/flutter_test.dart';
import 'package:blackbox/controllers/login_controller.dart';

void main() {
  group('LoginController', () {
    late LoginController controller;

    setUp(() {
      controller = LoginController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('should have initial default values', () {
      expect(controller.user.email, '');
      expect(controller.user.password, '');
      expect(controller.isLoading, false);
      expect(controller.errorMessage, null);
      expect(controller.isLoggedIn, false);
    });

    group('setEmail', () {
      test('should update email correctly', () {
        controller.setEmail('test@example.com');
        expect(controller.user.email, 'test@example.com');
      });

      test('should notify listeners when email changes', () {
        bool notified = false;
        controller.addListener(() {
          notified = true;
        });
        controller.setEmail('test@example.com');
        expect(notified, true);
      });
    });

    group('setPassword', () {
      test('should update password correctly', () {
        controller.setPassword('password123');
        expect(controller.user.password, 'password123');
      });

      test('should notify listeners when password changes', () {
        bool notified = false;
        controller.addListener(() {
          notified = true;
        });
        controller.setPassword('password123');
        expect(notified, true);
      });
    });

    group('validate', () {
      test('should return error message for empty email and password', () {
        final result = controller.validate();
        expect(result, isNotNull);
        expect(result, contains('email'));
        expect(result, contains('password'));
      });

      test('should return error message for empty email', () {
        controller.setPassword('password123');
        final result = controller.validate();
        expect(result, isNotNull);
        expect(result, contains('email'));
      });

      test('should return error message for empty password', () {
        controller.setEmail('test@example.com');
        final result = controller.validate();
        expect(result, isNotNull);
        expect(result, contains('password'));
      });

      test('should return error message for invalid email format', () {
        controller.setEmail('invalid-email');
        controller.setPassword('password123');
        final result = controller.validate();
        expect(result, isNotNull);
        expect(result, contains('valid email'));
      });

      test('should return error message for short password', () {
        controller.setEmail('test@example.com');
        controller.setPassword('12345');
        final result = controller.validate();
        expect(result, isNotNull);
        expect(result, contains('6 characters'));
      });

      test('should return null for valid credentials', () {
        controller.setEmail('test@example.com');
        controller.setPassword('password123');
        final result = controller.validate();
        expect(result, isNull);
      });
    });

    group('login', () {
      test('should set isLoading to true during login', () async {
        controller.setEmail('test@example.com');
        controller.setPassword('password123');

        final future = controller.login();
        // Check immediately after calling
        expect(controller.isLoading, true);

        await future;
      });

      test('should return false and set error for invalid credentials', () async {
        final result = await controller.login();

        expect(result, false);
        expect(controller.errorMessage, isNotNull);
        expect(controller.isLoading, false);
      });

      test('should return true and set isLoggedIn for valid credentials', () async {
        controller.setEmail('test@example.com');
        controller.setPassword('password123');

        final result = await controller.login();

        expect(result, true);
        expect(controller.isLoggedIn, true);
        expect(controller.isLoading, false);
      });

      test('should clear previous error message on successful login', () async {
        // First, try to login with invalid credentials
        await controller.login();
        expect(controller.errorMessage, isNotNull);

        // Now login with valid credentials
        controller.setEmail('test@example.com');
        controller.setPassword('password123');

        final result = await controller.login();

        expect(result, true);
        expect(controller.errorMessage, isNull);
      });
    });

    group('logout', () {
      test('should reset all values on logout', () async {
        // First login
        controller.setEmail('test@example.com');
        controller.setPassword('password123');
        await controller.login();
        expect(controller.isLoggedIn, true);

        // Now logout
        controller.logout();

        expect(controller.isLoggedIn, false);
        expect(controller.user.email, '');
        expect(controller.user.password, '');
      });

      test('should notify listeners on logout', () async {
        await controller.login();

        bool notified = false;
        controller.addListener(() {
          notified = true;
        });
        controller.logout();
        expect(notified, true);
      });
    });

    group('clearError', () {
      test('should clear error message', () async {
        // Trigger an error
        await controller.login();
        expect(controller.errorMessage, isNotNull);

        controller.clearError();

        expect(controller.errorMessage, null);
      });

      test('should notify listeners when clearing error', () {
        bool notified = false;
        controller.addListener(() {
          notified = true;
        });
        controller.clearError();
        expect(notified, true);
      });
    });
  });
}

