import 'package:flutter/material.dart';

/// A model class to hold all visual appearance settings for the navigation bar.
/// یک کلاس مدل برای نگهداری تمام تنظیمات ظاهری نوار ناوبری.
/// This allows the developer to customize colors, gradients, blur, and item styles.
/// این کلاس به توسعه‌دهنده اجازه می‌دهد تا رنگ، گرادیانت، تاری و استایل آیتم‌ها را سفارشی کند.
@immutable
class BarStyle {
  /// The total height of the navigation bar.
  /// ارتفاع کلی نوار ناوبری.
  final double height;

  /// The background color of the bar. This is combined with `blurSigma` for a glass effect.
  /// رنگ پس‌زمینه نوار. این رنگ با `blurSigma` ترکیب می‌شود تا افکت شیشه‌ای ایجاد کند.
  final Color backgroundColor;

  /// The sigma for the backdrop blur effect (Glassmorphism).
  /// میزان تاری (Blur) پس‌زمینه برای ایجاد افکت شیشه‌ای (Glassmorphism).
  /// A value of 0.0 disables the effect.
  /// مقدار 0.0 این افکت را غیرفعال می‌کند.
  final double blurSigma;

  /// The style for navigation items in their normal (unselected) state.
  /// استایل آیتم‌های نوار ناوبری در حالت عادی (انتخاب نشده).
  final NavItemStyle itemStyle;

  /// The style for the navigation item in its selected state.
  /// استایل آیتم نوار ناوبری در حالت انتخاب شده.
  final NavItemStyle selectedItemStyle;

  /// Constructor for the navigation bar's style configuration.
  /// سازنده کلاس تنظیمات ظاهری نوار.
  const BarStyle({
    this.height = 80.0,
    this.backgroundColor = const Color.fromRGBO(40, 40, 40, 0.75),
    this.blurSigma = 15.0,
    this.itemStyle = const NavItemStyle(),
    this.selectedItemStyle = const NavItemStyle(fontWeight: FontWeight.bold),
  });
}

/// A model class to define the style of a navigation bar item (color, font, etc.).
/// یک کلاس مدل برای تعریف استایل یک آیتم در نوار ناوبری (مانند رنگ و فونت).
@immutable
class NavItemStyle {
  /// The color of the item's icon and text.
  /// رنگ آیکون و متن آیتم.
  final Color? color;

  /// A gradient for the item's icon and text color.
  /// گرادیانت برای رنگ آیکون و متن آیتم.
  /// If non-null, this overrides the `color` property.
  /// اگر این مقدار non-null باشد، `color` نادیده گرفته می‌شود.
  final Gradient? gradient;

  /// The font size of the item's label.
  /// اندازه فونت برچسب آیتم.
  final double? fontSize;

  /// The font weight of the item's label.
  /// وزن فونت برچسب آیتم.
  final FontWeight? fontWeight;

  /// Constructor for the item's style class.
  /// سازنده کلاس استایل آیتم.
  const NavItemStyle({
    this.color = Colors.white70,
    this.gradient,
    this.fontSize = 11.0,
    this.fontWeight = FontWeight.normal,
  });
}

/// A model class to hold all visual appearance settings for the Floating Action Button (FAB).
/// یک کلاس مدل برای نگهداری تمام تنظیمات ظاهری دکمه شناور (FAB).
@immutable
class FabStyle {
  /// The size (diameter) of the FAB.
  /// اندازه دکمه شناور.
  final double size;

  /// The icon displayed in the center of the FAB.
  /// آیکونی که در مرکز دکمه نمایش داده می‌شود.
  final IconData icon;

  /// The color of the icon.
  /// رنگ آیکون.
  final Color iconColor;

  /// The background gradient of the FAB.
  /// گرادیانت پس‌زمینه دکمه.
  final Gradient gradient;

  /// The color of the glow effect shown on impact or while aiming.
  /// رنگ درخشش (Glow) که در هنگام برخورد به لبه‌ها یا نشانه‌گیری نمایش داده می‌شود.
  final Color glowColor;

  /// Constructor for the FAB's style configuration.
  /// سازنده کلاس تنظیمات ظاهری FAB.
  const FabStyle({
    this.size = 56.0,
    this.icon = Icons.add,
    this.iconColor = Colors.white,
    this.gradient = const LinearGradient(
      colors: [Colors.teal, Colors.cyan],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.glowColor = Colors.tealAccent,
  });
}
