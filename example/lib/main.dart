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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101010),
        primaryColor: Colors.cyan,
        colorScheme: const ColorScheme.dark().copyWith(
          primary: Colors.cyan,
          secondary: Colors.cyanAccent,
        ),
        cardColor: const Color(0xFF1A1A1A),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE0E0E0)),
          headlineSmall: TextStyle(color: Colors.white),
          titleMedium:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          labelSmall: TextStyle(color: Colors.white70),
        ),
        // FIX: Updated deprecated MaterialStateProperty and MaterialState to WidgetStateProperty and WidgetState.
        // اصلاح: جایگزینی API های منسوخ شده.
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  // FIX: Updated deprecated withOpacity to withAlpha for better precision.
                  // اصلاح: جایگزینی متد منسوخ شده withOpacity با withAlpha برای دقت بیشتر.
                  return Colors.cyan.withAlpha((255 * 0.3).round());
                }
                return Colors.grey.shade800;
              },
            ),
            foregroundColor: WidgetStateProperty.all(Colors.white),
          ),
        ),
      ),
      home: const DemoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  // FIX: Removed unused _currentNavBarIndex variable.
  // اصلاح: متغیر بلااستفاده _currentNavBarIndex حذف شد.
  String _fabStopMessage = "Throw the FAB to see where it lands!";
  Color _collidedTargetColor = Colors.grey.shade800;
  bool _isPanelVisible = true;

  FabStyle _fabStyle = const FabStyle();
  PhysicsConfig _physicsConfig = const PhysicsConfig();

  final Map<String, Alignment> _targets = {
    "Top-Left": const Alignment(-0.8, -0.8),
    "Top-Right": const Alignment(0.8, -0.8),
  };

  void _onFabStop(Alignment alignment) {
    String message =
        'FAB stopped at:\nAlignment(x: ${alignment.x.toStringAsFixed(2)}, y: ${alignment.y.toStringAsFixed(2)})';
    Color newColor = Colors.grey.shade800;

    for (var entry in _targets.entries) {
      final targetAlignment = entry.value;
      final distance = (Offset(alignment.x, alignment.y) -
              Offset(targetAlignment.x, targetAlignment.y))
          .distance;
      if (distance < 0.3) {
        message = 'Collision with "${entry.key}" target!';
        newColor = Colors.green.shade700;
        break;
      }
    }

    setState(() {
      _fabStopMessage = message;
      _collidedTargetColor = newColor;
    });
  }

  void _onConfigChanged({FabStyle? fabStyle, PhysicsConfig? physicsConfig}) {
    setState(() {
      _fabStyle = fabStyle ?? _fabStyle;
      _physicsConfig = physicsConfig ?? _physicsConfig;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text("Physicsal Playground"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_suggest),
            tooltip: 'Toggle Controls',
            onPressed: () {
              setState(() {
                _isPanelVisible = !_isPanelVisible;
              });
            },
          )
        ],
      ),
      body: Stack(
        children: [
          ..._targets.entries.map((entry) {
            return Align(
              alignment: entry.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _collidedTargetColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade700, width: 2),
                ),
                child: Center(
                    child: Text(entry.key,
                        style: const TextStyle(color: Colors.white))),
              ),
            );
          }),
          Align(
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: _isPanelVisible
                  ? _ConfigurationPanel(
                      key: const ValueKey('panel'),
                      initialFabStyle: _fabStyle,
                      initialPhysicsConfig: _physicsConfig,
                      onConfigChanged: _onConfigChanged,
                    )
                  : const SizedBox(key: ValueKey('empty')),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 300.0),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  _fabStopMessage,
                  key: ValueKey(_fabStopMessage),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PhysicsalNavBar(
        key: ValueKey(_physicsConfig.hashCode + _fabStyle.hashCode),
        items: const [
          PhysicsalNavItem(
              icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
          PhysicsalNavItem(icon: Icons.search, label: 'Search'),
          PhysicsalNavItem(
              icon: Icons.favorite_border,
              activeIcon: Icons.favorite,
              label: 'Likes'),
          PhysicsalNavItem(
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profile'),
        ],
        fabStyle: _fabStyle,
        physicsConfig: _physicsConfig,
        onSelectionChanged: (index) {
          // The state is now only used for potential future logic, not for UI updates.
          // وضعیت اکنون فقط برای منطق آینده استفاده می‌شود، نه برای به‌روزرسانی UI.
        },
        onFabPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('FAB Tapped! (onFabPressed called)'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onFabStop: _onFabStop,
      ),
    );
  }
}

