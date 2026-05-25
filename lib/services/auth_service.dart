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

      final data = jsonDecode(response.body);

      return LoginResponse.fromJson(data);
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
}