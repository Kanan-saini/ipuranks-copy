class StudentResult {
  final String enrollmentNumber;
  final String studentName;
  final int totalMarks;
  final int maxMarks;
  final double percentage;
  final int creditMarks;
  final int maxCreditMarks;
  final double sgpa;
  final List<Subject> subjects;

  StudentResult({
    required this.enrollmentNumber,
    required this.studentName,
    required this.totalMarks,
    required this.maxMarks,
    required this.percentage,
    required this.creditMarks,
    required this.maxCreditMarks,
    required this.sgpa,
    required this.subjects,
  });

  factory StudentResult.fromJson(Map<String, dynamic> json) {
    final enrollmentNumber = _stringValue(json, [
      'enrollmentNumber',
      'enrollment_number',
      'enrollmentNo',
      'enrollment_no',
      'rollNo',
      'roll_no',
    ]);
    final studentName = _stringValue(json, [
      'studentName',
      'student_name',
      'name',
      'fullName',
      'full_name',
    ]);
    final totalMarks = _intValue(json, [
      'totalMarks',
      'total_marks',
      'marksObtained',
      'marks_obtained',
    ]);
    final maxMarks = _intValue(json, [
      'maxMarks',
      'max_marks',
      'totalMaxMarks',
      'total_max_marks',
    ]);
    final creditMarks = _intValue(json, [
      'creditMarks',
      'credit_marks',
      'creditsObtained',
      'credits_obtained',
    ]);
    final maxCreditMarks = _intValue(json, [
      'maxCreditMarks',
      'max_credit_marks',
      'totalCreditMarks',
      'total_credit_marks',
    ]);
    final sgpa = _doubleValue(json, [
      'sgpa',
      'SGPA',
    ]);

    final subjectsRaw = _listValue(json, [
      'subjects',
      'subjectResults',
      'subject_results',
      'papers',
      'results',
    ]);
    final subjects = subjectsRaw
        .whereType<Map<String, dynamic>>()
        .map(Subject.fromJson)
        .toList();

    final percentageFromJson = _doubleValue(json, [
      'percentage',
      'percent',
      'percentageScore',
    ]);
    final computedPercentage = (totalMarks > 0 && maxMarks > 0)
        ? (totalMarks / maxMarks) * 100
        : 0.0;

    return StudentResult(
      enrollmentNumber: enrollmentNumber,
      studentName: studentName,
      totalMarks: totalMarks,
      maxMarks: maxMarks,
      percentage:
          percentageFromJson > 0 ? percentageFromJson : computedPercentage,
      creditMarks: creditMarks,
      maxCreditMarks: maxCreditMarks,
      sgpa: sgpa,
      subjects: subjects,
    );
  }
}

class Subject {
  final String name;
  final int credits;
  final int internalMarks;
  final int externalMarks;
  final int totalMarks;
  final String grade;
  final String paperId;
  final bool isHighest;

  Subject({
    required this.name,
    required this.credits,
    required this.internalMarks,
    required this.externalMarks,
    required this.totalMarks,
    required this.grade,
    required this.paperId,
    this.isHighest = false,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: _stringValue(json, [
        'name',
        'subject',
        'subjectName',
        'subject_name',
        'paperName',
      ]),
      credits: _intValue(json, [
        'credits',
        'credit',
      ]),
      internalMarks: _intValue(json, [
        'internalMarks',
        'internal_marks',
        'internal',
      ]),
      externalMarks: _intValue(json, [
        'externalMarks',
        'external_marks',
        'external',
      ]),
      totalMarks: _intValue(json, [
        'totalMarks',
        'total_marks',
        'total',
      ]),
      grade: _stringValue(json, [
        'grade',
        'letterGrade',
        'letter_grade',
      ]),
      paperId: _stringValue(json, [
        'paperId',
        'paper_id',
        'paperCode',
        'paper_code',
      ]),
      isHighest: _boolValue(json, [
        'isHighest',
        'highest',
        'topper',
      ]),
    );
  }
}

class FlatResultRecord {
  final String rollNumber;
  final String studentName;
  final String programName;
  final String instituteName;
  final String admissionYear;
  final int semester;
  final String paperCode;
  final String paperName;
  final int? internalMarks;
  final int? externalMarks;
  final int? finalMarks;
  final String status;
  final String resultMonth;
  final String resultYear;
  final String declaredDate;
  final double? gpa;
  final double? credits;

