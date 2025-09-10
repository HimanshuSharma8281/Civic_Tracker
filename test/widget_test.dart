// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:civic_report/main.dart';

void main() {
  testWidgets('CivicReport app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Wait for the splash screen to complete
    await tester.pumpAndSettle(Duration(seconds: 4));

    // Verify that we can find the login screen elements
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Sign in to continue to CivicReport'), findsOneWidget);

    // Verify social login buttons are present
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Facebook'), findsOneWidget);
    expect(find.text('Continue with Twitter'), findsOneWidget);
  });

  testWidgets('Login screen navigation test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Wait for the splash screen to complete
    await tester.pumpAndSettle(Duration(seconds: 4));

    // Find and tap the "Sign Up" button to switch to register screen
    expect(find.text('Sign Up'), findsOneWidget);
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    // Verify we're now on the register screen
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Join CivicReport to start making a difference'),
        findsOneWidget);
  });
}
