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
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
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
                'GPA',
                _formatNumber(result.gpa, decimals: 2),
                const Color(0xFF6366f1),
              ),
              const SizedBox(width: 8),
              _buildSummaryChip(
                'Credits',
                _formatNumber(result.credits, decimals: 0),
                const Color(0xFF84cc16),
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
}
