/// Integration tests for app navigation flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Navigation Flow Integration Tests', () {
    testWidgets('Should navigate from screen A to screen B', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Scaffold(
                            body: Center(child: Text('Screen B')),
                          ),
                        ),
                      );
                    },
                    child: const Text('Go to Screen B'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Assert initial state
      expect(find.text('Go to Screen B'), findsOneWidget);
      expect(find.text('Screen B'), findsNothing);

      // Act - navigate
      await tester.tap(find.text('Go to Screen B'));
      await tester.pumpAndSettle();

      // Assert - navigated to new screen
      expect(find.text('Screen B'), findsOneWidget);
    });

    testWidgets('Should navigate back using back button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Home')),
            body: Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            appBar: AppBar(title: const Text('Details')),
                            body: const Center(child: Text('Details Screen')),
                          ),
                        ),
                      );
                    },
                    child: const Text('Go to Details'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Act - navigate forward
      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle();

      // Assert - on details screen
      expect(find.text('Details Screen'), findsOneWidget);

      // Act - navigate back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Assert - back on home screen
      expect(find.text('Go to Details'), findsOneWidget);
      expect(find.text('Details Screen'), findsNothing);
    });

    testWidgets('Should handle named routes', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/second');
                  },
                  child: const Text('Go to Second'),
                ),
              ),
            ),
            '/second': (context) => const Scaffold(
              body: Center(child: Text('Second Screen')),
            ),
          },
        ),
      );

      // Assert initial state
      expect(find.text('Go to Second'), findsOneWidget);

      // Act - navigate using named route
      await tester.tap(find.text('Go to Second'));
      await tester.pumpAndSettle();

      // Assert - navigated to named route
      expect(find.text('Second Screen'), findsOneWidget);
    });

    testWidgets('Should replace route with pushReplacement', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Scaffold(
                            body: Center(child: Text('Replacement Screen')),
                          ),
                        ),
                      );
                    },
                    child: const Text('Replace Screen'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Replace Screen'));
      await tester.pumpAndSettle();

      // Assert - on replacement screen, no back button
      expect(find.text('Replacement Screen'), findsOneWidget);
      expect(find.byType(BackButton), findsNothing);
    });

    testWidgets('Should handle nested navigation', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Scaffold(
                            body: Builder(
                              builder: (innerContext) {
                                return Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        innerContext,
                                        MaterialPageRoute(
                                          builder: (_) => const Scaffold(
                                            body: Center(child: Text('Third Screen')),
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Go to Third'),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('First Button'),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Act - navigate to second screen
      await tester.tap(find.text('First Button'));
      await tester.pumpAndSettle();

      // Act - navigate to third screen
      await tester.tap(find.text('Go to Third'));
      await tester.pumpAndSettle();

      // Assert - on third screen
      expect(find.text('Third Screen'), findsOneWidget);
    });
  });
}

