/// A beautiful, customizable, and physics-based navigation bar for Flutter.
/// یک نوار ناوبری زیبا، قابل سفارشی‌سازی و مبتنی بر فیزیک برای فلاتر.
library physicsal_navigation;

// Export the main widget so it can be used by other developers.
// ویجت اصلی را اکسپورت کن تا توسط دیگر توسعه‌دهندگان قابل استفاده باشد.
export 'src/widgets/physicsal_nav_bar.dart';

// --- START OF FIX / شروع اصلاح ---
// Export the PhysicsalFab widget to make it accessible for testing purposes.
// ویجت PhysicsalFab را برای اهداف تست، قابل دسترس کن.
export 'src/widgets/physicsal_fab.dart';
// --- END OF FIX / پایان اصلاح ---

// Export all the model classes for full customization.
// تمام کلاس‌های مدل را برای سفارشی‌سازی کامل اکسپورت کن.
export 'src/models/nav_item.dart';
export 'src/models/style_config.dart';
export 'src/models/physics_config.dart';
