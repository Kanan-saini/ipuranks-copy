import 'package:flutter/material.dart';
import '../models/result_model.dart';
import '../widgets/result_card.dart';
import '../widgets/liquid_background.dart';

class ResultDashboard extends StatefulWidget {
  const ResultDashboard({Key? key}) : super(key: key);

  @override
  State<ResultDashboard> createState() => _ResultDashboardState();
}

class _ResultDashboardState extends State<ResultDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showResultCard = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Show loading animation first, then reveal results
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _showResultCard = true);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0a0e27),
      body: LiquidBackground(
        primaryColor: const Color(0xFFec4899),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOut,
                      builder: (context, opacity, child) {
                        return Opacity(
                          opacity: opacity,
                          child: child,
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                const Color(0xFFec4899),
                                const Color(0xFF84cc16),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              'Results',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Academic Performance',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 1400),
                          curve: Curves.easeOut,
                          builder: (context, opacity, child) {
                            return Opacity(
                              opacity: opacity,
                              child: child,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.08),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.15),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.05),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Loading state or results
              if (!_showResultCard)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated loading circle with multiple rings
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer ring 1
                            RotationTransition(
                              turns: Tween(begin: 0.0, end: 1.0)
                                  .animate(_animationController),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF84cc16)
                                        .withOpacity(0.3),
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),

                            // Outer ring 2
                            RotationTransition(
                              turns: Tween(begin: 1.0, end: 0.0)
                                  .animate(_animationController),
                              child: Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF6366f1)
                                        .withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),

                            // Center glow
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFF84cc16).withOpacity(0.3),
                                    const Color(0xFF84cc16).withOpacity(0),
                                  ],
                                ),
                              ),
                            ),

                            // Center dot
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF84cc16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF84cc16)
                                        .withOpacity(0.6),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.8, end: 1),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeInOut,
                        builder: (context, scale, child) {
                          return Transform.scale(
                            scale: scale,
                            child: child,
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              'Fetching your results...',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Processing your academic data',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: ResultCard(
                      result: dummyResult,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
