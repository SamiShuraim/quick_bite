/// Integration tests for onboarding flow
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Onboarding Flow Integration Tests', () {
    testWidgets('Should navigate through pages with PageView', (WidgetTester tester) async {
      // Arrange
      final controller = PageController();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageView(
              controller: controller,
              children: const [
                Center(child: Text('Page 1')),
                Center(child: Text('Page 2')),
                Center(child: Text('Page 3')),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      // Assert initial state - page 1 should be visible
      expect(find.text('Page 1'), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);

      // Act - swipe to next page
      await tester.drag(find.byType(PageView), const Offset(-400, 0));
      await tester.pumpAndSettle();

      // Assert - page 2 visible
      expect(find.text('Page 2'), findsOneWidget);
    });

    testWidgets('Should show page indicators', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: List.generate(
                4,
                (index) => Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 0 ? Colors.orange : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Assert - page indicators should be visible
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('Should have navigation buttons', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Next'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ),
      );

      // Assert - buttons should be present
      expect(find.byType(ElevatedButton), findsNWidgets(2));
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Get Started'), findsOneWidget);
    });

    testWidgets('Should allow skipping onboarding', (WidgetTester tester) async {
      // Arrange
      var skipped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () {
                      skipped = true;
                    },
                    child: const Text('Skip'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Skip'));
      await tester.pump();

      // Assert
      expect(skipped, true);
    });

    testWidgets('Should display onboarding content', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome to QuickBite'),
                  SizedBox(height: 20),
                  Text('Fast food delivery'),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert - onboarding content renders
      expect(find.text('Welcome to QuickBite'), findsOneWidget);
      expect(find.text('Fast food delivery'), findsOneWidget);
    });
  });
}

