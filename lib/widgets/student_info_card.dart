import 'package:flutter/material.dart';
import '../models/result_model.dart';

class StudentInfoCard extends StatelessWidget {
  final StudentInfo info;
  final ResultSummary? summary;

  const StudentInfoCard({
    Key? key,
    required this.info,
    this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0B132B).withOpacity(0.75),
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
            color: const Color(0xFF38BDF8).withOpacity(0.18),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _displayValue(info.name).toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
          if (summary != null) ...[
            const SizedBox(height: 8),
            _buildCgpaRow(summary!),
          ],
          const SizedBox(height: 16),
          _buildRow('Roll Number', info.rollNumber),
          const SizedBox(height: 12),
          _buildRow('Program', info.programName),
          const SizedBox(height: 12),
          _buildRow('Institute', info.instituteName),
          const SizedBox(height: 12),
          _buildRow('Batch', info.admissionYear),
          if (summary != null) ...[
            const SizedBox(height: 18),
            _buildStatsRow(summary!),
          ],
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            _displayValue(value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCgpaRow(ResultSummary summary) {
    return Row(
      children: [
        Text(
          'CGPA',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatNumber(summary.cgpa, decimals: 2),
          style: const TextStyle(
            color: Color(0xFF38BDF8),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ResultSummary summary) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _buildStatChip(
          'Total Credits',
          _formatNumber(summary.totalCredits, decimals: 0),
          const Color(0xFF3B82F6),
        ),
        _buildStatChip(
          'Semesters',
          summary.semestersCompleted.toString(),
          const Color(0xFF7C3AED),
        ),
      ],
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.16),
        border: Border.all(color: color.withOpacity(0.45)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _displayValue(String value) {
    if (value.trim().isEmpty) {
      return 'N/A';
    }
    return value.trim();
  }

  String _formatNumber(double? value, {required int decimals}) {
    if (value == null) {
      return '-';
    }
    return value.toStringAsFixed(decimals);
  }
}
