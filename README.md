# Physicsal Navigation: جایی که UI با فیزیک ملاقات می‌کند
### یک نوار ناوبری که زندگی می‌کند

[![pub version](https://img.shields.io/pub/v/physicsal_navigation.svg)](https://pub.dev/packages/physicsal_navigation)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)

**English:** Physicsal Navigation is not just another bottom navigation bar. It's a fully interactive, physics-driven UI component designed to bring life, personality, and a touch of magic to your Flutter applications. It features a throwable Floating Action Button (FAB) that bounces off screen edges and a stunning, fully customizable glassmorphic bar.

**فارسی:** پکیج `Physicsal Navigation` یک نوار ناوبری معمولی نیست. این یک کامپوننت رابط کاربری کاملاً تعاملی و مبتنی بر فیزیک است که برای بخشیدن زندگی، شخصیت و اندکی جادو به اپلیکیشن‌های فلاتر شما طراحی شده است. ویژگی اصلی آن، یک دکمه شناور قابل پرتاب است که به لبه‌های صفحه برخورد می‌کند و یک نوار پایین شیشه‌ای خیره‌کننده آن را همراهی می‌کند.

---

### 🎬 دموها در عمل

<div align="center">

| پرتاب قلاب‌سنگی (Slingshot) | پرتاب مستقیم (Direct Throw) |
| :---: | :---: |
| ![نمایش پرتاب قلاب‌سنگی](https://raw.githubusercontent.com/ShoghShahadat/physicsal_navigation/main/gif/1.gif) | ![نمایش پرتاب مستقیم](https://raw.githubusercontent.com/ShoghShahadat/physicsal_navigation/main/gif/2.gif) |
| **افکت برخورد انفجاری** | **سفارشی‌سازی کامل استایل** |
| ![نمایش افکت برخورد](https://raw.githubusercontent.com/ShoghShahadat/physicsal_navigation/main/gif/3.gif) | ![نمایش سفارشی‌سازی](https://raw.githubusercontent.com/ShoghShahadat/physicsal_navigation/main/gif/4.gif) |

</div>

## ✨ فلسفه و ویژگی‌های کلیدی

> هدف ما فرار از عناصر ثابت و خسته‌کننده رابط کاربری بود. چرا یک دکمه فقط باید یک دکمه باشد؟ چرا نمی‌تواند وزن، سرعت و شخصیت داشته باشد؟

* **موتور فیزیک واقعی (Real Physics Engine):**
    * دکمه شناور فقط انیمیشن ندارد؛ بلکه شبیه‌سازی می‌شود. دارای خصوصیاتی مانند `damping` (جهندگی)، `friction` (اصطکاک) و `velocity` (سرعت) است. آن را پرتاب کنید و ببینید چگونه مانند یک شی واقعی رفتار می‌کند.
    * The FAB isn't just animated; it's simulated. It has properties like `damping` (bounciness), `friction`, and `velocity`. Throw it around and watch it behave like a real object.

* **سفارشی‌سازی عمیق (Deep Customization):**
    * **ظاهر:** همه چیز را کنترل کنید؛ از آیکون و گرادیانت FAB گرفته تا رنگ پس‌زمینه نوار ناوبری، شدت تاری و استایل آیتم‌ها.
    * **رفتار:** فیزیک را دوست ندارید؟ تغییرش دهید! از حالت‌های آماده ما استفاده کنید یا تمام پارامترها را برای خلق رفتار دلخواه خود تنظیم کنید.
    * **Appearance:** Control everything from the FAB's icon and gradient to the navigation bar's background color, blur intensity, and item styles.
    * **Behavior:** Don't like the physics? Change them! Use our pre-configured presets or fine-tune every parameter to create the exact behavior you want.

* **تعاملی و جذاب (Interactive & Fun):**
    * `Callback` مربوط به `onFabStop`، موقعیت نهایی دکمه را در اختیار شما قرار می‌دهد و به شما اجازه می‌دهد تا اهداف تعاملی ایجاد کرده یا بر اساس محل فرود دکمه، رویدادهایی را فعال کنید. یک تجربه واقعاً بازی‌گونه.
    * The `onFabStop` callback provides the final `Alignment` of the FAB, allowing you to create interactive targets or trigger events based on where it lands. A truly gamified experience.

* **افکت شیشه‌ای خیره‌کننده (Stunning Glassmorphism):**
    * نوار پایین از `BackdropFilter` برای ایجاد یک افکت زیبا، مدرن و شیشه‌ای استفاده می‌کند که به اپلیکیشن شما عمق و ظرافت می‌بخشد.
    * The bottom bar uses a `BackdropFilter` to create a beautiful, modern, glass-like effect that adds depth and elegance to your app.

## 🚀 نصب (Installation)

این خط را به فایل `pubspec.yaml` پروژه خود اضافه کنید:
Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  physicsal_navigation: ^1.0.0
```

سپس، پکیج‌ها را از خط فرمان نصب کنید:
Then, install packages from the command line:

```shell
flutter pub get
```

## 💻 راهنمای استفاده (Usage Guide)

### راه‌اندازی اولیه (Basic Setup)

پکیج را ایمپورت کرده و از `PhysicsalNavBar` در `Scaffold` خود استفاده کنید.
Import the package and use `PhysicsalNavBar` in your `Scaffold`.

```dart
import 'package:flutter/material.dart';
import 'package:physicsal_navigation/physicsal_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Physicsal Navigation Demo',
      theme: ThemeData.dark(),
      home: const DemoScreen(),
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  int _currentIndex = 0;
  String _fabStopMessage = "Throw the FAB to see where it lands!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Physicsal Navigation Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selected Page: $_currentIndex',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text(_fabStopMessage),
          ],
        )
      ),
      // از PhysicsalNavBar به عنوان ویجت برای پراپرتی bottomNavigationBar استفاده کنید.
      // Use the PhysicsalNavBar as the widget for the bottomNavigationBar property.
      bottomNavigationBar: PhysicsalNavBar(
        items: const [
          PhysicsalNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
          PhysicsalNavItem(icon: Icons.search, label: 'Search'),
          PhysicsalNavItem(icon: Icons.favorite_border, activeIcon: Icons.favorite, label: 'Likes'),
          PhysicsalNavItem(icon: Icons.person_outline, activeIcon: Icons.person, label: 'Profile'),
        ],
        onSelectionChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onFabPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('FAB Pressed!')),
          );
        },
        onFabStop: (alignment) {
          setState(() {
            _fabStopMessage = 'FAB stopped at:\nAlignment(x: ${alignment.x.toStringAsFixed(2)}, y: ${alignment.y.toStringAsFixed(2)})';
          });
        },
      ),
    );
  }
}
```

### سفارشی‌سازی پیشرفته (Advanced Customization)

با ارائه تنظیمات استایل و فیزیک سفارشی، قدرت کامل پکیج را آزاد کنید.
Unleash the full power by providing custom style and physics configurations.

```dart
PhysicsalNavBar(
  // ... سایر پراپرتی‌های مورد نیاز
  
  // ۱. سفارشی‌سازی استایل نوار
  // 1. Customize the Bar Style
  barStyle: BarStyle(
    backgroundColor: const Color.fromRGBO(20, 20, 20, 0.8),
    blurSigma: 20.0,
    itemStyle: const NavItemStyle(color: Colors.grey),
    selectedItemStyle: NavItemStyle(
      gradient: const LinearGradient(colors: [Colors.amber, Colors.orange]),
      fontWeight: FontWeight.bold,
    ),
  ),
  
  // ۲. سفارشی‌سازی استایل دکمه شناور
  // 2. Customize the FAB Style
  fabStyle: const FabStyle(
    icon: Icons.rocket_launch,
    gradient: LinearGradient(colors: [Color(0xff6A11CB), Color(0xff2575FC)]),
    glowColor: Colors.blueAccent,
  ),
  
  // ۳. از یک حالت فیزیک آماده استفاده کنید یا خودتان بسازید
  // 3. Use a pre-built Physics Preset or create your own
  physicsConfig: const PhysicsConfig(
    launchType: FabLaunchType.slingshot, // حسی شبیه قلاب‌سنگ
    returnType: FabReturnType.elastic, // بازگشت فنری
    collisionEffect: FabCollisionEffect.explosiveGlow, // درخشش زیاد هنگام برخورد
    damping: 0.6, // کمی جهندگی کمتر
  ),
)
```

## ⚙️ مرجع API (API Reference)

### `PhysicsalNavBar`
ویجت اصلی که همه چیز را در کنار هم نگه می‌دارد.

| Parameter | Type | Description (توضیحات) |
| :--- | :--- | :--- |
| `items` | `List<PhysicsalNavItem>` | (الزامی) ۴ آیتم برای نوار ناوبری. (Required) The 4 items for the nav bar. |
| `onSelectionChanged` | `ValueChanged<int>` | (الزامی) هنگام انتخاب یک تب فراخوانی می‌شود. (Required) Called when a tab is selected. |
| `onFabPressed` | `VoidCallback` | (الزامی) هنگام کلیک روی دکمه شناور فراخوانی می‌شود. (Required) Called when the FAB is tapped. |
| `onFabStop` | `ValueChanged<Alignment>` | (الزامی) پس از توقف دکمه شناور فراخوانی می‌شود. (Required) Called when the FAB stops moving. |
| `initialIndex` | `int` | ایندکس آیتم انتخاب شده اولیه. The starting selected index. |
| `barStyle` | `BarStyle` | ظاهر نوار پایین را سفارشی می‌کند. Customizes the bottom bar's appearance. |
| `fabStyle` | `FabStyle` | ظاهر دکمه شناور را سفارشی می‌کند. Customizes the FAB's appearance. |
| `physicsConfig` | `PhysicsConfig` | فیزیک دکمه شناور را سفارشی می‌کند. Customizes the FAB's physics. |

---

### `PhysicsConfig`
رفتار فیزیکی دکمه شناور را پیکربندی کنید.

| Parameter | Type | Options & Description (گزینه‌ها و توضیحات) |
| :--- | :--- | :--- |
| `launchType` | `FabLaunchType` | **`slingshot`**: کشیدن و رها کردن. (Pull and release.)<br>**`directThrow`**: پرتاب با حرکت دست. (Flick to throw.) |
| `returnType` | `FabReturnType` | **`elastic`**: بازگشت فنری. (Bouncy return.)<br>**`smooth`**: بازگشت نرم با انیمیشن. (Animates back smoothly.)<br>**`teleport`**: بازگشت آنی. (Instantly snaps back.) |
| `collisionEffect` | `FabCollisionEffect` | **`bounceAndGlow`**: جهش و درخشش پیش‌فرض. (Default bounce and glow.)<br>**`stickToWall`**: چسبیدن به دیواره. (Stops at the edge.)<br>**`explosiveGlow`**: درخشش انفجاری هنگام برخورد. (Larger glow on impact.) |
| `damping` | `double` | ضریب جهندگی (0.0 - 1.0). Bounciness factor. |
| `friction` | `double` | ضریب اصطکاک (0.0 - 1.0). How quickly it slows down. |
| `...` | `...` | و پارامترهای بیشتر برای تنظیمات دقیق! And more for fine-tuning! |

#### حالت‌های فیزیک آماده (Physics Presets)
* `PhysicsConfig.standard`: یک پیش‌فرض عالی و متعادل. (A great, well-behaved default.)
* `PhysicsConfig.chaotic`: جهنده‌تر و غیرقابل پیش‌بینی. (More bouncy and unpredictable.)
* `PhysicsConfig.heavy`: حسی شبیه حرکت در آب. (Feels like moving through water.)
* `PhysicsConfig.slingshot`: یک مکانیک قلاب‌سنگ کلاسیک. (A classic slingshot mechanic.)

## 💖 مشارکت (Contributing)

از مشارکت شما استقبال می‌شود! لطفاً با خیال راحت یک Pull Request ارسال کنید.
Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 مجوز (License)

این پروژه تحت مجوز MIT منتشر شده است. برای جزئیات بیشتر به فایل `LICENSE` مراجعه کنید.
This project is licensed under the MIT License - see the `LICENSE` file for details.
