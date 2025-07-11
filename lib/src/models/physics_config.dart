import 'package:flutter/material.dart';

// --- Enums for Pre-defined Behaviors ---
// --- اینام‌ها برای رفتارهای از پیش تعریف شده ---

/// Defines the launch mechanic of the FAB.
/// مکانیک پرتاب دکمه شناور را تعریف می‌کند.
enum FabLaunchType {
  /// User pulls back and releases, like a slingshot. Velocity is opposite to the drag direction.
  /// کاربر دکمه را به عقب کشیده و رها می‌کند، مانند قلاب‌سنگ. سرعت در جهت مخالف کشیدگی خواهد بود.
  slingshot,

  /// User "throws" the FAB. Velocity is in the same direction as the drag gesture.
  /// کاربر دکمه را "پرتاب" می‌کند. سرعت در همان جهت حرکت دست خواهد بود.
  directThrow,
}

/// Defines how the FAB returns to its home position.
/// نحوه بازگشت دکمه شناور به جایگاه اصلی خود را تعریف می‌کند.
enum FabReturnType {
  /// Returns with a bouncy, elastic animation.
  /// با یک انیمیشن فنری و ارتجاعی بازمی‌گردد.
  elastic,

  /// Smoothly animates back to the center without any bounce.
  /// به نرمی و بدون هیچ حالت فنری به مرکز بازمی‌گردد.
  smooth,

  /// Instantly teleports back to its home position.
  /// فوراً به جایگاه اصلی خود تلپورت می‌کند.
  teleport,
}

/// Defines the visual and physical effect upon collision with a screen edge.
/// افکت بصری و فیزیکی هنگام برخورد با لبه‌های صفحه را تعریف می‌کند.
enum FabCollisionEffect {
  /// Bounces off the wall with a glow effect.
  /// با یک افکت درخشش به دیواره برخورد کرده و بازمی‌گردد.
  bounceAndGlow,

  /// Stops dead at the wall.
  /// در هنگام برخورد با دیواره متوقف می‌شود.
  stickToWall,

  /// Bounces and creates a larger, more dramatic "explosion" glow.
  /// برخورد کرده و یک درخشش بزرگ و "انفجاری" ایجاد می‌کند.
  explosiveGlow,
}

/// A model class to hold all physics parameters governing the FAB.
/// یک کلاس مدل برای نگهداری تمام پارامترهای فیزیکی حاکم بر دکمه شناور.
/// This version includes enums for preset behaviors and more detailed customization.
/// این نسخه شامل اینام‌ها برای رفتارهای آماده و سفارشی‌سازی‌های جزئی‌تر است.
@immutable
class PhysicsConfig {
  // --- Preset Behaviors ---
  /// The launch mechanic for the FAB.
  /// مکانیک پرتاب دکمه.
  final FabLaunchType launchType;

  /// The return animation style.
  /// استایل انیمیشن بازگشت.
  final FabReturnType returnType;

  /// The effect on wall collision.
  /// افکت هنگام برخورد با دیواره.
  final FabCollisionEffect collisionEffect;

  // --- Fine-Tuned Customization ---
  /// Damping factor (0.0 to 1.0). Controls bounciness on collision.
  /// ضریب میرایی (0.0 تا 1.0). میزان جهش پس از برخورد را کنترل می‌کند.
  final double damping;

  /// Friction factor (0.0 to 1.0). Controls how quickly the FAB slows down.
  /// ضریب اصطکاک (0.0 تا 1.0). سرعت کاهش سرعت دکمه را کنترل می‌کند.
  final double friction;

  /// Launch power multiplier. A higher value results in a more powerful throw.
  /// ضریب قدرت پرتاب. مقادیر بالاتر منجر به پرتاب قوی‌تر می‌شود.
  final double launchPowerMultiplier;

  /// If true, the FAB's velocity direction will be partially inverted on collision, creating a more realistic bounce.
  /// اگر فعال باشد، جهت سرعت دکمه پس از برخورد تا حدی معکوس شده و یک بازگشت واقعی‌تر ایجاد می‌کند.
  final bool invertDirectionOnCollision;

  /// The duration of the return animation (only for `smooth` and `elastic` types).
  /// مدت زمان انیمیشن بازگشت (فقط برای حالت‌های `smooth` و `elastic`).
  final Duration returnAnimationDuration;

  /// Constructor for creating a custom physics configuration.
  /// سازنده برای ایجاد یک تنظیمات فیزیک سفارشی.
  const PhysicsConfig({
    this.launchType = FabLaunchType.directThrow,
    this.returnType = FabReturnType.elastic,
    this.collisionEffect = FabCollisionEffect.bounceAndGlow,
    this.damping = 0.7,
    this.friction = 0.05,
    this.launchPowerMultiplier = 0.35,
    this.invertDirectionOnCollision = true,
    this.returnAnimationDuration = const Duration(milliseconds: 800),
  }) : assert(damping >= 0.0 && damping <= 1.0),
       assert(friction >= 0.0 && friction <= 1.0);

  // --- Pre-defined Static Presets ---
  // --- حالت‌های آماده و استاتیک ---

  /// Standard, well-behaved physics. A great default.
  /// فیزیک استاندارد و متعادل. یک گزینه عالی به عنوان پیش‌فرض.
  static const PhysicsConfig standard = PhysicsConfig();

  /// A more chaotic and bouncy configuration. Fun and unpredictable.
  /// یک تنظیمات آشوبناک و فنری‌تر. جذاب و غیرقابل پیش‌بینی.
  static const PhysicsConfig chaotic = PhysicsConfig(
    damping: 0.85,
    friction: 0.02,
    launchPowerMultiplier: 0.45,
    collisionEffect: FabCollisionEffect.explosiveGlow,
  );

  /// A heavy, low-energy configuration. Feels like moving through water.
  /// یک تنظیمات سنگین و کم‌انرژی. حسی شبیه به حرکت در آب دارد.
  static const PhysicsConfig heavy = PhysicsConfig(
    damping: 0.4,
    friction: 0.1,
    launchPowerMultiplier: 0.25,
    returnType: FabReturnType.smooth,
  );

  /// A classic slingshot mechanic with a quick, smooth return.
  /// یک مکانیک قلاب‌سنگ کلاسیک با بازگشتی سریع و نرم.
  static const PhysicsConfig slingshot = PhysicsConfig(
    launchType: FabLaunchType.slingshot,
    returnType: FabReturnType.smooth,
    returnAnimationDuration: Duration(milliseconds: 400),
  );
}
