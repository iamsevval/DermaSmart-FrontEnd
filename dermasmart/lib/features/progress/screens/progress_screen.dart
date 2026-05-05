import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İlerleme')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(value: '7', label: 'Gün Seri'),
                _StatItem(value: '23', label: 'Toplam Gün'),
                _StatItem(value: '85%', label: 'Uyum'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Fotoğraf Takibi',
            style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (_, i) => Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                i == 0 ? Icons.add_a_photo_outlined : Icons.face,
                color: i == 0 ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(
          fontSize: 28, fontWeight: FontWeight.w700,
          color: AppColors.primary)),
        Text(label, style: const TextStyle(
          fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}