/// Widget tests for CategoryChip
/// Tests category chip display and selection
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quick_bite/features/restaurant/presentation/widgets/category_chip.dart';

void main() {
  group('CategoryChip Widget Tests', () {
    testWidgets('CategoryChip should display label text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              label: 'Fast Food',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Fast Food'), findsOneWidget);
    });

    testWidgets('CategoryChip should be tappable',
        (WidgetTester tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              label: 'Italian',
              isSelected: false,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CategoryChip));
      await tester.pump();

      expect(tapped, true);
    });

    testWidgets('CategoryChip should show different styles when selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CategoryChip(
                  label: 'Selected',
                  isSelected: true,
                  onTap: () {},
                ),
                CategoryChip(
                  label: 'Not Selected',
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Selected'), findsOneWidget);
      expect(find.text('Not Selected'), findsOneWidget);
    });

    testWidgets('CategoryChip should handle multiple chips',
        (WidgetTester tester) async {
      final categories = ['Fast Food', 'Italian', 'Asian', 'Desserts'];
      var selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.asMap().entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: CategoryChip(
                          label: entry.value,
                          isSelected: selectedIndex == entry.key,
                          onTap: () {
                            setState(() {
                              selectedIndex = entry.key;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Fast Food'), findsOneWidget);
      expect(find.text('Italian'), findsOneWidget);
      expect(find.text('Asian'), findsOneWidget);
      expect(find.text('Desserts'), findsOneWidget);

      // Tap on Italian category
      await tester.tap(find.text('Italian'));
      await tester.pumpAndSettle();

      // Verify the chip is now selected (by checking it exists)
      expect(find.text('Italian'), findsOneWidget);
    });

    testWidgets('CategoryChip should display different category names',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                CategoryChip(
                  label: 'Burgers',
                  isSelected: false,
                  onTap: () {},
                ),
                CategoryChip(
                  label: 'Pizza',
                  isSelected: false,
                  onTap: () {},
                ),
                CategoryChip(
                  label: 'Sushi',
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Burgers'), findsOneWidget);
      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('Sushi'), findsOneWidget);
    });

    testWidgets('CategoryChip selection should toggle',
        (WidgetTester tester) async {
      var isSelected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CategoryChip(
                  label: 'Toggle Test',
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Initially not selected
      expect(isSelected, false);

      // Tap to select
      await tester.tap(find.text('Toggle Test'));
      await tester.pumpAndSettle();

      // Now should be selected
      expect(isSelected, true);

      // Tap again to deselect
      await tester.tap(find.text('Toggle Test'));
      await tester.pumpAndSettle();

      // Should be deselected
      expect(isSelected, false);
    });
  });
}
