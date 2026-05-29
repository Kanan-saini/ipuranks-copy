import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static const String _defaultBaseUrl = 'https://ipuranks.abhii.app';

  static String get apiBaseUrl {
    final value = dotenv.env['API_BASE_URL']?.trim();
    if (value == null || value.isEmpty) {
      return _defaultBaseUrl;
    }

    if (value.endsWith('/')) {
      return value.substring(0, value.length - 1);
    }

    return value;
  }

  static String get apiKey => (dotenv.env['API_KEY'] ?? '').trim();

  static Uri buildUri(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$apiBaseUrl$normalizedPath');
  }
}
