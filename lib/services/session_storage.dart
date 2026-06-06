import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_response.dart';

class SessionStorage {
  static const String _loginResponseKey = 'login_response_json';

  static Future<void> saveLoginResponse(LoginResponse response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = jsonEncode(response.raw);
      await prefs.setString(_loginResponseKey, rawJson);
    } catch (_) {
      // Ignore cache failures to avoid blocking login flow.
    }
  }

  static Future<LoginResponse?> loadSavedLoginResponse() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rawJson = prefs.getString(_loginResponseKey);
      if (rawJson == null || rawJson.trim().isEmpty) {
        return null;
      }

      final decoded = jsonDecode(rawJson);
      if (decoded is! Map<String, dynamic>) {
        await prefs.remove(_loginResponseKey);
        return null;
      }

      final response = LoginResponse.fromJson(decoded);
      if (!response.success || response.groupedResult == null) {
        await prefs.remove(_loginResponseKey);
        return null;
      }

      return response;
    } catch (_) {
      await clearSavedLoginResponse();
      return null;
    }
  }

  static Future<void> clearSavedLoginResponse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginResponseKey);
  }

  static Future<void> clearAllSessionData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (_) {
      // Ignore failures to avoid blocking logout flow.
    }
  }
}
