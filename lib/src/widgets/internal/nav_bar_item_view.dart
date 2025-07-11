import 'package:flutter/material.dart';
import '../../models/style_config.dart';

/// A private widget to render a single item in the navigation bar.
/// یک ویجت داخلی برای رندر کردن یک آیتم در نوار ناوبری.
/// It applies the styles defined in `NavItemStyle`.
/// این ویجت، استایل‌های تعریف شده در `NavItemStyle` را اعمال می‌کند.
class NavBarItemView extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final NavItemStyle style;
  final VoidCallback onTap;

  const NavBarItemView({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // The main content of the item (Icon and Text).
    // محتوای اصلی آیتم (آیکون و متن).
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedScale(
          duration: const Duration(milliseconds: 250),
          scale: isSelected ? 1.2 : 1.0,
          child: Icon(icon, size: 24),
        ),
        const SizedBox(height: 4),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: TextStyle(
            fontSize: style.fontSize,
            fontWeight: style.fontWeight,
            // Use the gradient's color if available, otherwise use the solid color.
            // از رنگ گرادیانت در صورت وجود استفاده کن، در غیر این صورت از رنگ ثابت.
            color: style.gradient == null ? style.color : Colors.white,
          ),
          child: Text(label),
        ),
      ],
    );

    // If a gradient is defined in the style, wrap the content in a ShaderMask.
    // اگر گرادیانتی در استایل تعریف شده باشد، محتوا را در یک ShaderMask قرار بده.
    if (style.gradient != null) {
      content = ShaderMask(
        shaderCallback: (bounds) => style.gradient!.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: content,
      );
    }

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: content,
      ),
    );
  }
}