  FlatResultRecord({
    required this.rollNumber,
    required this.studentName,
    required this.programName,
    required this.instituteName,
    required this.admissionYear,
    required this.semester,
    required this.paperCode,
    required this.paperName,
    required this.internalMarks,
    required this.externalMarks,
    required this.finalMarks,
    required this.status,
    required this.resultMonth,
    required this.resultYear,
    required this.declaredDate,
    required this.gpa,
    required this.credits,
  });

  factory FlatResultRecord.fromJson(Map<String, dynamic> json) {
    return FlatResultRecord(
      rollNumber: _stringValue(json, ['nrollno', 'rollNo', 'roll_no']),
      studentName: _stringValue(json, ['stname', 'studentName', 'name']),
      programName: _stringValue(json, ['prgname', 'programName']),
      instituteName: _stringValue(json, ['iname', 'instituteName']),
      admissionYear: _stringValue(json, ['yoa', 'byoa', 'admissionYear', 'batch']),
      semester: _intValue(json, ['euno', 'semester', 'sem']),
      paperCode: _stringValue(json, ['papercode', 'paperCode', 'paper_code']),
      paperName: _stringValue(json, ['papername', 'paperName', 'subjectName']),
      internalMarks: _nullableIntValue(json, ['minorprint', 'internal', 'internalMarks']),
      externalMarks: _nullableIntValue(json, ['majorprint', 'external', 'externalMarks']),
      finalMarks: _nullableIntValue(json, ['moderatedprint', 'finalMarks', 'totalMarks']),
      status: _stringValue(json, ['statuscode', 'status', 'resultStatus']),
      resultMonth: _stringValue(json, ['rmonth', 'resultMonth']),
      resultYear: _stringValue(json, ['ryear', 'resultYear']),
      declaredDate: _stringValue(json, ['declareddate', 'declaredDate']),
      gpa: _nullableDoubleValue(json, ['eugpa', 'gpa', 'sgpa']),
      credits: _nullableDoubleValue(json, [
        'credits',
        'credit',
        'papercredit',
        'paperCredit',
        'subjectcredit',
        'subjectCredit',
        'crd',
      ]),
    );
  }
}

class StudentInfo {
  final String name;
  final String rollNumber;
  final String programName;
  final String instituteName;
  final String admissionYear;

  StudentInfo({
    required this.name,
    required this.rollNumber,
    required this.programName,
    required this.instituteName,
    required this.admissionYear,
  });

  factory StudentInfo.fromRecord(FlatResultRecord record) {
    return StudentInfo(
      name: record.studentName,
      rollNumber: record.rollNumber,
      programName: record.programName,
      instituteName: record.instituteName,
      admissionYear: record.admissionYear,
    );
  }
}

class SemesterResult {
  final int semester;
  final double? gpa;
  final double? credits;
  final List<FlatResultRecord> subjects;
  final double? calculatedSgpa;
  final double? calculatedCredits;
  final double? registeredCredits;
  final double? securedCredits;
  final double totalMarks;
  final double maxMarks;
  final double percentage;

  SemesterResult({
    required this.semester,
    required this.gpa,
    required this.credits,
    required this.subjects,
    required this.calculatedSgpa,
    required this.calculatedCredits,
    required this.registeredCredits,
    required this.securedCredits,
    required this.totalMarks,
    required this.maxMarks,
    required this.percentage,
  });

  factory SemesterResult.fromRecords(
    int semester,
    List<FlatResultRecord> records,
  ) {
    double? gpa;
    double? credits;

    for (final record in records) {
      gpa ??= record.gpa;
      credits ??= record.credits;
    }

    final subjectsForDisplay = List<FlatResultRecord>.from(records)
      ..sort((a, b) => a.paperCode.compareTo(b.paperCode));
    final metrics = _calculateSemesterMetrics(records);

    _debugLog(
      'Credits debug - sem $semester | '
      'sgpaCredits=${metrics.semesterCredits.toStringAsFixed(1)} '
      'registered=${metrics.registeredCredits.toStringAsFixed(1)} '
      'secured=${metrics.securedCredits.toStringAsFixed(1)} '
      'subjects=${metrics.subjectCount} '
      'missingCatalog=${metrics.missingCatalogCodes.isEmpty ? "none" : metrics.missingCatalogCodes.join(", ")}',
    );

    return SemesterResult(
      semester: semester,
      gpa: gpa,
      credits: credits,
      subjects: subjectsForDisplay,
      calculatedSgpa: metrics.sgpa,
      calculatedCredits: metrics.semesterCredits,
      registeredCredits: metrics.registeredCredits,
      securedCredits: metrics.securedCredits,
      totalMarks: metrics.totalMarks,
      maxMarks: metrics.maxMarks,
      percentage: metrics.percentage,
    );
  }
}

