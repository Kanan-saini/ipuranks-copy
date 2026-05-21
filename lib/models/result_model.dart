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
