import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/physics_config.dart';
import '../models/style_config.dart';

class PhysicsalFab extends StatefulWidget {
  final FabStyle style;
  final PhysicsConfig physicsConfig;
  final VoidCallback onPressed;
  final ValueChanged<Alignment> onStop;
  final VoidCallback? onDragStart;
  final VoidCallback? onReturnStart;
  final VoidCallback? onLaunch;

  const PhysicsalFab({
    super.key,
    required this.onPressed,
    required this.onStop,
    this.style = const FabStyle(),
    this.physicsConfig = const PhysicsConfig(),
    this.onDragStart,
    this.onReturnStart,
    this.onLaunch,
  });

  @override
  State<PhysicsalFab> createState() => _PhysicsalFabState();
}

class _PhysicsalFabState extends State<PhysicsalFab>
    with TickerProviderStateMixin {
  late Ticker _ticker;
  late AnimationController _impactGlowController;
  late AnimationController _pulsingGlowController;
  // FIX: Create a single, reusable AnimationController for the return animation.
  // اصلاح: ایجاد یک AnimationController تکی و قابل استفاده مجدد برای انیمیشن بازگشت.
  late AnimationController _returnController;
  late Animation<Alignment> _returnAnimation;

  Alignment _dragAlignment = const Alignment(0.0, 0.85);
  Offset _velocity = Offset.zero;
  Timer? _returnTimer;

  bool _isAiming = false;
  Offset _dragOffset = Offset.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
    _impactGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pulsingGlowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // FIX: Initialize the return controller here and add the listener.
    // اصلاح: کنترلر بازگشت در اینجا مقداردهی اولیه و لیسنر به آن اضافه می‌شود.
    _returnController = AnimationController(vsync: this);
    _returnAnimation =
        AlignmentTween(begin: _dragAlignment, end: _dragAlignment)
            .animate(_returnController)
          ..addListener(() {
            if (mounted) {
              setState(() {
                _dragAlignment = _returnAnimation.value;
              });
            }
          });
  }

  @override
  void dispose() {
    _ticker.dispose();
    _impactGlowController.dispose();
    _pulsingGlowController.dispose();
    // FIX: Ensure all controllers are disposed.
    // اصلاح: اطمینان از اینکه تمام کنترلرها dispose می‌شوند.
    _returnController.dispose();
    _returnTimer?.cancel();
    super.dispose();
  }

  void _tick(Duration elapsed) {
    if (!mounted) return;
    setState(() {
      final screenSize = MediaQuery.of(context).size;
      _dragAlignment += Alignment(
        _velocity.dx / (screenSize.width / 2),
        _velocity.dy / (screenSize.height / 2),
      );
      _velocity *= (1.0 - widget.physicsConfig.friction);

      bool hasCollided = false;
      if (_dragAlignment.x.abs() > 1.0) {
        _velocity = Offset(-_velocity.dx * widget.physicsConfig.damping,
            _velocity.dy * widget.physicsConfig.damping);
        _dragAlignment =
            Alignment(_dragAlignment.x.clamp(-1.0, 1.0), _dragAlignment.y);
        hasCollided = true;
      }
      if (_dragAlignment.y.abs() > 1.0) {
        _velocity = Offset(_velocity.dx * widget.physicsConfig.damping,
            -_velocity.dy * widget.physicsConfig.damping);
        _dragAlignment =
            Alignment(_dragAlignment.x, _dragAlignment.y.clamp(-1.0, 1.0));
        hasCollided = true;
      }

      if (hasCollided) {
        _handleCollisionEffect();
      }

      if (_ticker.isTicking && _velocity.distance < 0.1) {
        _ticker.stop();
        widget.onStop(_dragAlignment);
      }
    });
  }

  void _handleCollisionEffect() {
    switch (widget.physicsConfig.collisionEffect) {
      case FabCollisionEffect.bounceAndGlow:
        _impactGlowController.forward(from: 0.0);
        break;
      case FabCollisionEffect.explosiveGlow:
        _impactGlowController.duration = const Duration(milliseconds: 800);
        _impactGlowController.forward(from: 0.0);
        _impactGlowController.duration = const Duration(milliseconds: 400);
        break;
      case FabCollisionEffect.stickToWall:
        _velocity = Offset.zero;
        break;
    }
  }

  void _onPanStart(DragStartDetails details) {
    widget.onDragStart?.call();
    _returnTimer?.cancel();
    _ticker.stop();
    _returnController.stop();
    setState(() {
      _isAiming = true;
      _dragOffset = Offset.zero;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (!_isAiming) return;

    setState(() {
      switch (widget.physicsConfig.launchType) {
        case FabLaunchType.directThrow:
          _velocity = _dragOffset * widget.physicsConfig.launchPowerMultiplier;
          break;
        case FabLaunchType.slingshot:
          _velocity = -_dragOffset * widget.physicsConfig.launchPowerMultiplier;
          break;
      }
      _isAiming = false;
      _dragOffset = Offset.zero;
    });

    if (_velocity.distance > 1.0) {
      widget.onLaunch?.call();
      _ticker.start();
    } else {
      widget.onStop(_dragAlignment);
    }

    _returnTimer?.cancel();
    _returnTimer = Timer(const Duration(seconds: 5), _returnToHome);
  }

  void _returnToHome() {
    widget.onReturnStart?.call();
    _ticker.stop();

    switch (widget.physicsConfig.returnType) {
      case FabReturnType.teleport:
        setState(() {
          _dragAlignment = const Alignment(0.0, 0.85);
        });
        break;
      case FabReturnType.elastic:
      case FabReturnType.smooth:
        _returnController.duration =
            widget.physicsConfig.returnAnimationDuration;
        final curve = widget.physicsConfig.returnType == FabReturnType.elastic
            ? Curves.elasticOut
            : Curves.easeOutCubic;

        _returnAnimation = AlignmentTween(
          begin: _dragAlignment,
          end: const Alignment(0.0, 0.85),
        ).animate(CurvedAnimation(parent: _returnController, curve: curve));

        _returnController.forward(from: 0.0);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _dragAlignment,
      child: SizedBox(
        width: widget.style.size,
        height: widget.style.size,
        child: GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          onTap: widget.onPressed,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              if (_isAiming)
                CustomPaint(
                  painter: _AimingLinePainter(
                    dragOffset: _dragOffset,
                    gradient: widget.style.gradient,
                    pulsingAnimation: _pulsingGlowController,
                  ),
                ),
              _AnimatedGlowingFab(
                style: widget.style,
                impactGlowController: _impactGlowController,
                isCharging: _isAiming,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedGlowingFab extends StatefulWidget {
  final FabStyle style;
  final AnimationController impactGlowController;
  final bool isCharging;

  const _AnimatedGlowingFab({
    required this.style,
    required this.impactGlowController,
    required this.isCharging,
  });

  @override
  __AnimatedGlowingFabState createState() => __AnimatedGlowingFabState();
}

class __AnimatedGlowingFabState extends State<_AnimatedGlowingFab>
    with TickerProviderStateMixin {
  final Map<FabAnimationType, AnimationController> _animationControllers = {};
  final Map<FabAnimationType, Animation<dynamic>> _animations = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    final period = widget.style.animationPeriod;

    for (var animType in widget.style.activeAnimations) {
      switch (animType) {
        case FabAnimationType.rotation:
          final controller = AnimationController(vsync: this, duration: period)
            ..repeat();
          _animationControllers[animType] = controller;
          _animations[animType] =
              Tween<double>(begin: 0, end: 1).animate(controller);
          break;
        case FabAnimationType.pulse:
          final controller = AnimationController(vsync: this, duration: period)
            ..repeat(reverse: true);
          _animationControllers[animType] = controller;
          _animations[animType] = Tween<double>(begin: 0.9, end: 1.1).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
          break;
        case FabAnimationType.blink:
          final controller = AnimationController(vsync: this, duration: period)
            ..repeat(reverse: true);
          _animationControllers[animType] = controller;
          _animations[animType] = Tween<double>(begin: 0.7, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
          break;
        case FabAnimationType.floatVertical:
        case FabAnimationType.floatHorizontal:
          final controller = AnimationController(vsync: this, duration: period)
            ..repeat(reverse: true);
          _animationControllers[animType] = controller;
          _animations[animType] = Tween<double>(begin: -5.0, end: 5.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut),
          );
          break;
      }
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedGlowingFab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.style.activeAnimations != oldWidget.style.activeAnimations) {
      _disposeAnimations();
      _initializeAnimations();
    }
  }

  void _disposeAnimations() {
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    _animationControllers.clear();
    _animations.clear();
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget fabCore = ClipRRect(
      borderRadius: BorderRadius.circular(widget.style.size),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: widget.style.gradient,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withAlpha(50)),
          ),
          child: Icon(widget.style.icon,
              size: widget.style.size * 0.5, color: widget.style.iconColor),
        ),
      ),
    );

    Widget animatedFab = fabCore;
    for (var entry in _animations.entries) {
      final animType = entry.key;
      final animation = entry.value;

      animatedFab = AnimatedBuilder(
        animation: animation,
        child: animatedFab,
        builder: (context, child) {
          switch (animType) {
            case FabAnimationType.rotation:
              return RotationTransition(
                  turns: animation as Animation<double>, child: child);
            case FabAnimationType.pulse:
              return ScaleTransition(
                  scale: animation as Animation<double>, child: child);
            case FabAnimationType.blink:
              return FadeTransition(
                  opacity: animation as Animation<double>, child: child);
            case FabAnimationType.floatVertical:
              return Transform.translate(
                  offset: Offset(0, animation.value), child: child);
            case FabAnimationType.floatHorizontal:
              return Transform.translate(
                  offset: Offset(animation.value, 0), child: child);
          }
        },
      );
    }

    final double chargeScale = widget.isCharging ? 1.15 : 1.0;
    final double chargeGlow = widget.isCharging ? 15.0 : 0.0;

    final glowColor = (widget.style.gradient is LinearGradient)
        ? (widget.style.gradient as LinearGradient).colors.first
        : Colors.cyan;

    return AnimatedScale(
      scale: chargeScale,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: AnimatedBuilder(
        animation: widget.impactGlowController,
        builder: (context, child) {
          final glowValue = widget.impactGlowController.value;
          final curve = Curves.easeOut.transform(glowValue);
          return Container(
            width: widget.style.size,
            height: widget.style.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: glowColor
                      .withAlpha((255 * (0.5 + (curve * 0.5))).round()),
                  blurRadius: 15 + (curve * 25) + chargeGlow,
                  spreadRadius: 3 + (curve * 7) + (chargeGlow / 5),
                ),
              ],
            ),
            child: child,
          );
        },
        child: animatedFab,
      ),
    );
  }
}

