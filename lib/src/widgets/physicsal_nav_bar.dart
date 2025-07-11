import 'package:flutter/material.dart';
import '../models/nav_item.dart';
import '../models/physics_config.dart';
import '../models/style_config.dart';
import 'internal/bottom_bar.dart';
import 'physicsal_fab.dart';

/// The main widget of the package, combining a physics-based FAB and a customizable bottom navigation bar.
/// ویجت اصلی پکیج، ترکیبی از یک دکمه شناور فیزیکی و یک نوار ناوبری پایین قابل سفارشی‌سازی.
class PhysicsalNavBar extends StatefulWidget {
  /// The list of navigation items to display. Must contain exactly 4 items.
  /// لیست آیتم‌های ناوبری برای نمایش. باید دقیقاً شامل ۴ آیتم باشد.
  final List<PhysicsalNavItem> items;

  /// The initial selected index of the navigation bar.
  /// ایندکس آیتم انتخاب شده اولیه در نوار ناوبری.
  final int initialIndex;

  /// Callback function when a new navigation item is selected.
  /// تابعی که هنگام انتخاب یک آیتم جدید فراخوانی می‌شود.
  final ValueChanged<int> onSelectionChanged;

  /// Callback function when the FAB is tapped.
  /// تابعی که هنگام کلیک روی دکمه شناور فراخوانی می‌شود.
  final VoidCallback onFabPressed;

  /// Callback function when the FAB stops after being launched.
  /// تابعی که پس از پرتاب شدن و توقف کامل دکمه شناور فراخوانی می‌شود.
  final ValueChanged<Alignment> onFabStop;

  /// [Optional] Style configuration for the bottom bar.
  /// [اختیاری] تنظیمات ظاهری برای نوار پایین.
  final BarStyle barStyle;

  /// [Optional] Style configuration for the FAB.
  /// [اختیاری] تنظیمات ظاهری برای دکمه شناور.
  final FabStyle fabStyle;

  /// [Optional] Physics configuration for the FAB.
  /// [اختیاری] تنظیمات فیزیکی برای دکمه شناور.
  final PhysicsConfig physicsConfig;

  const PhysicsalNavBar({
    super.key,
    required this.items,
    required this.onSelectionChanged,
    required this.onFabPressed,
    required this.onFabStop,
    this.initialIndex = 0,
    this.barStyle = const BarStyle(),
    this.fabStyle = const FabStyle(),
    this.physicsConfig = const PhysicsConfig(),
  }) : assert(items.length == 4,
            "PhysicsalNavBar currently supports exactly 4 items.");

  @override
  State<PhysicsalNavBar> createState() => _PhysicsalNavBarState();
}

class _PhysicsalNavBarState extends State<PhysicsalNavBar> {
  late int _currentIndex;
  bool _showFabGap = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _handleTabTapped(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
    widget.onSelectionChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    // By placing the BottomBar first in the Stack, we ensure it's drawn behind the FAB.
    // با قرار دادن BottomBar در ابتدای Stack، اطمینان حاصل می‌کنیم که پشت دکمه شناور کشیده می‌شود.
    return Stack(
      children: [
        // The bottom bar is aligned to the bottom. It will be the background layer.
        // نوار پایین در انتهای صفحه قرار می‌گیرد و لایه پس‌زمینه خواهد بود.
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomBar(
            items: widget.items,
            style: widget.barStyle,
            currentIndex: _currentIndex,
            onTabTapped: _handleTabTapped,
            showFabGap: _showFabGap,
          ),
        ),
        // The FAB is drawn on top of the bar, allowing it to move freely over it.
        // دکمه شناور روی نوار کشیده می‌شود و به آن اجازه می‌دهد آزادانه روی آن حرکت کند.
        PhysicsalFab(
          style: widget.fabStyle,
          physicsConfig: widget.physicsConfig,
          onPressed: widget.onFabPressed,
          onStop: widget.onFabStop,
          onLaunch: () => setState(() => _showFabGap = false),
          onReturnStart: () => setState(() => _showFabGap = true),
        ),
      ],
    );
  }
}
