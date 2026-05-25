import 'result_model.dart';

class LoginResponse {
  final bool success;
  final String message;
  final StudentResult? result;
  final GroupedResult? groupedResult;
  final Map<String, dynamic> raw;

  LoginResponse({
    required this.success,
    required this.message,
    required this.result,
    required this.groupedResult,
    required this.raw,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final success = _boolValue(json, [
      'success',
      'ok',
      'status',
    ]);
    final message = _stringValue(json, [
      'message',
      'error',
      'detail',
    ]);

    StudentResult? result;
    GroupedResult? groupedResult;
    final data = _mapValue(json, [
      'data',
      'result',
      'student',
      'user',
      'payload',
    ]);

    final records = _listValue(json, [
      'result',
      'results',
      'records',
      'subjects',
    ]);

    final nestedRecords = data != null
        ? _listValue(data, ['result', 'results', 'records', 'subjects'])
        : const [];

    final resolvedRecords = records.isNotEmpty ? records : nestedRecords;

    if (resolvedRecords.isNotEmpty) {
      final parsedRecords = resolvedRecords
          .whereType<Map<String, dynamic>>()
          .map(FlatResultRecord.fromJson)
          .toList();

      groupedResult = GroupedResult.fromRecords(parsedRecords);
    }

    if (data != null) {
      result = StudentResult.fromJson(data);
    } else if (_looksLikeResult(json)) {
      result = StudentResult.fromJson(json);
    }

    return LoginResponse(
      success: success,
      message: message,
      result: result,
      groupedResult: groupedResult,
      raw: json,
    );
  }
}

String _stringValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    if (value != null) {
      return value.toString();
    }
  }
  return '';
}

bool _boolValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is bool) {
      return value;
    }
    if (value is String) {
      final normalized = value.toLowerCase();
      if (normalized == 'true' || normalized == 'success' || normalized == 'ok') {
        return true;
      }
      if (normalized == 'false' || normalized == 'error' || normalized == 'failed') {
        return false;
      }
    }
    if (value is num) {
      return value != 0;
    }
  }
  return false;
}

Map<String, dynamic>? _mapValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is Map<String, dynamic>) {
      return value;
    }
  }
  return null;
}

List<dynamic> _listValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is List) {
      return value;
    }
  }
  return const [];
}

bool _looksLikeResult(Map<String, dynamic> json) {
  return json.containsKey('subjects') ||
      json.containsKey('subjectResults') ||
      json.containsKey('totalMarks') ||
      json.containsKey('sgpa');
}
