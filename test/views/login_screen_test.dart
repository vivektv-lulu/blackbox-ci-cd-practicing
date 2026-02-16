import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:blackbox/controllers/login_controller.dart';
import 'package:blackbox/views/login/login_screen.dart';
import 'package:blackbox/core/constants/app_strings.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    late LoginController loginController;

    setUp(() {
      loginController = LoginController();
    });

    tearDown(() {
      loginController.dispose();
    });

    Widget createWidgetUnderTest() {
      return ChangeNotifierProvider<LoginController>.value(
        value: loginController,
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      );
    }

    testWidgets('should display login screen with all required elements', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify AppBar title
      expect(find.text(AppStrings.login), findsNWidgets(2)); // AppBar + button

      // Verify welcome text
      expect(find.text(AppStrings.welcomeBack), findsOneWidget);
      expect(find.text(AppStrings.pleaseLogin), findsOneWidget);

      // Verify email and password text fields
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Verify login button (ElevatedButton)
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Verify lock icon
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('should display email and password text fields', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find TextFormFields
      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(2));
    });

    testWidgets('should allow entering email', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the email text field (first TextFormField)
      final emailField = find.byType(TextFormField).first;

      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('should allow entering password', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find the password text field (second TextFormField)
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      expect(find.text('password123'), findsOneWidget);
    });

    testWidgets('should show validation error for empty email', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter only password
      final passwordField = find.byType(TextFormField).last;
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Tap login button (use ElevatedButton instead of text)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text(AppStrings.pleaseEnterEmail), findsOneWidget);
    });

    testWidgets('should show validation error for empty password', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter only email
      final emailField = find.byType(TextFormField).first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pump();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text(AppStrings.pleaseEnterPassword), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email format', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter invalid email and valid password
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'invalid-email');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text(AppStrings.pleaseEnterValidEmail), findsOneWidget);
    });

    testWidgets('should show validation error for short password', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid email and short password
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, '12345');
      await tester.pump();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify validation error
      expect(find.text(AppStrings.passwordMinLength), findsOneWidget);
    });

    testWidgets('should show password visibility toggle', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Initially password should be obscured
      // Find the visibility toggle button
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      // Tap to toggle visibility
      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pump();

      // Now should show visibility icon
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('should display loading indicator during login', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Enter valid credentials
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password123');
      await tester.pump();

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));

      // Pump immediately to check loading state before the async operation completes
      await tester.pump();

      // Should show loading indicator (button is disabled during loading)
      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(elevatedButton.onPressed, isNull);

      // Complete the test by waiting for the login to finish
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('should have properly styled AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Verify AppBar exists
      expect(find.byType(AppBar), findsOneWidget);

      // Verify AppBar has title
      final appBar = tester.widget<AppBar>(find.byType(AppBar));
      expect(appBar.title, isNotNull);
      expect(appBar.centerTitle, true);
    });

    testWidgets('should have properly styled welcome text', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Find welcome text
      final welcomeText = find.text(AppStrings.welcomeBack);
      expect(welcomeText, findsOneWidget);

      // Find Text widget and verify it's styled as headline
      final textWidget = tester.widget<Text>(welcomeText);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });
  });
}
