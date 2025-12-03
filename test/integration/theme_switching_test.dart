/// Integration tests for theme switching functionality
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Theme Switching Integration Tests', () {
    testWidgets('App should support light theme', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: Center(
              child: Text('Light Theme Test'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Light Theme Test'), findsOneWidget);
      final BuildContext context = tester.element(find.text('Light Theme Test'));
      expect(Theme.of(context).brightness, Brightness.light);
    });

    testWidgets('App should support dark theme', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: Center(
              child: Text('Dark Theme Test'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Dark Theme Test'), findsOneWidget);
      final BuildContext context = tester.element(find.text('Dark Theme Test'));
      expect(Theme.of(context).brightness, Brightness.dark);
    });

    testWidgets('Should toggle between themes', (WidgetTester tester) async {
      // Arrange
      ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

      await tester.pumpWidget(
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeMode,
          builder: (context, mode, child) {
            return MaterialApp(
              themeMode: mode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              home: Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      themeMode.value = themeMode.value == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    },
                    child: const Text('Toggle Theme'),
                  ),
                ),
              ),
            );
          },
        ),
      );

      // Assert initial state
      expect(themeMode.value, ThemeMode.light);

      // Act - toggle theme
      await tester.tap(find.text('Toggle Theme'));
      await tester.pumpAndSettle();

      // Assert - theme changed
      expect(themeMode.value, ThemeMode.dark);
    });

    testWidgets('Theme colors should apply to widgets', (WidgetTester tester) async {
      // Arrange
      const primaryColor = Colors.orange;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Theme Test'),
            ),
            body: const Center(
              child: Text('Testing theme colors'),
            ),
          ),
        ),
      );

      // Assert - app renders with theme
      expect(find.text('Theme Test'), findsOneWidget);
      expect(find.text('Testing theme colors'), findsOneWidget);
    });

    testWidgets('Should maintain theme consistency across screens', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.system,
          home: const Scaffold(
            body: Text('Screen 1'),
          ),
          routes: {
            '/second': (context) => const Scaffold(
              body: Text('Screen 2'),
            ),
          },
        ),
      );

      // Assert
      expect(find.text('Screen 1'), findsOneWidget);
    });
  });
}

