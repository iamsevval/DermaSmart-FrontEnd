import 'package:flutter/material.dart';
import '../../auth/screens/splash_screen.dart';
import '../../favorites/screens/favorites_screen.dart';
import '../../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final String? userName;
  final String? email;
  final String? skinType;
  final List<String> skinConcerns;

  const ProfileScreen({
    super.key,
    this.userName,
    this.email,
    this.skinType,
    this.skinConcerns = const [],
  });

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
                Expanded(
                  child: Column(
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
                  leading: const Icon(Icons.face, color: Colors.deepPurple),
                  title: const Text('Cilt Tipim'),
                  trailing: Text(
                    skinType ?? 'Belirsiz',
                    style: const TextStyle(color: Colors.grey)),
                ),
                ListTile(
                  leading: const Icon(Icons.playlist_add_check,
                    color: Colors.deepPurple),
                  title: const Text('Endişelerim'),
                  trailing: Text(
                    skinConcerns.isNotEmpty
                        ? '${skinConcerns.length} seçili'
                        : 'Yok',
                    style: const TextStyle(color: Colors.grey)),
                ),
                if (skinConcerns.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: skinConcerns.map((c) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.deepPurple.shade200),
                        ),
                        child: Text(c,
                          style: const TextStyle(
                            fontSize: 12, color: Colors.deepPurple)),
                      )).toList(),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
            },
            icon: const Icon(Icons.favorite_rounded, color: Colors.white),
            label: const Text('Favorilerim', style: TextStyle(color: Colors.white, fontSize: 16)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B5EA8),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await AuthService.logout();
              if (!context.mounted) return;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const SplashScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Çıkış Yap',
              style: TextStyle(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}