import 'package:flutter/material.dart';
import '../models/result_model.dart';

class SemesterSubjectRow extends StatelessWidget {
  final FlatResultRecord record;
  final int index;

  const SemesterSubjectRow({
    Key? key,
    required this.record,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 250 + (index * 80)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 10),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF0B132B).withOpacity(0.75),
              const Color(0xFF0F1B3D).withOpacity(0.55),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: Colors.white.withOpacity(0.12),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B82F6).withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF38BDF8),
                        Color(0xFF3B82F6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.paperName.isNotEmpty
                            ? record.paperName
                            : 'Unnamed Subject',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        record.paperCode.isNotEmpty
                            ? record.paperCode
                            : 'Code: N/A',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(record.finalMarks),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildMarkChip('Internal', record.internalMarks, const Color(0xFF3B82F6)),
                _buildMarkChip('External', record.externalMarks, const Color(0xFF7C3AED)),
                _buildMarkChip('Final', record.finalMarks, const Color(0xFF38BDF8)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkChip(String label, int? value, Color color) {
    final displayValue = value == null ? '-' : value.toString();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(0.15),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            displayValue,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(int? finalMarks) {
    final grade = finalMarks == null
        ? ''
        : _marksToGrade(finalMarks.toDouble());
    final label = grade.isEmpty ? 'N/A' : grade;
    final color = _gradeColor(grade);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(0.2),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  String _gradeFromStatus(String raw) {
    if (raw.isEmpty) {
      return '';
    }

    final upper = raw.toUpperCase();
    if (upper == 'PASS') {
      return 'P';
    }
    if (upper == 'FAIL') {
      return 'F';
    }
    if (upper == 'P' || upper == 'F') {
      return upper;
    }

    final value = double.tryParse(raw);
    if (value == null) {
      return upper;
    }

    if (value <= 10) {
      return _sgpaToGrade(value);
    }

    return _marksToGrade(value);
  }

  String _marksToGrade(double marks) {
    if (marks >= 90 && marks <= 100) return 'O';
    if (marks >= 75 && marks <= 89) return 'A+';
    if (marks >= 65 && marks <= 74) return 'A';
    if (marks >= 55 && marks <= 64) return 'B+';
    if (marks >= 50 && marks <= 54) return 'B';
    if (marks >= 45 && marks <= 49) return 'C';
    if (marks >= 40 && marks <= 44) return 'P';
    return 'F';
  }

  String _sgpaToGrade(double sgpa) {
    if (sgpa >= 9.0) return 'O';
    if (sgpa >= 7.5) return 'A+';
    if (sgpa >= 6.5) return 'A';
    if (sgpa >= 5.5) return 'B+';
    if (sgpa >= 5.0) return 'B';
    if (sgpa >= 4.5) return 'C';
    if (sgpa >= 4.0) return 'P';
    return 'F';
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'O':
        return const Color(0xFF34D399);
      case 'A+':
        return const Color(0xFF86EFAC);
      case 'A':
        return const Color(0xFF5EEAD4);
      case 'B+':
        return const Color(0xFFFBBF24);
      case 'B':
        return const Color(0xFFF59E0B);
      case 'C':
        return const Color(0xFFF59E0B);
      case 'P':
        return const Color(0xFFFB7185);
      case 'F':
        return const Color(0xFFF43F5E);
      default:
        return const Color(0xFF94A3B8);
    }
  }
}
