import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/login_response.dart';
import '../services/auth_service.dart';
import '../services/http_client_factory.dart';
import '../widgets/custom_button.dart';
import '../widgets/input_field.dart';
import '../widgets/liquid_background.dart';
import 'result_dashboard.dart';

class EnrollmentScreen extends StatefulWidget {
  const EnrollmentScreen({Key? key}) : super(key: key);

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _enrollmentController;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  final AuthService _authService = AuthService();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isLoading = false;
  bool _showFetchingResults = false;
  bool _isCaptchaLoading = false;
  Uint8List? _captchaBytes;
  String? _captchaError;
  String? _captchaSessionId;

  static const String _captchaEndpoint =
      'https://ipuranks.abhii.app/api/v1/captcha/generate';

  @override
  void initState() {
    super.initState();
    _enrollmentController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
    _fetchCaptcha();
  }

  @override
  void dispose() {
    _enrollmentController.dispose();
    _passwordController.dispose();
    _captchaController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchCaptcha() async {
    setState(() {
      _isCaptchaLoading = true;
      _captchaBytes = null;
      _captchaError = null;
    });

    final client = createHttpClient();
    try {
      final response = await client
          .get(Uri.parse(_captchaEndpoint))
          .timeout(const Duration(seconds: 12));

      _captchaSessionId =
          response.headers['x-session-id'] ?? response.headers['X-Session-Id'];

      if (response.statusCode == 200) {
        setState(() {
          _captchaBytes = response.bodyBytes;
        });
      } else {
        setState(() {
          _captchaError = 'Failed to load captcha';
        });
      }
    } on TimeoutException catch (e) {
      debugPrint('Captcha timeout: $e');
      setState(() {
        _captchaError = 'No internet connection or server unreachable.';
      });
    } on http.ClientException catch (e) {
      debugPrint('Captcha client error: $e');
      setState(() {
        _captchaError = 'No internet connection or server unreachable.';
      });
    } catch (e) {
      debugPrint('Captcha error: $e');
      setState(() {
        _captchaError = 'No internet connection or server unreachable.';
      });
    } finally {
      client.close();
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
      _showMessage('Enrollment number missing');
      return;
    }

    if (password.isEmpty) {
      _showMessage('Enter password');
      return;
    }

    if (captcha.isEmpty) {
      _showMessage('Enter captcha');
      return;
    }

    if (_captchaSessionId == null) {
      _showMessage('Captcha session missing');
      return;
    }

    setState(() {
      _isLoading = true;
      _showFetchingResults = false;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted || !_isLoading) {
        return;
      }
      setState(() {
        _showFetchingResults = true;
      });
    });

    final LoginResponse response = await _authService.login(
      enrollmentNumber: enrollmentNumber,
      password: password,
      captcha: captcha,
      captchaSessionId: _captchaSessionId!,
    );

    setState(() {
      _isLoading = false;
      _showFetchingResults = false;
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
      _showMessage(_resolveErrorMessage(response));
      _fetchCaptcha();
    }
  }

  String _resolveErrorMessage(LoginResponse response) {
    final backendMessage = _extractBackendMessage(response);
    final message = backendMessage.isNotEmpty
        ? backendMessage
        : response.message.trim();
    final normalized = message.toLowerCase();
    final statusCode = _statusCodeFromResponse(response);

    if (_containsAny(normalized, [
      'account locked',
      'locked',
      'too many attempts',
      'login blocked',
      'maximum attempts',
      'temporary lock',
    ])) {
      return 'Account temporarily locked after 3 failed login attempts. Please try again later.';
    }

    if (_containsAny(normalized, ['captcha', 'captcha code'])) {
      if (_containsAny(normalized, ['mismatch', 'invalid', "doesn't match"])) {
        return "Captcha doesn't match. Please try again.";
      }
    }

    if (_containsAny(normalized, ['password', 'passcode'])) {
      if (_containsAny(normalized, ['invalid', 'incorrect', 'wrong'])) {
        return 'Invalid password.';
      }
    }

    if (_containsAny(normalized, ['session', 'expired'])) {
      return 'Session expired.';
    }

    if (_containsAny(normalized, ['enrollment', 'roll'])) {
      if (_containsAny(normalized, [
        'invalid',
        'not found',
        'does not exist',
      ])) {
        return 'Invalid enrollment number.';
      }
    }

    if (_containsAny(normalized, [
      'no internet',
      'socketexception',
      'network',
      'unreachable',
      'timed out',
    ])) {
      return 'No internet connection or server unreachable.';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'Server unavailable. Please try again later.';
    }

    if (message.isNotEmpty && normalized != 'login failed') {
      return message;
    }

    return 'Login failed. Please try again.';
  }

  String _extractBackendMessage(LoginResponse response) {
    final raw = response.raw;
    for (final key in ['message', 'error', 'detail', 'reason', 'info', 'msg']) {
      final value = raw[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return '';
  }

  int? _statusCodeFromResponse(LoginResponse response) {
    final raw = response.raw;
    final value = raw['statusCode'];
    if (value is int) {
      return value;
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  bool _containsAny(String value, List<String> needles) {
    for (final needle in needles) {
      if (value.contains(needle)) {
        return true;
      }
    }
    return false;
  }

  void _showMessage(String message, {bool isError = true}) {
    if (!mounted) {
      return;
    }

    final accentColor = isError
        ? const Color(0xFFFF6B3D)
        : const Color(0xFF38BDF8);
    final icon = isError ? Icons.error_outline : Icons.check_circle_outline;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 20),
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [const Color(0xFF0B1224), const Color(0xFF111A2E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: accentColor.withOpacity(0.6), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.35),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: accentColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B16),
      body: LiquidBackground(
        primaryColor: const Color(0xFF38BDF8),
        child: Stack(
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                // Logo/Title with glow
                                TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0, end: 1),
                                  duration: const Duration(milliseconds: 1500),
                                  curve: Curves.easeOut,
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ShaderMask(
                                            shaderCallback: (bounds) =>
                                                LinearGradient(
                                                  colors: [
                                                    const Color(0xFF7DD3FC),
                                                    const Color(0xFF3B82F6),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ).createShader(bounds),
                                            child: const Text(
                                              'IPU Ranks',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 48,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 18),

                                // Enrollment input
                                TweenAnimationBuilder<Offset>(
                                  tween: Tween(
                                    begin: const Offset(0, 40),
                                    end: Offset.zero,
                                  ),
                                  duration: const Duration(milliseconds: 1200),
                                  curve: Curves.easeOut,
                                  builder: (context, offset, child) {
                                    return Transform.translate(
                                      offset: offset,
                                      child: child,
                                    );
                                  },
                                  child: _buildGlassField(
                                    child: InputField(
                                      placeholder: 'Enter Enrollment No.',
                                      controller: _enrollmentController,
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Password input
                                TweenAnimationBuilder<Offset>(
                                  tween: Tween(
                                    begin: const Offset(0, 40),
                                    end: Offset.zero,
                                  ),
                                  duration: const Duration(milliseconds: 1300),
                                  curve: Curves.easeOut,
                                  builder: (context, offset, child) {
                                    return Transform.translate(
                                      offset: offset,
                                      child: child,
                                    );
                                  },
                                  child: _buildGlassField(
                                    child: InputField(
                                      placeholder: 'Enter Password',
                                      controller: _passwordController,
                                      isPassword: true,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Captcha
                                TweenAnimationBuilder<Offset>(
                                  tween: Tween(
                                    begin: const Offset(0, 40),
                                    end: Offset.zero,
                                  ),
                                  duration: const Duration(milliseconds: 1400),
                                  curve: Curves.easeOut,
                                  builder: (context, offset, child) {
                                    return Transform.translate(
                                      offset: offset,
                                      child: child,
                                    );
                                  },
                                  child: _buildGlassField(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Captcha',
                                              style: TextStyle(
                                                color: Colors.white.withOpacity(
                                                  0.6,
                                                ),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: _isCaptchaLoading
                                                  ? null
                                                  : _fetchCaptcha,
                                              icon: const Icon(
                                                Icons.refresh,
                                                color: Color(0xFF38BDF8),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Note: 3 failed attempts will temporarily lock your account.',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.55),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                            color: Colors.white.withOpacity(
                                              0.04,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(
                                                0.1,
                                              ),
                                              width: 1.2,
                                            ),
                                          ),
                                          child: Center(
                                            child: _isCaptchaLoading
                                                ? const CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                          Color(0xFF38BDF8),
                                                        ),
                                                  )
                                                : _captchaBytes != null
                                                ? Image.memory(
                                                    _captchaBytes!,
                                                    fit: BoxFit.contain,
                                                  )
                                                : Text(
                                                    _captchaError ??
                                                        'Tap refresh to load',
                                                    style: TextStyle(
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        InputField(
                                          placeholder: 'Enter Captcha',
                                          controller: _captchaController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 26),

                                // Login button
                                TweenAnimationBuilder<Offset>(
                                  tween: Tween(
                                    begin: const Offset(0, 40),
                                    end: Offset.zero,
                                  ),
                                  duration: const Duration(milliseconds: 1500),
                                  curve: Curves.easeOut,
                                  builder: (context, offset, child) {
                                    return Transform.translate(
                                      offset: offset,
                                      child: child,
                                    );
                                  },
                                  child: CustomButton(
                                    text: _isLoading
                                        ? (_showFetchingResults
                                              ? 'Fetching results...'
                                              : 'Logging in...')
                                        : 'Login',
                                    onPressed: _isLoading
                                        ? () {}
                                        : _handleLogin,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassField({
    required Widget child,
    EdgeInsetsGeometry padding = const EdgeInsets.all(20),
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.16), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38BDF8).withOpacity(0.18),
            blurRadius: 34,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
