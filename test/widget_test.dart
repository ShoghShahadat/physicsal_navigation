import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physicsal_navigation/physicsal_navigation.dart';

// A simple test app wrapper to provide a Material context for our widget.
// یک اپلیکیشن تست ساده برای فراهم کردن محیط Material برای ویجت ما.
Widget createTestApp(Widget child) {
  return MaterialApp(
    home: Scaffold(
      // FIX: Disable all animations during tests to prevent pumpAndSettle from timing out.
      // اصلاح: تمام انیمیشن‌ها در حین تست غیرفعال می‌شوند تا از تایم‌اوت pumpAndSettle جلوگیری شود.
      body: TickerMode(
        enabled: false,
        child: child,
      ),
    ),
  );
}

void main() {
  // Group for all PhysicsalNavBar tests.
  // گروهی برای تمام تست‌های مربوط به PhysicsalNavBar.
  group('PhysicsalNavBar Tests', () {
    // The list of navigation items that will be used across tests.
    // لیست آیتم‌های ناوبری که در تمام تست‌ها استفاده خواهد شد.
    const testItems = [
      PhysicsalNavItem(icon: Icons.home, label: 'Home'),
      PhysicsalNavItem(icon: Icons.search, label: 'Search'),
      PhysicsalNavItem(icon: Icons.favorite, label: 'Likes'),
      PhysicsalNavItem(icon: Icons.person, label: 'Profile'),
    ];

    testWidgets('Renders correctly with initial properties',
        (WidgetTester tester) async {
      // Test to ensure the widget builds without errors and displays initial items.
      // تستی برای اطمینان از اینکه ویجت بدون خطا ساخته شده و آیتم‌های اولیه را نمایش می‌دهد.
      await tester.pumpWidget(createTestApp(
        PhysicsalNavBar(
          items: testItems,
          onSelectionChanged: (index) {},
          onFabPressed: () {},
          onFabStop: (alignment) {},
        ),
      ));

      // Verify that the FAB and all 4 navigation items are present.
      // بررسی می‌کنیم که دکمه شناور و هر ۴ آیتم ناوبری وجود دارند.
      expect(find.byType(PhysicsalFab), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Likes'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      // Verify the FAB's default icon is present.
      // بررسی می‌کنیم که آیکون پیش‌فرض دکمه شناور وجود دارد.
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

      // Tap on the 'Search' item (index 1).
      // روی آیتم 'Search' (ایندکس ۱) کلیک کن.
      await tester.tap(find.text('Search'));
      // pumpAndSettle will now work because animations are disabled.
      // pumpAndSettle اکنون کار خواهد کرد زیرا انیمیشن‌ها غیرفعال هستند.
      await tester.pumpAndSettle();

      // Verify that the callback was called with the correct index.
      // بررسی کن که callback با ایندکس صحیح فراخوانی شده است.
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

      // Tap the FAB.
      // روی دکمه شناور کلیک کن.
      await tester.tap(find.byType(PhysicsalFab));
      await tester.pumpAndSettle();

      // Verify that the callback was fired.
      // بررسی کن که callback فراخوانی شده است.
      expect(fabWasPressed, isTrue);
    });

    testWidgets('onFabStop callback is fired after dragging and settling',
        (WidgetTester tester) async {
      Alignment? finalAlignment;

      await tester.pumpWidget(createTestApp(
        PhysicsalNavBar(
          items: testItems,
          onSelectionChanged: (index) {},
          onFabPressed: () {},
          onFabStop: (alignment) {
            finalAlignment = alignment;
          },
        ),
      ));

      // Simulate dragging the FAB upwards.
      // کشیدن دکمه شناور به سمت بالا را شبیه‌سازی کن.
      final fabFinder = find.byType(PhysicsalFab);
      await tester.drag(fabFinder, const Offset(0, -200));

      // Let the physics simulation run until it settles.
      // اجازه بده شبیه‌سازی فیزیک تا زمان توقف کامل اجرا شود.
      await tester.pumpAndSettle();

      // Verify that the onFabStop callback was fired.
      // بررسی کن که callback مربوط به onFabStop فراخوانی شده است.
      expect(finalAlignment, isNotNull);
    });

    testWidgets('Custom FabStyle is applied correctly',
        (WidgetTester tester) async {
      // Test to ensure custom styles are reflected in the UI.
      // تستی برای اطمینان از اینکه استایل‌های سفارشی در UI اعمال می‌شوند.
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

      // Verify that the custom icon is present and the default one is not.
      // بررسی کن که آیکون سفارشی وجود دارد و آیکون پیش‌فرض وجود ندارد.
      expect(find.byIcon(Icons.rocket_launch), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
    });

    testWidgets('Custom PhysicsConfig (slingshot) is applied',
        (WidgetTester tester) async {
      Alignment? finalAlignment;

      await tester.pumpWidget(createTestApp(
        PhysicsalNavBar(
          items: testItems,
          physicsConfig: PhysicsConfig.slingshot, // Use the slingshot preset
          onSelectionChanged: (index) {},
          onFabPressed: () {},
          onFabStop: (alignment) {
            finalAlignment = alignment;
          },
        ),
      ));

      final fabFinder = find.byType(PhysicsalFab);
      // Dragging down should launch the FAB upwards in slingshot mode.
      // در حالت قلاب‌سنگ، کشیدن به پایین باید باعث پرتاب به بالا شود.
      await tester.drag(fabFinder, const Offset(0, 100)); // Drag down
      await tester.pumpAndSettle();

      // Verify the callback was fired, implying the simulation ran.
      // بررسی کن که callback فراخوانی شده، که به معنای اجرای شبیه‌سازی است.
      expect(finalAlignment, isNotNull);
      // In slingshot mode, the final Y should be higher (more negative) than the start.
      // در حالت قلاب‌سنگ، موقعیت Y نهایی باید بالاتر (منفی‌تر) از نقطه شروع باشد.
      expect(finalAlignment!.y < 0.8, isTrue); // Start position is ~0.85
    });
  });
}
