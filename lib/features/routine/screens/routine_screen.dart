import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/routine_logic.dart';
import '../../../services/tracking_service.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import '../../../services/custom_routine_service.dart';

class RoutineScreen extends StatefulWidget {
  final String? skinType;
  final List skinConcerns;
  final String? token;
  final int? userId;

  const RoutineScreen({
    super.key,
    this.skinType,
    this.skinConcerns = const [],
    this.token,
    this.userId,
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

  int _completedMorningCount = 0;
  int _completedEveningCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _buildRoutine();
    _loadCustomRoutines();
  }

  Future<void> _loadCustomRoutines() async {
    try {
      final customProducts = await CustomRoutineService.getRoutineProducts();
      if (mounted && customProducts.isNotEmpty) {
        setState(() {
          for (var p in customProducts) {
            final step = {
              'stepName': p.name,
              'description': 'Katalogdan eklendi: ${p.brand}',
              'warning': '',
            };
            
            bool isMorning = true;
            bool isEvening = true;
            final ing = p.ingredients.join(', ').toLowerCase();
            final purpose = p.purpose.toLowerCase();
            final name = p.name.toLowerCase();
            
            // Sadece Sabah: Güneş Kremi, SPF ve C Vitamini
            if (name.contains('güneş') || name.contains('sunscreen') || name.contains('spf') || 
                ing.contains('spf') || purpose.contains('uv')) {
              isEvening = false;
            }
            if (name.contains('vitamin c') || ing.contains('vitamin c') || ing.contains('c vitamini')) {
              isEvening = false;
            }

            // Sadece Akşam: Retinol, AHA/BHA, Gece kremleri
            if (ing.contains('retinol') || name.contains('retinol') || 
                name.contains('gece') || name.contains('night') || purpose.contains('gece') ||
                ing.contains('aha') || ing.contains('bha') || name.contains('aha') || name.contains('bha') ||
                ing.contains('glikolik') || ing.contains('salisilik') || name.contains('exfoliant')) {
              isMorning = false;
              // Eğer hem sabah hem akşam false olduysa (çakışan anahtar kelimeler), akşamı tercih et.
              isEvening = true; 
            }

            if (isMorning) _morningSteps.add(step);
            if (isEvening) _eveningSteps.add(step);
          }
        });
      }
    } catch (e) {
      // Sessizce geç
    }
  }

  void _buildRoutine() {
    final skinType = widget.skinType ?? 'Normal';
    final concerns = widget.skinConcerns.cast<String>().toList();

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

  void _onAllStepsCompleted() async {
    if (widget.token != null && widget.userId != null) {
      await TrackingService.completeStep(
        token: widget.token!,
        userId: widget.userId!,
        stepId: 0,
      );
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Tebrikler! Bugünkü rutinin tamamlandı!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRoutineTab(_morningSteps, isMorning: true),
          _buildRoutineTab(_eveningSteps, isMorning: false),
        ],
      ),
    );
  }

  Widget _buildRoutineTab(List<Map<String, String>> steps,
      {required bool isMorning}) {
    if (steps.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.spa_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text(
              'Henüz rutin oluşturulmadı',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Quiz yaparak kişisel rutininizi oluşturun',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        if (_conflicts.isNotEmpty) ...[
          ...(_conflicts.map((c) => _ConflictBanner(
                message: c['message'] ?? '',
                isCritical: c['severity'] == 'critical',
              ))),
          const SizedBox(height: 8),
        ],
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
        ...steps.asMap().entries.map((entry) {
          final i = entry.key;
          final step = entry.value;
          return _RoutineStepCard(
            stepNumber: i + 1,
            name: step['stepName'] ?? '',
            description: step['description'] ?? '',
            warning: step['warning'] ?? '',
            isMorning: isMorning,
            token: widget.token,
            userId: widget.userId,
            onCompleted: () {
              if (isMorning) {
                setState(() => _completedMorningCount++);
              } else {
                setState(() => _completedEveningCount++);
              }
              final totalMorning = _morningSteps.length;
              final totalEvening = _eveningSteps.length;
              if (_completedMorningCount >= totalMorning &&
                  _completedEveningCount >= totalEvening) {
                _onAllStepsCompleted();
              }
            },
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
  final String? token;
  final int? userId;
  final VoidCallback? onCompleted;

  const _RoutineStepCard({
    required this.stepNumber,
    required this.name,
    required this.description,
    required this.warning,
    required this.isMorning,
    this.token,
    this.userId,
    this.onCompleted,
  });

  @override
  State<_RoutineStepCard> createState() => _RoutineStepCardState();
}

class _RoutineStepCardState extends State<_RoutineStepCard>
    with AutomaticKeepAliveClientMixin {
  // 🔥 YENİ GÜNLÜK AKILLI STORAGE DEĞİŞKENLERİ
  bool _completed = false;
  String _todayStr = '';

  @override
  void initState() {
    super.initState();
    _todayStr = _getToday();
    _loadState();
  }

  String _getToday() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  String get _prefKey =>
      'step_${widget.isMorning ? 'morning' : 'evening'}_${widget.stepNumber}_$_todayStr';

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _getToday();
    final saved = prefs.getBool(_prefKey) ?? false;
    if (mounted) {
      setState(() {
        _completed = saved;
        _todayStr = today;
      });
    }
  }

  Future<void> _saveState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // 💡 GEREKSİZ 'initState' VEYA ESKİ RESET KODLARI BURADAN UÇURULDU, MANTIK TAMAMEN TEMİZLENDİ.

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
                  onChanged: (v) async {
                    final checked = v ?? false;

                    setState(() {
                      _completed = checked;
                    });
                    await _saveState(checked);

                    if (checked && widget.onCompleted != null) {
                      widget.onCompleted!();
                    }

                    if (checked &&
                        widget.token != null &&
                        widget.userId != null) {
                      await TrackingService.completeStep(
                        token: widget.token!,
                        userId: widget.userId!,
                        stepId: widget.stepNumber,
                      );
                    }
                  },
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
