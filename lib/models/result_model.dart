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

  SemesterResult({
    required this.semester,
    required this.gpa,
    required this.credits,
    required this.subjects,
    required this.calculatedSgpa,
    required this.calculatedCredits,
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

    final calculatedCredits = _calculateSemesterCredits(records);
    final calculatedSgpa = _calculateSemesterSgpa(records, calculatedCredits);

    return SemesterResult(
      semester: semester,
      gpa: gpa,
      credits: credits,
      subjects: records,
      calculatedSgpa: calculatedSgpa,
      calculatedCredits: calculatedCredits,
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

    for (final semester in validSemesters) {
      final credits = _resolvedSemesterCredits(semester);
      final sgpa = semester.calculatedSgpa ?? _positiveOrNull(semester.gpa);
      if (credits <= 0 || sgpa == null) {
        continue;
      }
      totalCredits += credits;
      weightedSgpa += sgpa * credits;
    }

    final cgpa = totalCredits > 0 ? weightedSgpa / totalCredits : null;

    return ResultSummary(
      cgpa: cgpa,
      totalCredits: totalCredits > 0 ? totalCredits : null,
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
      ..sort((a, b) {
        if (a.semester == 0) {
          return 1;
        }
        if (b.semester == 0) {
          return -1;
        }
        return a.semester.compareTo(b.semester);
      });

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
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.round();
    }
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) {
        return parsed;
      }
      final parsedDouble = double.tryParse(value);
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
    if (value == null) {
      continue;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.round();
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      final parsed = int.tryParse(trimmed);
      if (parsed != null) {
        return parsed;
      }
      final parsedDouble = double.tryParse(trimmed);
      if (parsedDouble != null) {
        return parsedDouble.round();
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

int? _resolveFinalMarks(FlatResultRecord record) {
  if (record.finalMarks != null) {
    return record.finalMarks;
  }
  if (record.internalMarks == null || record.externalMarks == null) {
    return null;
  }
  return record.internalMarks! + record.externalMarks!;
}

double _resolvedSemesterCredits(SemesterResult semester) {
  final calculated = semester.calculatedCredits;
  if (calculated != null && calculated > 0) {
    return calculated;
  }
  final rawCredits = semester.credits ?? 0;
  return rawCredits > 0 ? rawCredits : 0;
}

double? _calculateSemesterCredits(List<FlatResultRecord> records) {
  double totalCredits = 0;
  for (final record in records) {
    final credits = _resolveRecordCredits(record);
    if (credits > 0) {
      totalCredits += credits;
    }
  }
  if (totalCredits <= 0) {
    return null;
  }
  return totalCredits;
}

double? _calculateSemesterSgpa(
  List<FlatResultRecord> records,
  double? totalCredits,
) {
  if (totalCredits == null || totalCredits <= 0) {
    return null;
  }

  double totalGradePoints = 0;

  for (final record in records) {
    final credits = _resolveRecordCredits(record);
    if (credits <= 0) {
      continue;
    }
    final marks = _resolveFinalMarks(record);
    if (marks == null) {
      continue;
    }
    final gradePoint = _gradePointFromMarks(marks);
    totalGradePoints += gradePoint * credits;
  }

  if (totalGradePoints <= 0) {
    return null;
  }

  return totalGradePoints / totalCredits;
}

double _gradePointFromMarks(int marks) {
  if (marks >= 90) {
    return 10;
  }
  if (marks >= 80) {
    return 9;
  }
  if (marks >= 70) {
    return 8;
  }
  if (marks >= 60) {
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
  final directCredits = record.credits ?? 0;
  if (directCredits > 0) {
    return directCredits;
  }
  final lookupCredits = CreditCatalog.lookup(record.paperCode) ?? 0;
  return lookupCredits > 0 ? lookupCredits : 0;
}

double? _positiveOrNull(double? value) {
  if (value == null) {
    return null;
  }
  return value > 0 ? value : null;
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

// Dummy data - Real student result
final dummyResult = StudentResult(
  enrollmentNumber: '01013303122',
  studentName: 'Abhishek Tiwari',
  totalMarks: 685,
  maxMarks: 1000,
  percentage: 68.5,
  creditMarks: 1552,
  maxCreditMarks: 2500,
  sgpa: 6.96,
  subjects: [
    Subject(
      name: 'Electrical Science Lab',
      credits: 1,
      internalMarks: 36,
      externalMarks: 56,
      totalMarks: 92,
      grade: 'O',
      paperId: '31159',
      isHighest: true,
    ),
    Subject(
      name: 'Engineering Graphics-I',
      credits: 2,
      internalMarks: 33,
      externalMarks: 51,
      totalMarks: 84,
      grade: 'A+',
      paperId: '31157',
    ),
    Subject(
      name: 'Applied Chemistry',
      credits: 1,
      internalMarks: 36,
      externalMarks: 55,
      totalMarks: 91,
      grade: 'O',
      paperId: '31155',
    ),
    Subject(
      name: 'Physics - I Lab',
      credits: 1,
      internalMarks: 34,
      externalMarks: 49,
      totalMarks: 83,
      grade: 'A+',
      paperId: '31151',
    ),
    Subject(
      name: 'Manufacturing Process',
      credits: 4,
      internalMarks: 20,
      externalMarks: 48,
      totalMarks: 68,
      grade: 'A',
      paperId: '31119',
    ),
    Subject(
      name: 'Communications Skills',
      credits: 3,
      internalMarks: 19,
      externalMarks: 56,
      totalMarks: 75,
      grade: 'A+',
      paperId: '31113',
    ),
    Subject(
      name: 'Applied Mathematics - I',
      credits: 4,
      internalMarks: 14,
      externalMarks: 31,
      totalMarks: 45,
      grade: 'C',
      paperId: '31111',
    ),
    Subject(
      name: 'Electrical Science',
      credits: 3,
      internalMarks: 20,
      externalMarks: 20,
      totalMarks: 40,
      grade: 'P',
      paperId: '31107',
    ),
    Subject(
      name: 'Applied Physics - I',
      credits: 3,
      internalMarks: 18,
      externalMarks: 21,
      totalMarks: 40,
      grade: 'P',
      paperId: '31105',
    ),
    Subject(
      name: 'Applied Chemistry',
      credits: 3,
      internalMarks: 17,
      externalMarks: 50,
      totalMarks: 67,
      grade: 'A',
      paperId: '31103',
    ),
  ],
);