class _ConfigurationPanel extends StatefulWidget {
  final FabStyle initialFabStyle;
  final PhysicsConfig initialPhysicsConfig;
  final Function({FabStyle? fabStyle, PhysicsConfig? physicsConfig})
      onConfigChanged;

  const _ConfigurationPanel({
    super.key,
    required this.initialFabStyle,
    required this.initialPhysicsConfig,
    required this.onConfigChanged,
  });

  @override
  State<_ConfigurationPanel> createState() => _ConfigurationPanelState();
}

class _ConfigurationPanelState extends State<_ConfigurationPanel> {
  late FabStyle _currentFabStyle;
  late PhysicsConfig _currentPhysicsConfig;
  late Set<FabAnimationType> _selectedAnimations;
  late TextEditingController _frictionController;

  @override
  void initState() {
    super.initState();
    _currentFabStyle = widget.initialFabStyle;
    _currentPhysicsConfig = widget.initialPhysicsConfig;
    _selectedAnimations = _currentFabStyle.activeAnimations.toSet();
    _frictionController = TextEditingController(
      text: _currentPhysicsConfig.friction.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _frictionController.dispose();
    super.dispose();
  }

  void _updateFabStyle(FabStyle newStyle) {
    setState(() {
      _currentFabStyle = newStyle;
    });
    widget.onConfigChanged(fabStyle: newStyle);
  }

  void _updatePhysicsConfig(PhysicsConfig newConfig) {
    setState(() {
      _currentPhysicsConfig = newConfig;
      if (_frictionController.text != newConfig.friction.toStringAsFixed(2)) {
        _frictionController.text = newConfig.friction.toStringAsFixed(2);
      }
    });
    widget.onConfigChanged(physicsConfig: newConfig);
  }

  void _showGradientPickerDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Change FAB Gradient'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("A full color picker would be used here."),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    final newGradient = _getNextGradient();
                    _updateFabStyle(FabStyle(
                      gradient: newGradient,
                      activeAnimations: _currentFabStyle.activeAnimations,
                      size: _currentFabStyle.size,
                      icon: _currentFabStyle.icon,
                      iconColor: _currentFabStyle.iconColor,
                      animationPeriod: _currentFabStyle.animationPeriod,
                    ));
                    Navigator.of(context).pop();
                  },
                  child: const Text("Apply Random")),
            ],
          );
        });
  }

  LinearGradient _getNextGradient() {
    const gradients = [
      LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
      LinearGradient(colors: [Colors.green, Colors.lightGreen]),
      LinearGradient(colors: [Colors.red, Colors.orange]),
      LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
      LinearGradient(colors: [Colors.cyan, Colors.teal]),
    ];
    final currentIndex = gradients.indexWhere((g) =>
        g.colors == (_currentFabStyle.gradient as LinearGradient).colors);
    final nextIndex = (currentIndex + 1) % gradients.length;
    return gradients[nextIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor.withAlpha((255 * 0.9).round()),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return _buildSingleColumnLayout();
            } else {
              return _buildTwoColumnLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSingleColumnLayout() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildAllControls(),
      ),
    );
  }

  Widget _buildTwoColumnLayout() {
    final controls = _buildAllControls();
    final half = (controls.length / 2).ceil();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controls.sublist(0, half),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: controls.sublist(half),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAllControls() {
    return [
      _buildSectionTitle("FAB Style (استایل دکمه)"),
      ListTile(
        title: const Text("Gradient"),
        trailing: Container(
          width: 100,
          height: 30,
          decoration: BoxDecoration(
            gradient: _currentFabStyle.gradient,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onTap: _showGradientPickerDialog,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      ),
      const Divider(height: 24),
      _buildSectionTitle("Idle Animations (انیمیشن‌های آماده)"),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        children: FabAnimationType.values.map((anim) {
          return FilterChip(
            label: Text(anim.name),
            selected: _selectedAnimations.contains(anim),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _selectedAnimations.add(anim);
                } else {
                  _selectedAnimations.remove(anim);
                }
              });
              _updateFabStyle(FabStyle(
                activeAnimations: _selectedAnimations.toList(),
                size: _currentFabStyle.size,
                icon: _currentFabStyle.icon,
                iconColor: _currentFabStyle.iconColor,
                gradient: _currentFabStyle.gradient,
                animationPeriod: _currentFabStyle.animationPeriod,
              ));
            },
          );
        }).toList(),
      ),
      const Divider(height: 24),
      _buildSectionTitle("Launch & Return (پرتاب و بازگشت)"),
      SegmentedButton<FabLaunchType>(
        segments: const [
          ButtonSegment(value: FabLaunchType.directThrow, label: Text('Throw')),
          ButtonSegment(
              value: FabLaunchType.slingshot, label: Text('Slingshot')),
        ],
        selected: {_currentPhysicsConfig.launchType},
        onSelectionChanged: (newSelection) {
          _updatePhysicsConfig(PhysicsConfig(
            launchType: newSelection.first,
            returnType: _currentPhysicsConfig.returnType,
            collisionEffect: _currentPhysicsConfig.collisionEffect,
            damping: _currentPhysicsConfig.damping,
            friction: _currentPhysicsConfig.friction,
            launchPowerMultiplier: _currentPhysicsConfig.launchPowerMultiplier,
            invertDirectionOnCollision:
                _currentPhysicsConfig.invertDirectionOnCollision,
            returnAnimationDuration:
                _currentPhysicsConfig.returnAnimationDuration,
          ));
        },
      ),
      const SizedBox(height: 8),
      SegmentedButton<FabReturnType>(
        segments: const [
          ButtonSegment(value: FabReturnType.elastic, label: Text('Elastic')),
          ButtonSegment(value: FabReturnType.smooth, label: Text('Smooth')),
          ButtonSegment(value: FabReturnType.teleport, label: Text('Teleport')),
        ],
        selected: {_currentPhysicsConfig.returnType},
        onSelectionChanged: (newSelection) {
          _updatePhysicsConfig(PhysicsConfig(
            returnType: newSelection.first,
            launchType: _currentPhysicsConfig.launchType,
            collisionEffect: _currentPhysicsConfig.collisionEffect,
            damping: _currentPhysicsConfig.damping,
            friction: _currentPhysicsConfig.friction,
            launchPowerMultiplier: _currentPhysicsConfig.launchPowerMultiplier,
            invertDirectionOnCollision:
                _currentPhysicsConfig.invertDirectionOnCollision,
            returnAnimationDuration:
                _currentPhysicsConfig.returnAnimationDuration,
          ));
        },
      ),
      const Divider(height: 24),
      _buildSectionTitle("Physics Parameters (پارامترهای فیزیک)"),
      _buildSlider("Damping (جهندگی)", _currentPhysicsConfig.damping, 1.0, 20,
          (val) {
        _updatePhysicsConfig(PhysicsConfig(
          damping: val,
          launchType: _currentPhysicsConfig.launchType,
          returnType: _currentPhysicsConfig.returnType,
          collisionEffect: _currentPhysicsConfig.collisionEffect,
          friction: _currentPhysicsConfig.friction,
          launchPowerMultiplier: _currentPhysicsConfig.launchPowerMultiplier,
          invertDirectionOnCollision:
              _currentPhysicsConfig.invertDirectionOnCollision,
          returnAnimationDuration:
              _currentPhysicsConfig.returnAnimationDuration,
        ));
      }),
      _buildFrictionInput(),
    ];
  }

  Widget _buildFrictionInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        controller: _frictionController,
        decoration: const InputDecoration(
          labelText: "Friction (0.00 - 0.10)",
          helperText: "Enter a value and press done",
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onFieldSubmitted: (value) {
          final friction = double.tryParse(value);
          if (friction != null && friction >= 0.0 && friction <= 0.1) {
            _updatePhysicsConfig(PhysicsConfig(
              friction: friction,
              launchType: _currentPhysicsConfig.launchType,
              returnType: _currentPhysicsConfig.returnType,
              collisionEffect: _currentPhysicsConfig.collisionEffect,
              damping: _currentPhysicsConfig.damping,
              launchPowerMultiplier:
                  _currentPhysicsConfig.launchPowerMultiplier,
              invertDirectionOnCollision:
                  _currentPhysicsConfig.invertDirectionOnCollision,
              returnAnimationDuration:
                  _currentPhysicsConfig.returnAnimationDuration,
            ));
          } else {
            _frictionController.text =
                _currentPhysicsConfig.friction.toStringAsFixed(2);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Invalid friction value! Must be between 0.00 and 0.10.'),
                  backgroundColor: Colors.red),
            );
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _buildSlider(String label, double value, double max, int divisions,
      ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        Slider(
          value: value,
          min: 0.0,
          max: max,
          divisions: divisions,
          label: value.toStringAsFixed(2),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
