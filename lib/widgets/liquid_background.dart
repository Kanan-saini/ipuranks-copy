import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class LiquidBackground extends StatefulWidget {
  final Widget child;
  final Color primaryColor;

  const LiquidBackground({
    Key? key,
    required this.child,
    this.primaryColor = const Color(0xFF38BDF8),
  }) : super(key: key);

  @override
  State<LiquidBackground> createState() => _LiquidBackgroundState();
}

class _LiquidBackgroundState extends State<LiquidBackground>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _particleController;
  Offset _touchPosition = Offset.zero;
  List<_Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _particleController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _generateParticles();
  }

  void _generateParticles() {
    particles.clear();
    for (int i = 0; i < 15; i++) {
      particles.add(_Particle(
        offset: Offset(
          (i * 80).toDouble(),
          (i * 50).toDouble(),
        ),
        size: 40 + (i * 10).toDouble(),
        delay: i * 0.1,
      ));
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _onBackgroundTap(TapDownDetails details) {
    setState(() {
      _touchPosition = details.globalPosition;
    });

    // Ripple animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _touchPosition = Offset(-1000, -1000);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onBackgroundTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF070B16),
              const Color(0xFF0B132B),
              const Color(0xFF0F1B3D),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated liquid blobs
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, _) {
                return Stack(
                  children: [
                    // Large blob 1
                    Positioned(
                      top: -100 + _sin(_waveController.value * 2 * 3.14) * 30,
                      right: -80 + _cos(_waveController.value * 2 * 3.14) * 40,
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.primaryColor.withOpacity(0.10),
                          boxShadow: [
                            BoxShadow(
                              color: widget.primaryColor.withOpacity(0.18),
                              blurRadius: 70,
                              spreadRadius: 18,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Large blob 2
                    Positioned(
                      bottom: -120 + _sin(_waveController.value * 1.5 * 3.14) * 40,
                      left: -100 + _cos(_waveController.value * 1.5 * 3.14) * 50,
                      child: Container(
                        width: 350,
                        height: 350,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF3B82F6).withOpacity(0.08),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.14),
                              blurRadius: 80,
                              spreadRadius: 22,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Accent blob
                    Positioned(
                      top: 300 + _sin(_waveController.value * 3 * 3.14) * 35,
                      left: 50 + _cos(_waveController.value * 2.5 * 3.14) * 40,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF7C3AED).withOpacity(0.07),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C3AED).withOpacity(0.12),
                              blurRadius: 60,
                              spreadRadius: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Floating particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) {
                return Stack(
                  children: particles.map((particle) {
                    final progress =
                        (_particleController.value + particle.delay) % 1.0;
                    final yOffset = progress * 500 - 250;

                    return Positioned(
                      left: particle.offset.dx +
                          _sin(progress * 2 * 3.14) * 100,
                      top: particle.offset.dy + yOffset,
                      child: Opacity(
                        opacity: (1 - (progress - 0.7).abs() * 3).clamp(0, 1),
                        child: Container(
                          width: particle.size,
                          height: particle.size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.primaryColor
                                .withOpacity(0.07 * (1 - progress)),
                            border: Border.all(
                              color: widget.primaryColor
                                  .withOpacity(0.14 * (1 - progress)),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            // Touch ripple effect
            if (_touchPosition.dx > 0 && _touchPosition.dy > 0)
              Positioned(
                left: _touchPosition.dx - 50,
                top: _touchPosition.dy - 50,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, value, _) {
                    return Container(
                      width: 100 + (value * 150),
                      height: 100 + (value * 150),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.primaryColor
                              .withOpacity((1 - value) * 0.6),
                          width: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Main content
            widget.child,
          ],
        ),
      ),
    );
  }

  double _sin(double x) => sin(x);
  double _cos(double x) => cos(x);
}

class _Particle {
  final Offset offset;
  final double size;
  final double delay;

  _Particle({
    required this.offset,
    required this.size,
    required this.delay,
  });
}
