import 'package:flutter/material.dart';

/// A model class to define each item in the physics-based navigation bar.
/// این کلاس مدل برای تعریف هر آیتم در نوار ناوبری فیزیکی است.
/// It allows developers to define each button with a custom icon and label.
/// به توسعه‌دهندگان اجازه می‌دهد تا هر دکمه را با آیکون و برچسب دلخواه خود تعریف کنند.
@immutable
class PhysicsalNavItem {
  /// The primary icon for the item, displayed in its normal state.
  /// آیکون اصلی آیتم که در حالت عادی نمایش داده می‌شود.
  final IconData icon;

  /// The label or title for the item, displayed below the icon.
  /// برچسب یا عنوان آیتم که زیر آیکون نمایش داده می‌شود.
  final String label;

  /// [Optional] The icon for the item in its selected state.
  /// [اختیاری] آیکون آیتم در حالت انتخاب شده.
  /// If null, the primary `icon` will be used.
  /// اگر این مقدار null باشد، از همان `icon` اصلی استفاده خواهد شد.
  final IconData? activeIcon;

  /// The main constructor for creating a navigation bar item.
  /// سازنده اصلی برای ایجاد یک آیتم نوار ناوبری.
  const PhysicsalNavItem({
    required this.icon,
    required this.label,
    this.activeIcon,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhysicsalNavItem &&
          runtimeType == other.runtimeType &&
          icon == other.icon &&
          label == other.label &&
          activeIcon == other.activeIcon;

  @override
  int get hashCode => icon.hashCode ^ label.hashCode ^ activeIcon.hashCode;
}
