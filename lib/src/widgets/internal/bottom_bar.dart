import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/nav_item.dart';
import '../../models/style_config.dart';
import 'nav_bar_item_view.dart';

/// A private widget representing the visual glassmorphic bottom bar.
/// یک ویجت داخلی که نوار ناوبری شیشه‌ای و زیبا را نمایش می‌دهد.
/// It arranges the navigation items and handles the FAB gap.
/// این ویجت، آیتم‌های ناوبری را چیده و فضای خالی برای دکمه شناور را مدیریت می‌کند.
class BottomBar extends StatelessWidget {
  final List<PhysicsalNavItem> items;
  final BarStyle style;
  final int currentIndex;
  final ValueChanged<int> onTabTapped;
  final bool showFabGap;

  const BottomBar({
    super.key,
    required this.items,
    required this.style,
    required this.currentIndex,
    required this.onTabTapped,
    required this.showFabGap,
  }) : assert(
         items.length == 4,
         "This bar currently supports exactly 4 items.",
       );

  @override
  Widget build(BuildContext context) {
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      height: style.height + safeAreaBottom,
      margin: const EdgeInsets.all(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: style.blurSigma,
            sigmaY: style.blurSigma,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: style.backgroundColor,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withAlpha(40)),
            ),
            child: Padding(
              padding: EdgeInsets.only(bottom: safeAreaBottom),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildNavItems(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the list of navigation items and the animated gap for the FAB.
  /// لیست آیتم‌های ناوبری و فضای خالی متحرک برای دکمه شناور را می‌سازد.
  List<Widget> _buildNavItems() {
    final List<Widget> navItems = [];
    for (int i = 0; i < items.length; i++) {
      final item = items[i];
      final isSelected = i == currentIndex;

      navItems.add(
        NavBarItemView(
          icon: isSelected ? (item.activeIcon ?? item.icon) : item.icon,
          label: item.label,
          isSelected: isSelected,
          style: isSelected ? style.selectedItemStyle : style.itemStyle,
          onTap: () => onTabTapped(i),
        ),
      );

      // Add the animated gap after the second item.
      // فضای خالی را بعد از آیتم دوم اضافه کن.
      if (i == 1) {
        navItems.add(
          AnimatedContainer(
            duration: showFabGap
                ? const Duration(milliseconds: 800)
                : const Duration(milliseconds: 250),
            curve: showFabGap ? Curves.elasticOut : Curves.easeOut,
            width: showFabGap ? 60 : 0,
          ),
        );
      }
    }
    return navItems;
  }
}
