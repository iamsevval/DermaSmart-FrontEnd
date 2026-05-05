import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6B5EA8), Color(0xFF9B8FD4)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white24,
                  child: Text('D', style: TextStyle(
                    fontSize: 28, color: Colors.white,
                    fontWeight: FontWeight.w700)),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DermaSmart Kullanıcısı',
                      style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w700, fontSize: 16)),
                    Text('Karma Cilt · Hafif Hassas',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Cilt Profili', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.face, color: AppColors.primary),
                  title: const Text('Cilt Tipim'),
                  trailing: const Text('Karma',
                    style: TextStyle(color: AppColors.textSecondary)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.warning_amber_outlined,
                    color: AppColors.primary),
                  title: const Text('Hassasiyet'),
                  trailing: const Text('Orta',
                    style: TextStyle(color: AppColors.textSecondary)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.playlist_add_check,
                    color: AppColors.primary),
                  title: const Text('Endişelerim'),
                  trailing: const Text('3 seçili',
                    style: TextStyle(color: AppColors.textSecondary)),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => context.go(AppRoutes.splash),
            icon: const Icon(Icons.logout, color: AppColors.error),
            label: const Text('Çıkış Yap',
              style: TextStyle(color: AppColors.error)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}