import 'package:flutter/material.dart';
import '../models/result_model.dart';
import '../widgets/liquid_background.dart';
import '../widgets/semester_card.dart';
import '../widgets/student_info_card.dart';

class ResultScreenArgs {
  final GroupedResult? groupedResult;
  final String? errorMessage;
  final bool showLoading;

  const ResultScreenArgs({
    this.groupedResult,
    this.errorMessage,
    this.showLoading = true,
  });
}

class ResultDashboard extends StatefulWidget {
  final GroupedResult? groupedResult;
  final String? errorMessage;
  final bool showLoading;

  const ResultDashboard({
    Key? key,
    this.groupedResult,
    this.errorMessage,
    this.showLoading = true,
  }) : super(key: key);

  @override
  State<ResultDashboard> createState() => _ResultDashboardState();
}

class _ResultDashboardState extends State<ResultDashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animationController.repeat();

    // Show loading animation first, then reveal results
    if (widget.showLoading) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() => _showContent = true);
        }
      });
    } else {
      _showContent = true;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B16),
      body: LiquidBackground(
        primaryColor: const Color(0xFF38BDF8),
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
                                const Color(0xFF7DD3FC),
                                const Color(0xFF3B82F6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds),
                            child: const Text(
                              'Results',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 38,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Academic Performance Dashboard',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13,
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
                                  color: const Color(0xFF38BDF8).withOpacity(0.25),
                                  blurRadius: 18,
                                  spreadRadius: 1,
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
              if (!_showContent)
                Expanded(
                  child: _buildLoadingState(),
                )
              else
                Expanded(
                  child: _buildResultContent(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              RotationTransition(
                turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                            color: const Color(0xFF38BDF8).withOpacity(0.35),
                      width: 3,
                    ),
                  ),
                ),
              ),
              RotationTransition(
                turns: Tween(begin: 1.0, end: 0.0).animate(_animationController),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                            color: const Color(0xFF3B82F6).withOpacity(0.35),
                      width: 2,
                    ),
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                            const Color(0xFF38BDF8).withOpacity(0.4),
                            const Color(0xFF38BDF8).withOpacity(0),
                    ],
                  ),
                ),
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                        color: const Color(0xFF38BDF8),
                  boxShadow: [
                    BoxShadow(
                            color: const Color(0xFF38BDF8).withOpacity(0.7),
                            blurRadius: 24,
                            spreadRadius: 5,
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
            return Transform.scale(scale: scale, child: child);
          },
          child: Column(
            children: [
              const Text(
                'Fetching your results...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Syncing your academic data',
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
    );
  }

  Widget _buildResultContent() {
    if (widget.errorMessage != null && widget.errorMessage!.isNotEmpty) {
      return _buildErrorState(widget.errorMessage!);
    }

    final groupedResult = widget.groupedResult;
    final summary = groupedResult?.summary;
    final semesters = groupedResult?.semesters ?? const [];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      children: [
        if (groupedResult != null)
          StudentInfoCard(
            info: groupedResult.student,
            summary: summary,
          ),
        if (groupedResult != null) const SizedBox(height: 20),
        if (semesters.isEmpty)
          _buildEmptyState()
        else
          ...semesters.map(
            (semester) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SemesterCard(result: semester),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0B132B).withOpacity(0.7),
            const Color(0xFF0F1B3D).withOpacity(0.55),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
          width: 1.4,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.inbox, color: Color(0xFF38BDF8), size: 40),
          const SizedBox(height: 12),
          const Text(
            'No results found',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try again later or contact the institute for help.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFF43F5E).withOpacity(0.1),
          border: Border.all(
            color: const Color(0xFFF43F5E).withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFF43F5E), size: 42),
            const SizedBox(height: 12),
            const Text(
              'Unable to load results',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