class _AimingLinePainter extends CustomPainter {
  final Offset dragOffset;
  final Gradient gradient;
  final Animation<double> pulsingAnimation;

  _AimingLinePainter({
    required this.dragOffset,
    required this.gradient,
    required this.pulsingAnimation,
  }) : super(repaint: pulsingAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final endPoint = center + dragOffset;
    final distance = dragOffset.distance;
    final powerRatio = (distance / 150.0).clamp(0.0, 1.0);
    final linePaint = Paint()
      ..strokeWidth = 2.0 + (powerRatio * 3.0)
      ..strokeCap = StrokeCap.round;

    if (distance > 0) {
      linePaint.shader =
          gradient.createShader(Rect.fromPoints(center, endPoint));
      canvas.drawLine(center, endPoint, linePaint);
    }

    final pulseValue = pulsingAnimation.value;
    final glowRadius = 12.0 + (powerRatio * 10.0) + (pulseValue * 10.0);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          (gradient as LinearGradient)
              .colors
              .last
              .withOpacity(0.6 * pulseValue),
          (gradient).colors.first.withOpacity(0.2 * pulseValue),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: endPoint, radius: glowRadius));
    canvas.drawCircle(endPoint, glowRadius, glowPaint);

    final circlePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          (gradient).colors.last.withOpacity(0.9),
          (gradient).colors.first.withOpacity(0.4),
          Colors.transparent,
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(
          Rect.fromCircle(center: endPoint, radius: 6.0 + (powerRatio * 6.0)));
    canvas.drawCircle(endPoint, 6.0 + (powerRatio * 6.0), circlePaint);
  }

  @override
  bool shouldRepaint(covariant _AimingLinePainter oldDelegate) {
    return oldDelegate.dragOffset != dragOffset ||
        oldDelegate.gradient != gradient ||
        oldDelegate.pulsingAnimation != pulsingAnimation;
  }
}