class GroupedResult {
  final StudentInfo student;
  final List<SemesterResult> semesters;

  GroupedResult({
    required this.student,
    required this.semesters,
  });

  ResultSummary get summary {
    final validSemesters = semesters.where(
      (semester) => _resolvedSemesterCredits(semester) > 0,
    );

    double totalCredits = 0;
    double weightedSgpa = 0;
    final programTotals = _calculateProgramCreditTotals(semesters);

    for (final semester in validSemesters) {
      final credits = _resolvedSemesterCredits(semester);
      final sgpa = semester.calculatedSgpa ?? 0;
      if (credits <= 0) {
        continue;
      }
      totalCredits += credits;
      weightedSgpa += sgpa * credits;
    }

    final cgpa = totalCredits > 0 ? weightedSgpa / totalCredits : 0.0;

    _debugLog(
      'Credits debug - cumulative | '
      'sgpaCredits=${totalCredits.toStringAsFixed(1)} '
      'registered=${programTotals.registeredCredits.toStringAsFixed(1)} '
      'secured=${programTotals.securedCredits.toStringAsFixed(1)} '
      'uniqueSubjects=${programTotals.subjectCount} '
      'missingCatalog=${programTotals.missingCatalogCodes.isEmpty ? "none" : programTotals.missingCatalogCodes.join(", ")} '
      'semesters=${validSemesters.length}',
    );

    return ResultSummary(
      cgpa: cgpa,
      totalCredits:
          programTotals.securedCredits > 0 ? programTotals.securedCredits : 0.0,
      semestersCompleted: validSemesters.length,
    );
  }

  factory GroupedResult.fromRecords(List<FlatResultRecord> records) {
    if (records.isEmpty) {
      return GroupedResult(
        student: StudentInfo(
          name: '',
          rollNumber: '',
          programName: '',
          instituteName: '',
          admissionYear: '',
          
        ),
        semesters: const [],
      );
    }

    final grouped = <int, List<FlatResultRecord>>{};
    for (final record in records) {
      final semesterKey = record.semester > 0 ? record.semester : 0;
      grouped.putIfAbsent(semesterKey, () => []).add(record);
    }

    final semesters = grouped.entries
        .map((entry) => SemesterResult.fromRecords(entry.key, entry.value))
        .toList()
      ..sort((a, b) => a.semester.compareTo(b.semester));

    return GroupedResult(
      student: StudentInfo.fromRecord(records.first),
      semesters: semesters,
    );
  }
}

class ResultSummary {
  final double? cgpa;
  final double? totalCredits;
  final int semestersCompleted;

  ResultSummary({
    required this.cgpa,
    required this.totalCredits,
    required this.semestersCompleted,
  });
}

class CreditCatalog {
  static Map<String, double> _catalog = const {};

  static void setCatalog(Map<String, double> catalog) {
    _catalog = catalog;
  }

  static double? lookup(String code) {
    if (_catalog.isEmpty) {
      return null;
    }
    final normalized = code.trim().toUpperCase();
    if (normalized.isEmpty) {
      return null;
    }
    return _catalog[normalized];
  }
}

class CumulativeData {
  final String semester;
  final String marks;
  final String percentage;
  final String gpa;

  const CumulativeData({
    required this.semester,
    required this.marks,
    required this.percentage,
    required this.gpa,
  });
}

class LineChartPoint {
  final String name;
  final double sgpa;
  final double percentage;

  const LineChartPoint({
    required this.name,
    required this.sgpa,
    required this.percentage,
  });
}

class RadarChartPoint {
  final String semester;
  final double performance;

