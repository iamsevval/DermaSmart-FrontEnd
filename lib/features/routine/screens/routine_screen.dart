import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/routine_logic.dart';

class RoutineScreen extends StatefulWidget {
  final String? skinType;
  final List<String> skinConcerns;

  const RoutineScreen({
    super.key,
    this.skinType,
    this.skinConcerns = const [],
  });

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Map<String, String>> _morningSteps;
  late List<Map<String, String>> _eveningSteps;
  late List<Map<String, dynamic>> _conflicts;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _buildRoutine();
  }

  void _buildRoutine() {
    final skinType = widget.skinType ?? 'Normal';
    final concerns = widget.skinConcerns;

    _morningSteps = RoutineLogic.getMorningRoutine(
      skinType: skinType,
      skinConcerns: concerns,
    );
    _eveningSteps = RoutineLogic.getEveningRoutine(
      skinType: skinType,
      skinConcerns: concerns,
    );
    _conflicts = RoutineLogic.checkConflicts(
      morningSteps: _morningSteps,
      eveningSteps: _eveningSteps,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutinim'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: '☀️ Sabah'),
            Tab(text: '🌙 Akşam'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRoutineTab(_morningSteps, isMorning: true),
          _buildRoutineTab(_eveningSteps, isMorning: false),
        ],
      ),
    );
  }

  Widget _buildRoutineTab(
      List<Map<String, String>> steps, {required bool isMorning}) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Çakışma uyarıları
        if (_conflicts.isNotEmpty) ...[
          ...(_conflicts.map((c) => _ConflictBanner(
                message: c['message'] ?? '',
                isCritical: c['severity'] == 'critical',
              ))),
          const SizedBox(height: 8),
        ],

        // Cilt tipi etiketi
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.deepPurple.shade100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.face_retouching_natural,
                  color: Colors.deepPurple, size: 16),
              const SizedBox(width: 6),
              Text(
                'Cilt Tipiniz: ${widget.skinType ?? "Belirsiz"} — Kişisel rutin',
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Adımlar
        ...steps.asMap().entries.map((entry) {
          final i = entry.key;
          final step = entry.value;
          return _RoutineStepCard(
            stepNumber: i + 1,
            name: step['stepName'] ?? '',
            description: step['description'] ?? '',
            warning: step['warning'] ?? '',
            isMorning: isMorning,
          );
        }),
      ],
    );
  }
}

class _ConflictBanner extends StatelessWidget {
  final String message;
  final bool isCritical;
  const _ConflictBanner({required this.message, this.isCritical = false});

  @override
  Widget build(BuildContext context) {
    final color = isCritical ? Colors.red : Colors.amber;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isCritical ? Icons.gpp_bad_outlined : Icons.warning_amber_rounded,
            color: color.shade800,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                color: color.shade900,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutineStepCard extends StatefulWidget {
  final int stepNumber;
  final String name;
  final String description;
  final String warning;
  final bool isMorning;

  const _RoutineStepCard({
    required this.stepNumber,
    required this.name,
    required this.description,
    required this.warning,
    required this.isMorning,
  });

  @override
  State<_RoutineStepCard> createState() => _RoutineStepCardState();
}

class _RoutineStepCardState extends State<_RoutineStepCard> {
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _completed
            ? (widget.isMorning ? AppColors.morningStep : AppColors.eveningStep)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.warning.isNotEmpty
              ? const Color(0xFFFFCCCC)
              : AppColors.outline,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _completed
                        ? AppColors.success
                        : (widget.isMorning
                            ? AppColors.morningStep
                            : AppColors.eveningStep),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _completed
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : Text('${widget.stepNumber}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 13)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(widget.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14)),
                          ),
                          if (widget.warning.isNotEmpty)
                            const Icon(Icons.warning_amber_rounded,
                                color: Color(0xFFE05252), size: 16),
                        ],
                      ),
                      if (widget.description.isNotEmpty)
                        Text(widget.description,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Checkbox(
                  value: _completed,
                  onChanged: (v) => setState(() => _completed = v ?? false),
                  activeColor: AppColors.success,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
              ],
            ),
          ),
          if (widget.warning.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        color: Color(0xFFE05252), size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(widget.warning,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xFFB03030))),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}