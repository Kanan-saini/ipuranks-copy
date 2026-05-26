import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/result_model.dart';

class CreditCatalogService {
  static Future<void> loadCatalog() async {
    final jsonString = await rootBundle.loadString('assets/subject_credits.json');
    final Map<String, dynamic> raw = jsonDecode(jsonString);
    final catalog = <String, double>{};

    raw.forEach((key, value) {
      if (value is num) {
        catalog[key.toString()] = value.toDouble();
        return;
      }
      if (value is String) {
        final parsed = double.tryParse(value.trim());
        if (parsed != null) {
          catalog[key.toString()] = parsed;
        }
      }
    });

    CreditCatalog.setCatalog(catalog);
  }
}
