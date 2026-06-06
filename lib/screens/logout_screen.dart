import 'package:flutter/material.dart';

import '../services/session_storage.dart';
import '../widgets/liquid_background.dart';
import 'enrollment_screen.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({Key? key}) : super(key: key);

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  void initState() {
    super.initState();
    _performLogout();
  }

  Future<void> _performLogout() async {
    await Future.wait([
      SessionStorage.clearAllSessionData(),
      Future.delayed(const Duration(milliseconds: 700)),
    ]);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const EnrollmentScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFF070B16),
        body: LiquidBackground(
          primaryColor: const Color(0xFF38BDF8),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF38BDF8).withOpacity(0.35),
                            const Color(0xFF38BDF8).withOpacity(0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Color(0xFF7DD3FC),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Signing you out...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Logging out... Please wait a moment.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