  const RadarChartPoint({
    required this.semester,
    required this.performance,
  });
}

class ChartData {
  final List<LineChartPoint> lineChart;
  final List<RadarChartPoint> radarChart;

  const ChartData({
    required this.lineChart,
    required this.radarChart,
  });
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

int _intValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];

    if (value is int) return value;

    if (value is double) return value.round();

    if (value is String) {
      final cleaned =
          value.trim().replaceAll(RegExp(r'[^0-9]'), '');

      if (cleaned.isNotEmpty) {
        final parsed = int.tryParse(cleaned);
        if (parsed != null) {
          return parsed;
        }
      }

      final parsedDouble = double.tryParse(cleaned);
      if (parsedDouble != null) {
        return parsedDouble.round();
      }
    }
  }

  return 0;
}

int? _nullableIntValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];

    if (value == null) continue;

    if (value is int) return value;

    if (value is double) return value.round();

    if (value is String) {
      final trimmed = value.trim();

      if (trimmed.isEmpty) continue;

      // Handles: 40*, 42#, 55A etc.
      final cleaned = trimmed.replaceAll(RegExp(r'[^0-9]'), '');

      if (cleaned.isNotEmpty) {
        final parsed = int.tryParse(cleaned);
        if (parsed != null) {
          return parsed;
        }
      }
    }
  }

  return null;
}

double _doubleValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
    }
  }
  return 0.0;
}

double? _nullableDoubleValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value == null) {
      continue;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      final parsed = double.tryParse(trimmed);
      if (parsed != null) {
        return parsed;
      }
    }
  }
  return null;
}

double _resolvedSemesterCredits(SemesterResult semester) {
  return semester.calculatedCredits ?? 0;
}

class _SemesterMetrics {
  final double totalMarks;
  final double maxMarks;
  final double percentage;
  final double semesterCredits;
  final double registeredCredits;
  final double securedCredits;
  final double sgpa;
  final List<String> missingCatalogCodes;
  final int subjectCount;

  const _SemesterMetrics({
    required this.totalMarks,
    required this.maxMarks,
    required this.percentage,
    required this.semesterCredits,
    required this.registeredCredits,
    required this.securedCredits,
    required this.sgpa,
    required this.missingCatalogCodes,
    required this.subjectCount,
  });
}

class _ProgramCreditTotals {
  final double registeredCredits;
  final double securedCredits;
  final int subjectCount;
  final List<String> missingCatalogCodes;

  const _ProgramCreditTotals({
    required this.registeredCredits,
    required this.securedCredits,
    required this.subjectCount,
    required this.missingCatalogCodes,
  });
}

double _gradePointFromMarks(double marks) {
  if (marks >= 90) {
    return 10;
  }
  if (marks >= 75) {
    return 9;
  }
  if (marks >= 65) {
    return 8;
  }
  if (marks >= 55) {
    return 7;
  }
  if (marks >= 50) {
    return 6;
  }
  if (marks >= 45) {
    return 5;
  }
  if (marks >= 40) {
    return 4;
  }
  return 0;
}

double _resolveRecordCredits(FlatResultRecord record) {
  final lookupCredits = CreditCatalog.lookup(record.paperCode);
  if (lookupCredits != null) {
    return lookupCredits;
  }
  final normalized = record.paperCode.trim().toUpperCase();
  if (normalized.endsWith('P') || normalized.contains('LAB')) {
    return 1;
  }
  return 4;
}

double? _catalogCreditsOrNull(FlatResultRecord record) {
  return CreditCatalog.lookup(record.paperCode);
}

String _normalizedPaperCode(FlatResultRecord record) {
  return record.paperCode.trim().toUpperCase();
}

void _debugLog(String message) {
  assert(() {
    // Debug-only logging to avoid noisy output in release builds.
    // ignore: avoid_print
    print(message);
    return true;
  }());
}

bool _boolValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = json[key];
    if (value is bool) {
      return value;
    }
    if (value is String) {
      if (value.toLowerCase() == 'true') {
        return true;
      }
      if (value.toLowerCase() == 'false') {
        return false;
      }
    }
    if (value is num) {
      return value != 0;
    }
  }
  return false;
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

int? _resolveFinalMarks(FlatResultRecord record) {
  return record.finalMarks;
}

