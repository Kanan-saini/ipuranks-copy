import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/enrollment_screen.dart';
import 'screens/result_dashboard.dart';
import 'services/credit_catalog.dart';
import 'services/session_storage.dart';
import 'models/login_response.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await CreditCatalogService.loadCatalog();
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
        scaffoldBackgroundColor: const Color(0xFF070B16),
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF3B82F6),
          surface: Color(0xFF0B132B),
          background: Color(0xFF070B16),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF0B132B),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: const SessionRestoreGate(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
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

class SessionRestoreGate extends StatefulWidget {
  const SessionRestoreGate({Key? key}) : super(key: key);

  @override
  State<SessionRestoreGate> createState() => _SessionRestoreGateState();
}

class _SessionRestoreGateState extends State<SessionRestoreGate> {
  late Future<LoginResponse?> _restoreFuture;

  @override
  void initState() {
    super.initState();
    _restoreFuture = SessionStorage.loadSavedLoginResponse();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginResponse?>(
      future: _restoreFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            backgroundColor: Color(0xFF070B16),
          );
        }

        final response = snapshot.data;
        if (response != null) {
          return ResultDashboard(
            groupedResult: response.groupedResult,
            errorMessage: response.groupedResult == null
                ? 'Unable to parse result data.'
                : null,
            showLoading: false,
          );
        }

        return const EnrollmentScreen();
      },
    );
  }
}
