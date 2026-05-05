import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _morningSteps = [
    _RoutineStep('Yüz Temizleyici', 'Nazikçe 60 sn. uygula', '☁️', false),
    _RoutineStep('Tonik', 'Pamukla silerek uygula', '💧', false),
    _RoutineStep('C Vitamini Serumu', 'Sabahları kullan', '🍊', true),
    _RoutineStep('Nemlendirici', 'Hafif vur vuruşla uygula', '🌿', false),
    _RoutineStep('SPF 50+ Güneş Kremi', 'Son adım — ZORUNLU', '☀️', false),
  ];

  final _eveningSteps = [
    _RoutineStep('Makyaj Temizleyici Yağ', 'Çift temizleme - 1. adım', '🌙', false),
    _RoutineStep('Yüz Temizleyici', 'Köpürtüp durulayın', '☁️', false),
    _RoutineStep('Tonik', '30 sn. bekleyin', '💧', false),
    _RoutineStep('Retinol Serumu', 'Haftada 2-3x kullan', '⭐', true),
    _RoutineStep('Ağır Nemlendirici', 'Gece kremi', '🌸', false),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          _buildRoutineList(_morningSteps, isMorning: true),
          _buildRoutineList(_eveningSteps, isMorning: false),
        ],
      ),
    );
  }

  Widget _buildRoutineList(List<_RoutineStep> steps, {required bool isMorning}) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: steps.length,
      itemBuilder: (context, i) {
        final step = steps[i];
        return _RoutineStepCard(
          step: step,
          stepNumber: i + 1,
          isMorning: isMorning,
          onToggle: (checked) => setState(() => step.completed = checked),
        );
      },
    );
  }
}

class _RoutineStep {
  final String name;
  final String description;
  final String emoji;
  final bool isCaution;
  bool completed;
  _RoutineStep(this.name, this.description, this.emoji, this.isCaution,
      {this.completed = false});
}

class _RoutineStepCard extends StatelessWidget {
  final _RoutineStep step;
  final int stepNumber;
  final bool isMorning;
  final ValueChanged<bool> onToggle;

  const _RoutineStepCard({
    required this.step,
    required this.stepNumber,
    required this.isMorning,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: step.completed
            ? (isMorning ? AppColors.morningStep : AppColors.eveningStep)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: step.isCaution
              ? const Color(0xFFFFCCCC)
              : AppColors.outline,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: step.completed
                  ? AppColors.success
                  : (isMorning ? AppColors.morningStep : AppColors.eveningStep),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: step.completed
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Text('$stepNumber',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
          const SizedBox(width: 14),
          Text(step.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(step.name, style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14)),
                    if (step.isCaution) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.warning_amber_rounded,
                        color: Color(0xFFE05252), size: 14),
                    ],
                  ],
                ),
                Text(step.description, style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Checkbox(
            value: step.completed,
            onChanged: (v) => onToggle(v ?? false),
            activeColor: AppColors.success,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)),
          ),
        ],
      ),
    );
  }
}