import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/login_response.dart';
import 'http_client_factory.dart';

class AuthService {
  static const String _loginEndpoint =
      'https://ipuranks.abhii.app/api/v1/user/login';

  Future<LoginResponse> login({
    required String enrollmentNumber,
    required String password,
    required String captcha,
    required String captchaSessionId,
  }) async {
    try {
      final client = createHttpClient();

      final response = await client.post(
        Uri.parse(_loginEndpoint),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'x-session-id': captchaSessionId.trim(),
        },
        body: jsonEncode({
          'rollNo': enrollmentNumber.trim(),
          'password': password.trim(),
          'captcha': captcha.trim(),
        }),
      );

      print("LOGIN STATUS => ${response.statusCode}");
      print("LOGIN RESPONSE HEADERS => ${response.headers}");
      print("LOGIN RESPONSE => ${response.body}");

      client.close();

      final Map<String, dynamic> parsed = _parseResponseBody(response);

      return LoginResponse.fromJson(parsed);
    } on SocketException {
      return LoginResponse(
        success: false,
        message: 'No Internet Connection',
        result: null,
        groupedResult: null,
        raw: const {},
      );
    } catch (e) {
      return LoginResponse(
        success: false,
        message: e.toString(),
        result: null,
        groupedResult: null,
        raw: const {},
      );
    }
  }

  Map<String, dynamic> _parseResponseBody(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        final data = Map<String, dynamic>.from(decoded);
        data.putIfAbsent('statusCode', () => response.statusCode);
        if (data['message'] == null && response.body.trim().isNotEmpty) {
          data['message'] = response.body.trim();
        }
        return data;
      }
    } catch (_) {
      // Fall through to a safe, readable fallback map.
    }

    return {
      'success': false,
      'message': response.body.trim().isNotEmpty
          ? response.body.trim()
          : 'Login Failed',
      'statusCode': response.statusCode,
    };
  }
}
