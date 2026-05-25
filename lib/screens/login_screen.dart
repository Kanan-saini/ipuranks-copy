import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/login_response.dart';
import '../services/auth_service.dart';
import 'result_dashboard.dart';

class LoginScreen extends StatefulWidget {
  final String enrollmentNumber;

  const LoginScreen({
    super.key,
    required this.enrollmentNumber,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _enrollmentController;
  final TextEditingController _passwordController =
      TextEditingController();

  final TextEditingController _captchaController =
      TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isCaptchaLoading = false;

  Uint8List? _captchaBytes;

  String? _captchaError;

  String? _captchaSessionId;

  static const String _captchaEndpoint =
      'https://ipuranks.abhii.app/api/v1/captcha/generate';

  @override
  void initState() {
    super.initState();
    _enrollmentController = TextEditingController(
      text: widget.enrollmentNumber,
    );
    _fetchCaptcha();
  }

  @override
  void dispose() {
    _enrollmentController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  Future<void> _fetchCaptcha() async {
    setState(() {
      _isCaptchaLoading = true;
      _captchaBytes = null;
      _captchaError = null;
    });

    try {
      final response = await http.get(
        Uri.parse(_captchaEndpoint),
      );

      print("CAPTCHA STATUS => ${response.statusCode}");
      print("CAPTCHA HEADERS:");
      print(response.headers);

      // SESSION ID
      _captchaSessionId =
          response.headers['x-session-id'] ??
          response.headers['X-Session-Id'];

      print("SESSION ID => $_captchaSessionId");

      if (response.statusCode == 200) {
        setState(() {
          _captchaBytes = response.bodyBytes;
        });
      } else {
        setState(() {
          _captchaError = "Failed to load captcha";
        });
      }
    } catch (e) {
      setState(() {
        _captchaError = e.toString();
      });
    }

    setState(() {
      _isCaptchaLoading = false;
    });
  }

  Future<void> _handleLogin() async {
    final enrollmentNumber = _enrollmentController.text.trim();
    final password = _passwordController.text.trim();

    final captcha = _captchaController.text.trim();

    if (enrollmentNumber.isEmpty) {
      _showMessage("Enrollment number missing");
      return;
    }

    if (password.isEmpty) {
      _showMessage("Enter password");
      return;
    }

    if (captcha.isEmpty) {
      _showMessage("Enter captcha");
      return;
    }

    if (_captchaSessionId == null) {
      _showMessage("Captcha session missing");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final LoginResponse response = await _authService.login(
      enrollmentNumber: enrollmentNumber,
      password: password,
      captcha: captcha,
      captchaSessionId: _captchaSessionId!,
    );

    setState(() {
      _isLoading = false;
    });

    if (response.success) {
      final groupedResult = response.groupedResult;

      if (!mounted) {
        return;
      }

      Navigator.pushNamed(
        context,
        '/results',
        arguments: ResultScreenArgs(
          groupedResult: groupedResult,
          errorMessage: groupedResult == null
              ? 'Unable to parse result data.'
              : null,
        ),
      );
    } else {
      _showMessage(response.message);

      // Refresh captcha on failure
      _fetchCaptcha();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _enrollmentController,
              decoration: const InputDecoration(
                hintText: "Enrollment Number",
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
              ),
            ),

            const SizedBox(height: 20),

            if (_isCaptchaLoading)
              const CircularProgressIndicator(),

            if (_captchaBytes != null)
              Image.memory(
                _captchaBytes!,
                height: 100,
              ),

            if (_captchaError != null)
              Text(_captchaError!),

            const SizedBox(height: 20),

            TextField(
              controller: _captchaController,
              decoration: const InputDecoration(
                hintText: "Enter Captcha",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}