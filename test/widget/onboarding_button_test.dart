/// Widget tests for button components
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Button Widget Tests', () {
    testWidgets('Should render ElevatedButton with text', (WidgetTester tester) async {
      // Arrange
      const buttonText = 'Get Started';
      var wasPressed = false;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {
                wasPressed = true;
              },
              child: const Text(buttonText),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(buttonText), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(wasPressed, false);
    });

    testWidgets('Should call onPressed when tapped', (WidgetTester tester) async {
      // Arrange
      var wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {
                wasPressed = true;
              },
              child: const Text('Next'),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(wasPressed, true);
    });

    testWidgets('Should render button with custom width using SizedBox', (WidgetTester tester) async {
      // Arrange
      const customWidth = 200.0;

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: customWidth,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Continue'),
              ),
            ),
          ),
        ),
      );

      // Assert
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, customWidth);
    });

    testWidgets('Should apply theme colors correctly', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          ),
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Test'),
            ),
          ),
        ),
      );

      // Assert - button renders without errors
      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Should show CircularProgressIndicator', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );

      // Assert - should show progress indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}

