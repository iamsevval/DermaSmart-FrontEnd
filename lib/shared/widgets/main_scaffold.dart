import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_routes.dart';
import '../../core/theme/app_theme.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith(AppRoutes.home)) return 0;
    if (location.startsWith(AppRoutes.routine)) return 1;
    if (location.startsWith('/catalog')) return 2; // Katalog sayfası için eklendi
    if (location.startsWith(AppRoutes.scan)) return 3;
    if (location.startsWith(AppRoutes.progress)) return 4;
    if (location.startsWith(AppRoutes.profile)) return 5;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    const routes = [
      AppRoutes.home,
      AppRoutes.routine,
      '/catalog', // Katalog rotası bağlandı
      AppRoutes.scan,
      AppRoutes.progress,
      AppRoutes.profile,
    ];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      // ----- PO TESTİ İÇİN YÜZEN BUTON -----
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/catalog'),
        icon: const Icon(Icons.shopping_bag, color: Colors.white),
        label: const Text('Kataloğa Git', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFE05252), 
      ),
      // ------------------------------------
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.outline, width: 1)),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // 6 ikon olacağı için ekrandan taşmayı önler
          currentIndex: currentIndex,
          onTap: (i) => _onTap(context, i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Ana Sayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_outlined),
              activeIcon: Icon(Icons.auto_awesome),
              label: 'Rutin',
            ),
            // YENİ EKLENEN KATALOG BUTONU
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'Katalog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_outlined),
              activeIcon: Icon(Icons.document_scanner),
              label: 'Tara',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: 'İlerleme',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}