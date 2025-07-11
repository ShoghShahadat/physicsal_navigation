import 'package:flutter/material.dart';

/// Defines the types of idle animations available for the FAB.
/// انواع انیمیشن‌های حالت آماده (idle) برای دکمه شناور را تعریف می‌کند.
enum FabAnimationType {
  rotation,
  pulse,
  blink,
  floatVertical,
  floatHorizontal,
}

@immutable
class BarStyle {
  final double height;
  final Color backgroundColor;
  final double blurSigma;
  final NavItemStyle itemStyle;
  final NavItemStyle selectedItemStyle;

  const BarStyle({
    this.height = 80.0,
    this.backgroundColor = const Color.fromRGBO(40, 40, 40, 0.75),
    this.blurSigma = 15.0,
    this.itemStyle = const NavItemStyle(),
    this.selectedItemStyle = const NavItemStyle(fontWeight: FontWeight.bold),
  });
}

@immutable
class NavItemStyle {
  final Color? color;
  final Gradient? gradient;
  final double? fontSize;
  final FontWeight? fontWeight;

  const NavItemStyle({
    this.color = Colors.white70,
    this.gradient,
    this.fontSize = 11.0,
    this.fontWeight = FontWeight.normal,
  });
}

/// A model class to hold all visual appearance and animation settings for the FAB.
/// یک کلاس مدل برای نگهداری تمام تنظیمات ظاهری و انیمیشنی دکمه شناور.
@immutable
class FabStyle {
  final double size;
  final IconData icon;
  final Color iconColor;
  final Gradient gradient;

  // REMOVED: glowColor is now derived directly from the gradient.
  // حذف شد: رنگ درخشش اکنون مستقیماً از گرادیانت گرفته می‌شود.
  // final Color glowColor;

  final List<FabAnimationType> activeAnimations;
  final Duration animationPeriod;

  const FabStyle({
    this.size = 56.0,
    this.icon = Icons.add,
    this.iconColor = Colors.white,
    this.gradient = const LinearGradient(
      colors: [Colors.cyan, Colors.teal],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    // this.glowColor = Colors.tealAccent, // REMOVED
    this.activeAnimations = const [FabAnimationType.rotation],
    this.animationPeriod = const Duration(seconds: 4),
  });
}