bool _isPassed(FlatResultRecord record) {
  final marks = _resolveFinalMarks(record) ?? 0;
  return marks >= 40;
}

int _attemptTimestamp(FlatResultRecord record) {
  final parsed = DateTime.tryParse(record.declaredDate);
  if (parsed != null) {
    return parsed.millisecondsSinceEpoch;
  }
  final year = int.tryParse(record.resultYear) ?? 0;
  final month = int.tryParse(record.resultMonth) ?? 0;
  final safeMonth = month > 0 ? month : 1;
  return DateTime.utc(year, safeMonth, 1).millisecondsSinceEpoch;
}

List<FlatResultRecord> _filterUniqueSubjects(List<FlatResultRecord> records) {
  final subjectMap = <String, FlatResultRecord>{};
  for (final record in records) {
    final key = record.paperCode;
    final existing = subjectMap[key];
    if (existing == null) {
      subjectMap[key] = record;
      continue;
    }
    final existingTimestamp = _attemptTimestamp(existing);
    final currentTimestamp = _attemptTimestamp(record);
    if (currentTimestamp >= existingTimestamp) {
      subjectMap[key] = record;
    }
  }
  return subjectMap.values.toList();
}

_SemesterMetrics _calculateSemesterMetrics(
    List<FlatResultRecord> records) {
  final uniqueSubjects = _filterUniqueSubjects(records);

  double totalMarks = 0;
  double totalCredits = 0;
  double registeredCredits = 0;
  double securedCredits = 0;
  double totalWeightedGp = 0;
  final missingCatalogCodes = <String>{};

  for (final record in uniqueSubjects) {
    final marks = (_resolveFinalMarks(record) ?? 0).toDouble();
    final creditsForSgpa = _resolveRecordCredits(record);
    final catalogCredits = _catalogCreditsOrNull(record);

    totalMarks += marks;
    totalCredits += creditsForSgpa;

    if (catalogCredits != null) {
      registeredCredits += catalogCredits;
      // Secured credits exclude failed subjects; registered credits include all.
      if (_isPassed(record)) {
        securedCredits += catalogCredits;
      }
    } else {
      missingCatalogCodes.add(_normalizedPaperCode(record));
    }

    final gradePoint =
        marks >= 40 ? _gradePointFromMarks(marks) : 0.0;

    totalWeightedGp += gradePoint * creditsForSgpa;
  }

  final maxMarks = uniqueSubjects.length * 100.0;

  final percentage =
      maxMarks > 0 ? (totalMarks / maxMarks) * 100 : 0.0;

  final sgpa =
      totalCredits > 0 ? totalWeightedGp / totalCredits : 0.0;

  return _SemesterMetrics(
    totalMarks: totalMarks,
    maxMarks: maxMarks,
    percentage: percentage,
    semesterCredits: totalCredits,
    registeredCredits: registeredCredits,
    securedCredits: securedCredits,
    sgpa: sgpa,
    missingCatalogCodes: missingCatalogCodes.toList()..sort(),
    subjectCount: uniqueSubjects.length,
  );
}

_ProgramCreditTotals _calculateProgramCreditTotals(
  List<SemesterResult> semesters,
) {
  final allRecords = semesters.expand((semester) => semester.subjects).toList();
  final uniqueSubjects = _filterUniqueSubjects(allRecords);
  double registeredCredits = 0;
  double securedCredits = 0;
  final missingCatalogCodes = <String>{};

  for (final record in uniqueSubjects) {
    final catalogCredits = _catalogCreditsOrNull(record);
    if (catalogCredits != null) {
      registeredCredits += catalogCredits;
      if (_isPassed(record)) {
        securedCredits += catalogCredits;
      }
    } else {
      missingCatalogCodes.add(_normalizedPaperCode(record));
    }
  }

  return _ProgramCreditTotals(
    registeredCredits: registeredCredits,
    securedCredits: securedCredits,
    subjectCount: uniqueSubjects.length,
    missingCatalogCodes: missingCatalogCodes.toList()..sort(),
  );
}

List<SemesterResult> _sortedSemesters(List<SemesterResult> semesters) {
  final ordered = List<SemesterResult>.from(semesters);
  ordered.sort((a, b) => a.semester.compareTo(b.semester));
  return ordered;
}

