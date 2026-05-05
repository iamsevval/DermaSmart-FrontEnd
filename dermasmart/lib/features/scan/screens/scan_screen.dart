import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cilt Tarama')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120, height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(Icons.document_scanner_outlined,
                size: 56, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            Text('Cildini Analiz Et',
              style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text('Kameranı aç ve yüzünü çerçevele.',
              style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Kamerayı Aç'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text('Galeriden Seç'),
            ),
          ],
        ),
      ),
    );
  }
}