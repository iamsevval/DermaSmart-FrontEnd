import 'package:flutter/material.dart';
import '../../auth/screens/splash_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String? userName;
  final String? email;
  const ProfileScreen({super.key, this.userName, this.email});

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
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white24,
                  child: Text(
                    userName != null && userName!.isNotEmpty
                        ? userName![0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 28, color: Colors.white,
                      fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName ?? 'Kullanıcı',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16),
                    ),
                    Text(
                      email ?? '',
                      style: const TextStyle(
                        color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Cilt Profili',
            style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.face,
                    color: Colors.deepPurple),
                  title: const Text('Cilt Tipim'),
                  trailing: const Text('Karma',
                    style: TextStyle(color: Colors.grey)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.warning_amber_outlined,
                    color: Colors.deepPurple),
                  title: const Text('Hassasiyet'),
                  trailing: const Text('Orta',
                    style: TextStyle(color: Colors.grey)),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.playlist_add_check,
                    color: Colors.deepPurple),
                  title: const Text('Endişelerim'),
                  trailing: const Text('3 seçili',
                    style: TextStyle(color: Colors.grey)),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const SplashScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Çıkış Yap',
              style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}