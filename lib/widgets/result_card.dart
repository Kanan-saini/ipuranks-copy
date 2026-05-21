import 'package:flutter/material.dart';
import '../models/result_model.dart';
import 'subject_row.dart';

class ResultCard extends StatefulWidget {
  final StudentResult result;

  const ResultCard({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showInternalExternal = false;
  bool _showPaperId = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
      ),
      child: FadeTransition(
        opacity: _animationController,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
            color: const Color(0xFF0a0e27),
            border: Border(
              top: BorderSide(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top info section
                  _buildTopInfoSection(),
                  const SizedBox(height: 30),

                  // Toggles
                  _buildToggles(),
                  const SizedBox(height: 30),

                  // Subjects list
                  _buildSubjectsList(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopInfoSection() {
    return Column(
      children: [
        Text(
          widget.result.studentName.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.05),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoColumn(
                    'Marks',
                    '${widget.result.totalMarks}/${widget.result.maxMarks}',
                    const Color(0xFF84cc16),
                  ),
                  Container(
                    width: 1.5,
                    height: 60,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  _buildInfoColumn(
                    'Percentage',
                    '${widget.result.percentage}%',
                    const Color(0xFF6366f1),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 1.5,
                color: Colors.white.withOpacity(0.1),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoColumn(
                    'Credit Marks',
                    '${widget.result.creditMarks}/${widget.result.maxCreditMarks}',
                    const Color(0xFFec4899),
                  ),
                  Container(
                    width: 1.5,
                    height: 60,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  _buildInfoColumn(
                    'SGPA',
                    widget.result.sgpa.toString(),
                    const Color(0xFF84cc16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(String label, String value, Color accentColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: accentColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildToggles() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.03),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          _buildToggleRow(
            'Show Internal/External Marks',
            _showInternalExternal,
            (value) {
              setState(() => _showInternalExternal = value);
            },
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          _buildToggleRow(
            'Show Paper IDs',
            _showPaperId,
            (value) {
              setState(() => _showPaperId = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 56,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: value ? const Color(0xFF84cc16) : Colors.white.withOpacity(0.1),
          ),
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Stack(
              children: [
                AnimatedAlign(
                  alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0a0e27),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            shadows: [
              Shadow(
                color: const Color(0xFF84cc16).withOpacity(0.3),
                blurRadius: 10,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.result.subjects.length,
          itemBuilder: (context, index) {
            return SubjectRow(
              subject: widget.result.subjects[index],
              showInternalExternal: _showInternalExternal,
              showPaperId: _showPaperId,
              index: index,
            );
          },
        ),
      ],
    );
  }
}
