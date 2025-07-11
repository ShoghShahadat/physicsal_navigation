import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/physics_config.dart';
import '../models/style_config.dart';

/// The core widget of the package: A Floating Action Button with built-in physics.
/// ویجت اصلی پکیج: یک دکمه شناور با فیزیک داخلی.
/// It can be launched, collides with screen edges, and returns to its home position.
/// این دکمه قابل پرتاب است، با لبه‌های صفحه برخورد می‌کند و به جایگاه اصلی خود بازمی‌گردد.
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
  }

  @override
  void dispose() {
    _ticker.dispose();
    _impactGlowController.dispose();
    _pulsingGlowController.dispose();
    _returnTimer?.cancel();
    super.dispose();
  }

  /// The physics engine tick. This is called on every frame while the FAB is moving.
  /// تیک موتور فیزیک. این تابع در هر فریم تا زمانی که دکمه در حال حرکت است، فراخوانی می‌شود.
  void _tick(Duration elapsed) {
    if (!mounted) return;
    setState(() {
      final screenSize = MediaQuery.of(context).size;
      _dragAlignment += Alignment(
        _velocity.dx / (screenSize.width / 2),
        _velocity.dy / (screenSize.height / 2),
      );
      _velocity *= (1.0 - widget.physicsConfig.friction);

      // Wall collision logic based on PhysicsConfig
      // منطق برخورد با دیواره‌ها بر اساس تنظیمات فیزیک
      bool hasCollided = false;
      if (_dragAlignment.x.abs() > 1.0) {
        if (widget.physicsConfig.invertDirectionOnCollision) {
          _velocity = Offset(
            -_velocity.dx * widget.physicsConfig.damping,
            _velocity.dy * widget.physicsConfig.damping,
          );
        } else {
          _velocity = Offset(0, _velocity.dy * widget.physicsConfig.damping);
        }
        _dragAlignment = Alignment(
          _dragAlignment.x.clamp(-1.0, 1.0),
          _dragAlignment.y,
        );
        hasCollided = true;
      }
      if (_dragAlignment.y.abs() > 1.0) {
        if (widget.physicsConfig.invertDirectionOnCollision) {
          _velocity = Offset(
            _velocity.dx * widget.physicsConfig.damping,
            -_velocity.dy * widget.physicsConfig.damping,
          );
        } else {
          _velocity = Offset(_velocity.dx * widget.physicsConfig.damping, 0);
        }
        _dragAlignment = Alignment(
          _dragAlignment.x,
          _dragAlignment.y.clamp(-1.0, 1.0),
        );
        hasCollided = true;
      }

      if (hasCollided) {
        _handleCollisionEffect();
      }

      // Stop the ticker if velocity is negligible
      // اگر سرعت ناچیز بود، تیکر را متوقف کن
      if (_velocity.distance < 0.1) {
        _ticker.stop();
        widget.onStop(_dragAlignment);
      }
    });
  }

  /// Handles the visual and physical effect of a collision based on the config.
  /// افکت بصری و فیزیکی برخورد را بر اساس تنظیمات مدیریت می‌کند.
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

  /// Starts the animation to return the FAB to its home position based on the config.
  /// انیمیشن بازگشت دکمه به جایگاه اصلی را بر اساس تنظیمات شروع می‌کند.
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
        final returnController = AnimationController(
          vsync: this,
          duration: widget.physicsConfig.returnAnimationDuration,
        );
        final curve = widget.physicsConfig.returnType == FabReturnType.elastic
            ? Curves.elasticOut
            : Curves.easeOutCubic;

        final animation = returnController.drive(
          AlignmentTween(
            begin: _dragAlignment,
            end: const Alignment(0.0, 0.85),
          ).chain(CurveTween(curve: curve)),
        );
        animation.addListener(() {
          if (mounted) setState(() => _dragAlignment = animation.value);
        });
        returnController.forward().whenCompleteOrCancel(() {
          returnController.dispose();
        });
        break;
    }
  }

  void _onPanStart(DragStartDetails details) {
    widget.onDragStart?.call();
    _returnTimer?.cancel();
    _ticker.stop();
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
      // Set velocity based on the chosen launch type
      // تنظیم سرعت بر اساس نوع پرتاب انتخاب شده
      switch (widget.physicsConfig.launchType) {
        case FabLaunchType.directThrow:
          _velocity = _dragOffset * widget.physicsConfig.launchPowerMultiplier;
          break;
        case FabLaunchType.slingshot:
          // Velocity is opposite to the drag direction
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
                glowController: _impactGlowController,
                isCharging: _isAiming,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// _AnimatedGlowingFab and _AimingLinePainter remain the same as they are purely visual
// and controlled by the main state widget. No changes needed here.
// ویجت‌های داخلی برای ظاهر و انیمیشن بدون تغییر باقی می‌مانند.

class _AnimatedGlowingFab extends StatefulWidget {
  final FabStyle style;
  final AnimationController glowController;
  final bool isCharging;

  const _AnimatedGlowingFab({
    required this.style,
    required this.glowController,
    required this.isCharging,
  });

  @override
  __AnimatedGlowingFabState createState() => __AnimatedGlowingFabState();
}

class __AnimatedGlowingFabState extends State<_AnimatedGlowingFab>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double chargeScale = widget.isCharging ? 1.15 : 1.0;
    final double chargeGlow = widget.isCharging ? 15.0 : 0.0;

    return AnimatedScale(
      scale: chargeScale,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: AnimatedBuilder(
        animation: widget.glowController,
        builder: (context, child) {
          final glowValue = widget.glowController.value;
          final curve = Curves.easeOut.transform(glowValue);
          return Container(
            width: widget.style.size,
            height: widget.style.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.style.glowColor.withAlpha(
                    (255 * (0.5 + (curve * 0.5))).round(),
                  ),
                  blurRadius: 15 + (curve * 25) + chargeGlow,
                  spreadRadius: 3 + (curve * 7) + (chargeGlow / 5),
                ),
              ],
            ),
            child: child,
          );
        },
        child: RotationTransition(
          turns: _rotationController,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.style.size),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: widget.style.gradient,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha((255 * 0.2).round()),
                  ),
                ),
                child: Icon(
                  widget.style.icon,
                  size: widget.style.size * 0.5,
                  color: widget.style.iconColor,
                ),
              ),
            ),
          ),
        ),
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
      linePaint.shader = gradient.createShader(
        Rect.fromPoints(center, endPoint),
      );
      canvas.drawLine(center, endPoint, linePaint);
    }

    final pulseValue = pulsingAnimation.value;
    final glowRadius = 12.0 + (powerRatio * 10.0) + (pulseValue * 10.0);
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          (gradient as LinearGradient).colors.last.withOpacity(
            0.6 * pulseValue,
          ),
          (gradient as LinearGradient).colors.first.withOpacity(
            0.2 * pulseValue,
          ),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: endPoint, radius: glowRadius));
    canvas.drawCircle(endPoint, glowRadius, glowPaint);

    final circlePaint = Paint()
      ..shader =
          RadialGradient(
            colors: [
              (gradient as LinearGradient).colors.last.withOpacity(0.9),
              (gradient as LinearGradient).colors.first.withOpacity(0.4),
              Colors.transparent,
            ],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(
            Rect.fromCircle(center: endPoint, radius: 6.0 + (powerRatio * 6.0)),
          );
    canvas.drawCircle(endPoint, 6.0 + (powerRatio * 6.0), circlePaint);
  }

  @override
  bool shouldRepaint(covariant _AimingLinePainter oldDelegate) {
    return oldDelegate.dragOffset != dragOffset ||
        oldDelegate.gradient != gradient ||
        oldDelegate.pulsingAnimation != pulsingAnimation;
  }
}
