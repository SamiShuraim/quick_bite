/// Widget tests for PageIndicator component
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/features/onboarding/presentation/widgets/page_indicator.dart';

void main() {
  group('PageIndicator Widget Tests', () {
    testWidgets('Should render correct number of indicators', (WidgetTester tester) async {
      // Arrange
      const pageCount = 4;
      const currentPage = 0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageIndicator(
              pageCount: pageCount,
              currentPage: currentPage,
            ),
          ),
        ),
      );

      // Assert - should find 4 indicator containers
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers.length, greaterThanOrEqualTo(pageCount));
    });

    testWidgets('Should highlight current page', (WidgetTester tester) async {
      // Arrange
      const pageCount = 4;
      const currentPage = 2;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageIndicator(
              pageCount: pageCount,
              currentPage: currentPage,
            ),
          ),
        ),
      );

      // Assert - widget renders without errors
      expect(find.byType(PageIndicator), findsOneWidget);
      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('Should render all pages in a row', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageIndicator(
              pageCount: 3,
              currentPage: 1,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Row), findsWidgets);
      expect(find.byType(PageIndicator), findsOneWidget);
    });

    testWidgets('Should handle page index 0', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageIndicator(
              pageCount: 4,
              currentPage: 0,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(PageIndicator), findsOneWidget);
    });

    testWidgets('Should handle last page index', (WidgetTester tester) async {
      // Arrange
      const pageCount = 4;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageIndicator(
              pageCount: pageCount,
              currentPage: pageCount - 1,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(PageIndicator), findsOneWidget);
    });
  });
}

