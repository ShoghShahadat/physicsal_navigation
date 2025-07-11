import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:physicsal_navigation/physicsal_navigation.dart';

// A simple test app wrapper to provide a Material context for our widget.
// یک اپلیکیشن تست ساده برای فراهم کردن محیط Material برای ویجت ما.
Widget createTestApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: const Center(child: Text("Test Body")),
      bottomNavigationBar: child,
    ),
  );
}

void main() {
  group('PhysicsalNavBar Tests', () {
    const testItems = [
      PhysicsalNavItem(icon: Icons.home, label: 'Home'),
      PhysicsalNavItem(icon: Icons.search, label: 'Search'),
      PhysicsalNavItem(icon: Icons.favorite, label: 'Likes'),
      PhysicsalNavItem(icon: Icons.person, label: 'Profile'),
    ];

    final fabGestureDetector = find.descendant(
      of: find.byType(PhysicsalFab),
      matching: find.byType(GestureDetector),
    );

    testWidgets('Renders correctly with initial properties',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(
        PhysicsalNavBar(
          items: testItems,
          onSelectionChanged: (index) {},
          onFabPressed: () {},
          onFabStop: (alignment) {},
        ),
      ));

      expect(find.byType(PhysicsalFab), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Likes'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('onSelectionChanged callback is fired when a tab is tapped',
        (WidgetTester tester) async {
      int? selectedIndex;

      await tester.pumpWidget(createTestApp(
        PhysicsalNavBar(
          items: testItems,
          onSelectionChanged: (index) {
            selectedIndex = index;
          },
          onFabPressed: () {},
          onFabStop: (alignment) {},
        ),
      ));

      await tester.tap(find.text('Search'));
      await tester.pump();

      expect(selectedIndex, 1);
    });

    testWidgets('onFabPressed callback is fired on tap',
        (WidgetTester tester) async {
      bool fabWasPressed = false;

      await tester.pumpWidget(createTestApp(
        PhysicsalNavBar(
          items: testItems,
          onSelectionChanged: (index) {},
          onFabPressed: () {
            fabWasPressed = true;
          },
          onFabStop: (alignment) {},
        ),
      ));

      await tester.tap(fabGestureDetector);
      await tester.pump();

      expect(fabWasPressed, isTrue);
    });

    // FIX: This test now uses a more robust waiting mechanism with fakeAsync.
    // اصلاح: این تست اکنون از یک مکانیزم انتظار قابل اعتمادتر با fakeAsync استفاده می‌کند.
    testWidgets('onFabStop callback is fired after dragging and settling',
        (WidgetTester tester) async {
      fakeAsync((async) {
        Alignment? finalAlignment;

        tester.pumpWidget(createTestApp(
          PhysicsalNavBar(
            items: testItems,
            onSelectionChanged: (index) {},
            onFabPressed: () {},
            onFabStop: (alignment) {
              finalAlignment = alignment;
            },
          ),
        ));
        async.flushMicrotasks();
        tester.pump();

        tester.drag(fabGestureDetector, const Offset(0, -200));
        async.flushMicrotasks();
        tester.pump();

        // Elapse time to let the physics simulation run.
        // زمان را جلو ببر تا شبیه‌سازی فیزیک اجرا شود.
        async.elapse(const Duration(seconds: 5));
        tester.pump();

        expect(finalAlignment, isNotNull);
      });
    });

    testWidgets('Custom FabStyle is applied correctly',
        (WidgetTester tester) async {
      const customStyle = FabStyle(
        icon: Icons.rocket_launch,
        gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
      );

      await tester.pumpWidget(createTestApp(
        PhysicsalNavBar(
          items: testItems,
          fabStyle: customStyle,
          onSelectionChanged: (index) {},
          onFabPressed: () {},
          onFabStop: (alignment) {},
        ),
      ));

      await tester.pump();

      expect(find.byIcon(Icons.rocket_launch), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('Custom PhysicsConfig (slingshot) is applied',
        (WidgetTester tester) async {
      fakeAsync((async) {
        Alignment? finalAlignment;

        tester.pumpWidget(createTestApp(
          PhysicsalNavBar(
            items: testItems,
            physicsConfig: PhysicsConfig.slingshot,
            onSelectionChanged: (index) {},
            onFabPressed: () {},
            onFabStop: (alignment) {
              finalAlignment = alignment;
            },
          ),
        ));
        async.flushMicrotasks();
        tester.pump();

        tester.drag(fabGestureDetector, const Offset(0, 100)); // Drag down
        async.elapse(const Duration(seconds: 5));
        tester.pump();

        expect(finalAlignment, isNotNull);
        expect(finalAlignment!.y < 0.8, isTrue);
      });
    });
  });
}
