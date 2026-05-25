import 'package:flutter/material.dart';
import 'screens/enrollment_screen.dart';
import 'screens/login_screen.dart';
import 'screens/result_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IPU Ranks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0a0e27),
        fontFamily: 'Poppins',
      ),
      home: const EnrollmentScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            final enrollmentNumber = settings.arguments as String;
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  LoginScreen(enrollmentNumber: enrollmentNumber),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOutCubic;

                final tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            );

          case '/results':
            final args = settings.arguments;
            final resultArgs = args is ResultScreenArgs ? args : null;
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ResultDashboard(
                    groupedResult: resultArgs?.groupedResult,
                    errorMessage: resultArgs?.errorMessage,
                    showLoading: resultArgs?.showLoading ?? true,
                  ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );

          default:
            return null;
        }
      },
    );
  }
}