List<double> _calculateProgressiveCgpa(List<SemesterResult> semesters) {
  double totalCredits = 0;
  double weightedSgpa = 0;

  return semesters.map((semester) {
    final credits = _resolvedSemesterCredits(semester);
    final sgpa = semester.calculatedSgpa ?? 0;

    if (credits > 0) {
      totalCredits += credits;
      weightedSgpa += sgpa * credits;
    }

    return totalCredits > 0 ? weightedSgpa / totalCredits : 0.0;
  }).toList();
}

List<CumulativeData> calculateSemesterCumulativeData(
  List<SemesterResult> semesters,
) {
  final ordered = _sortedSemesters(semesters);
  final progressiveCgpa = _calculateProgressiveCgpa(ordered);

  return ordered.asMap().entries.map((entry) {
    final index = entry.key;
    final prevSems = ordered.sublist(0, index + 1);
    final totalMarks =
        prevSems.fold<double>(0, (sum, s) => sum + s.totalMarks);
    final maxMarks =
        prevSems.fold<double>(0, (sum, s) => sum + s.maxMarks);
    final percentage = maxMarks > 0 ? (totalMarks / maxMarks) * 100 : 0.0;
    final cgpa = progressiveCgpa[index];
    final semLabel = index == 0
        ? 'Sem 1'
        : 'Sem ${List.generate(index + 1, (i) => i + 1).join('+')}';

    return CumulativeData(
      semester: semLabel,
      marks: '${totalMarks.toStringAsFixed(0)} / ${maxMarks.toStringAsFixed(0)}',
      percentage: percentage.toStringAsFixed(2),
      gpa: cgpa.toStringAsFixed(2),
    );
  }).toList();
}

List<CumulativeData> calculateYearCumulativeData(
  List<SemesterResult> semesters,
) {
  final ordered = _sortedSemesters(semesters);
  final progressiveCgpa = _calculateProgressiveCgpa(ordered);
  final years = <List<SemesterResult>>[];

  for (var i = 0; i < ordered.length; i += 2) {
    years.add(ordered.sublist(i, (i + 2).clamp(0, ordered.length)));
  }

  return years.asMap().entries.map((entry) {
    final yearIndex = entry.key;
    final allSemsUpToYear =
        ordered.sublist(0, ((yearIndex + 1) * 2).clamp(0, ordered.length));
    final totalMarks =
        allSemsUpToYear.fold<double>(0, (sum, s) => sum + s.totalMarks);
    final maxMarks =
        allSemsUpToYear.fold<double>(0, (sum, s) => sum + s.maxMarks);
    final percentage = maxMarks > 0 ? (totalMarks / maxMarks) * 100 : 0.0;
    final lastSemIndex =
        ((yearIndex + 1) * 2 - 1).clamp(0, ordered.length - 1);
    final cgpa = progressiveCgpa[lastSemIndex];
    final yearLabel = yearIndex == 0
        ? 'Year 1'
        : 'Year ${List.generate(yearIndex + 1, (i) => i + 1).join('+')}';

    return CumulativeData(
      semester: yearLabel,
      marks: '${totalMarks.toStringAsFixed(0)} / ${maxMarks.toStringAsFixed(0)}',
      percentage: percentage.toStringAsFixed(2),
      gpa: cgpa.toStringAsFixed(2),
    );
  }).toList();
}

List<CumulativeData> calculateCumulativeData(List<SemesterResult> semesters) {
  return calculateSemesterCumulativeData(semesters);
}

ChartData generateChartData(List<SemesterResult> semesters) {
  final ordered = _sortedSemesters(semesters);
  return ChartData(
    lineChart: ordered
        .map(
          (sem) => LineChartPoint(
            name: 'Sem ${sem.semester}',
            sgpa: double.parse((sem.calculatedSgpa ?? 0).toStringAsFixed(2)),
            percentage: double.parse(sem.percentage.toStringAsFixed(2)),
          ),
        )
        .toList(),
    radarChart: ordered
        .map(
          (sem) => RadarChartPoint(
            semester: 'S${sem.semester}',
            performance:
                double.parse((sem.calculatedSgpa ?? 0).toStringAsFixed(1)),
          ),
        )
        .toList(),
  );
}

