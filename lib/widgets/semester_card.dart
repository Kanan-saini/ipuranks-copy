import 'package:flutter/material.dart';
import '../models/result_model.dart';
import 'semester_subject_row.dart';

class SemesterCard extends StatelessWidget {
  final SemesterResult result;

  const SemesterCard({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final semesterLabel = result.semester > 0
        ? 'Semester ${result.semester}'
        : 'Semester';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0B132B).withOpacity(0.7),
            const Color(0xFF0F1B3D).withOpacity(0.55),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.14),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF38BDF8).withOpacity(0.14),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Color(0xFF7DD3FC)),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  semesterLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              _buildSummaryChip(
                'SGPA',
                _formatNumber(_resolveSgpa(), decimals: 2),
                const Color(0xFF3B82F6),
              ),
              const SizedBox(width: 8),
              _buildSummaryChip(
                'Credits',
                _resolveCreditsLabel(),
                const Color(0xFF38BDF8),
              ),
            ],
          ),
          children: [
            Column(
              children: List.generate(
                result.subjects.length,
                (index) => SemesterSubjectRow(
                  record: result.subjects[index],
                  index: index,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color.withOpacity(0.15),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
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

  String _formatNumber(double? value, {required int decimals}) {
    if (value == null) {
      return '-';
    }
    return value.toStringAsFixed(decimals);
  }

  double? _resolveSgpa() {
    if (result.calculatedSgpa != null) {
      return result.calculatedSgpa;
    }
    if (result.gpa != null && result.gpa! > 0) {
      return result.gpa;
    }
    return null;
  }

  String _resolveCreditsLabel() {
    final registered = result.registeredCredits ?? result.calculatedCredits;
    final secured = result.securedCredits;

    if (registered != null && registered > 0 && secured != null) {
      return '${secured.toStringAsFixed(0)}/${registered.toStringAsFixed(0)}';
    }

    final fallback = registered ?? result.credits;
    if (fallback != null && fallback > 0) {
      return fallback.toStringAsFixed(0);
    }

    return '-';
  }
}
