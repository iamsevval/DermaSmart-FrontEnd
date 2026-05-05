import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String? _selectedSkinType;
  final List<String> _selectedConcerns = [];
  String? _selectedSensitivity;

  final _skinTypes = [
    ('Normal', Icons.sentiment_satisfied, 'Dengeli ve pürüzsüz'),
    ('Yağlı', Icons.water_drop, 'Parlak ve gözenekli'),
    ('Kuru', Icons.grain, 'Gergin ve pul pul'),
    ('Karma', Icons.balance, 'T-bölgesi yağlı'),
    ('Hassas', Icons.favorite, 'Kolay kırmızılaşan'),
  ];

  final _concerns = [
    'Akne / Sivilce', 'Kırışıklıklar', 'Lekeler', 'Gözenek',
    'Siyah Nokta', 'Kuruluk', 'Hassasiyet', 'Cilt Tonu',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: List.generate(3, (i) => Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                    decoration: BoxDecoration(
                      color: i <= _currentPage
                          ? AppColors.primary
                          : AppColors.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _buildSkinTypePage(),
                  _buildConcernsPage(),
                  _buildSensitivityPage(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(_currentPage < 2 ? 'Devam Et' : 'Rutinime Başla'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkinTypePage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Cilt tipiniz nedir?',
            style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 8),
          Text('Size en uygun rutini oluşturalım.',
            style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: _skinTypes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final (label, icon, desc) = _skinTypes[i];
                final selected = _selectedSkinType == label;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSkinType = label),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primaryLight : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.outline,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary
                                : AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon,
                            color: selected ? Colors.white : AppColors.textSecondary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(label, style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15)),
                              Text(desc, style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 13)),
                            ],
                          ),
                        ),
                        if (selected)
                          const Icon(Icons.check_circle,
                            color: AppColors.primary, size: 22),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConcernsPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Cilt endişeleriniz?',
            style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 8),
          Text('Birden fazla seçebilirsiniz.',
            style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _concerns.map((concern) {
              final selected = _selectedConcerns.contains(concern);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) {
                    _selectedConcerns.remove(concern);
                  } else {
                    _selectedConcerns.add(concern);
                  }
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.outline,
                    ),
                  ),
                  child: Text(
                    concern,
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSensitivityPage() {
    final options = [
      ('Düşük', 'Çoğu ürünü tolere ederim', Icons.shield_outlined),
      ('Orta', 'Bazen reaksiyon gösterebilirim', Icons.warning_amber_outlined),
      ('Yüksek', 'Kolayca tahriş olur', Icons.priority_high_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Cilt hassasiyetiniz?',
            style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 8),
          Text('İçerik önerilerimizi buna göre ayarlayalım.',
            style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 32),
          ...options.map((o) {
            final (label, desc, icon) = o;
            final selected = _selectedSensitivity == label;
            return GestureDetector(
              onTap: () => setState(() => _selectedSensitivity = label),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryLight : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.outline,
                    width: selected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(icon,
                      color: selected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 28),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                        Text(desc, style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}