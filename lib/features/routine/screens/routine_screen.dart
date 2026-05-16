import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/routine_service.dart';

class RoutineScreen extends StatefulWidget {
  final String? token;
  final String? skinType;
  const RoutineScreen({super.key, this.token, this.skinType});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<dynamic> _morningSteps = [];
  List<dynamic> _eveningSteps = [];
  List<dynamic> _conflicts = [];
  bool _isLoading = true;

  // Mock data — backend bağlanamadığında gösterilir
  final _mockMorning = [
    {'stepName': 'Yüz Temizleyici', 'description': 'Nazikçe 60 sn. uygula', 'warning': ''},
    {'stepName': 'Tonik', 'description': 'Pamukla silerek uygula', 'warning': ''},
    {'stepName': 'C Vitamini Serumu', 'description': 'Sabahları kullan', 'warning': 'Retinol ile aynı anda kullanmayın'},
    {'stepName': 'Nemlendirici', 'description': 'Hafif vur vuruşla uygula', 'warning': ''},
    {'stepName': 'SPF 50+ Güneş Kremi', 'description': 'Son adım — ZORUNLU', 'warning': ''},
  ];

  final _mockEvening = [
    {'stepName': 'Makyaj Temizleyici Yağ', 'description': 'Çift temizleme - 1. adım', 'warning': ''},
    {'stepName': 'Yüz Temizleyici', 'description': 'Köpürtüp durulayın', 'warning': ''},
    {'stepName': 'Tonik', 'description': '30 sn. bekleyin', 'warning': ''},
    {'stepName': 'Retinol Serumu', 'description': 'Haftada 2-3x kullan', 'warning': 'C Vitamini ile aynı gece kullanmayın'},
    {'stepName': 'Ağır Nemlendirici', 'description': 'Gece kremi', 'warning': ''},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    if (widget.token == null || widget.skinType == null ||
        widget.token!.isEmpty || widget.skinType!.isEmpty) {
      // Token veya skinType yok — mock data kullan
      setState(() {
        _morningSteps = _mockMorning;
        _eveningSteps = _mockEvening;
        _isLoading = false;
      });
      return;
    }

    try {
      final morningResult = await RoutineService.getMorningRoutine(
        skinType: widget.skinType!,
        token: widget.token!,
      );

      final eveningResult = await RoutineService.getEveningRoutine(
        skinType: widget.skinType!,
        token: widget.token!,
      );

      final morning = (morningResult['routine'] as List?) ?? [];
      final evening = (eveningResult['routine'] as List?) ?? [];

      // Çakışma kontrolü
      final allIngredients = [
        ...morning.map((s) => s['stepName']?.toString() ?? ''),
        ...evening.map((s) => s['stepName']?.toString() ?? ''),
      ].where((s) => s.isNotEmpty).toList();

      List<dynamic> conflicts = [];
      if (allIngredients.isNotEmpty) {
        final conflictResult = await RoutineService.checkConflicts(
          ingredients: allIngredients,
          token: widget.token!,
        );
        conflicts = (conflictResult['conflicts'] as List?) ?? [];
      }

      if (mounted) {
        setState(() {
          _morningSteps = morning.isNotEmpty ? morning : _mockMorning;
          _eveningSteps = evening.isNotEmpty ? evening : _mockEvening;
          _conflicts = conflicts;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _morningSteps = _mockMorning;
          _eveningSteps = _mockEvening;
          _isLoading = false;
        });
      }
    }
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildRoutineTab(_morningSteps, isMorning: true),
                _buildRoutineTab(_eveningSteps, isMorning: false),
              ],
            ),
    );
  }

  Widget _buildRoutineTab(List<dynamic> steps, {required bool isMorning}) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Çakışma uyarıları
        if (_conflicts.isNotEmpty) ...[
          ..._conflicts.map((c) => _ConflictBanner(message: c.toString())),
          const SizedBox(height: 8),
        ],

        // Rutin adımları
        ...steps.asMap().entries.map((entry) {
          final i = entry.key;
          final step = entry.value;
          return _RoutineStepCard(
            stepNumber: i + 1,
            name: step['stepName']?.toString() ?? 'Adım ${i + 1}',
            description: step['description']?.toString() ?? '',
            warning: step['warning']?.toString() ?? '',
            isMorning: isMorning,
          );
        }),
      ],
    );
  }
}

// Çakışma uyarı banner'ı
class _ConflictBanner extends StatelessWidget {
  final String message;
  const _ConflictBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFCCCC)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded,
            color: Color(0xFFE05252), size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFFB03030),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Rutin adım kartı
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
                  width: 32, height: 32,
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

          // Uyarı banner (adım altında)
          if (widget.warning.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
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
                          fontSize: 12,
                          color: Color(0xFFB03030),
                        )),
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