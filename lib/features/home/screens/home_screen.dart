import 'package:flutter/material.dart';
import '../../routine/screens/routine_screen.dart';
import '../../scan/screens/scan_screen.dart';
import '../../progress/screens/progress_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../product/screens/product_catalog_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? userName;
  final String? email;
  final String? token;
  final String? skinType;
  final List<String> skinConcerns;
  final int? userId;

  const HomeScreen({
    super.key,
    this.userName,
    this.email,
    this.token,
    this.skinType,
    this.skinConcerns = const [],
    this.userId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _HomeTab(
        userName: widget.userName,
        skinType: widget.skinType,
        skinConcerns: widget.skinConcerns,
        onProfileTap: () => setState(() => _currentIndex = 4),
        onRoutineTabRequested: () => setState(() => _currentIndex = 1),
      ),
      RoutineScreen(
        skinType: widget.skinType,
        skinConcerns: widget.skinConcerns,
        token: widget.token,
        userId: widget.userId,
      ),
      const ScanScreen(),
      ProgressScreen(
        token: widget.token,
        userId: widget.userId,
      ),
      ProfileScreen(
        userName: widget.userName,
        email: widget.email,
        skinType: widget.skinType,
        skinConcerns: widget.skinConcerns,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentIndex == 1 
          ? RoutineScreen(
              skinType: widget.skinType,
              skinConcerns: widget.skinConcerns,
              token: widget.token,
              userId: widget.userId,
            )
          : IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle:
              const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          elevation: 0,
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

class _HomeTab extends StatelessWidget {
  final String? userName;
  final String? skinType;
  final List<String> skinConcerns;
  final VoidCallback? onProfileTap;
  final VoidCallback onRoutineTabRequested;

  const _HomeTab({
    this.userName,
    this.skinType,
    this.skinConcerns = const [],
    this.onProfileTap,
    required this.onRoutineTabRequested,
  });

  String _getMorningPreview() {
    if (skinType == null || skinType!.isEmpty) {
      return 'Rutininizi oluşturmak için quiz yapın';
    }
    final type = skinType!.toLowerCase();
    if (type.contains('yağlı') || type.contains('karma')) {
      return 'Jel Temizleyici → Tonik → Nemlendirici → SPF';
    } else if (type.contains('kuru')) {
      return 'Kremsi Temizleyici → Tonik → Nemlendirici → SPF';
    } else if (type.contains('hassas')) {
      return 'Nazik Temizleyici → Sakinleştirici Tonik → SPF';
    } else {
      return 'Temizleyici → Tonik → Nemlendirici → SPF';
    }
  }

  int _getStepCount() {
    if (skinType == null) return 0;
    int count = 4;
    if (skinConcerns.contains('Koyu Lekeler') ||
        skinConcerns.contains('Akne ve Sivilceler') ||
        skinConcerns.contains('İnce Çizgiler / Kırışıklık')) {
      count = 5;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName != null
                              ? 'Günaydın, $userName 🌸'
                              : 'Günaydın 🌸',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sabah rutinin seni bekliyor.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.deepPurple.shade50,
                      child: Text(
                        userName != null && userName!.isNotEmpty
                            ? userName![0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Rutin kartı
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6B5EA8), Color(0xFF9B8FD4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text('☀️ Sabah Rutini',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        const Spacer(),
                        Text(
                          skinType != null ? '${_getStepCount()} adım' : '',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _getMorningPreview(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: skinType != null ? 1.0 : 0.0,
                        backgroundColor: Colors.white24,
                        valueColor:
                            const AlwaysStoppedAnimation(Colors.white),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding:
                              const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: onRoutineTabRequested,
                        child: const Text('Rutine Devam Et'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Çakışma uyarıları
              if (skinConcerns.contains("Koyu Lekeler") &&
                  skinConcerns.contains("Kızarıklık / Rozasea")) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.amber.shade200, width: 1.5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: Colors.amber.shade900, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Akıllı İçerik Etkileşimi",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "C Vitamini ve Niasinamid içerikleri aynı anda ciltte reaksiyon riski taşır. Rutininiz otomatik olarak güvenli saatlere bölünmüştür.",
                              style: TextStyle(
                                  color: Colors.amber.shade800,
                                  fontSize: 12,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (skinConcerns.contains("İnce Çizgiler / Kırışıklık") &&
                  skinConcerns.contains("Akne ve Sivilceler")) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: Colors.red.shade200, width: 1.5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.gpp_bad_outlined,
                          color: Colors.red.shade900, size: 26),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kritik İçerik Çakışması Önlendi!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade900,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Retinol ve Asitler (AHA/BHA) aynı gün kullanılamaz! Cilt bariyerinizi korumak adına içerikleriniz farklı akşam rutinlerine dağıtılmıştır.",
                              style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontSize: 12,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProductCatalogScreen(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE05252),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Ürün Kataloğuna Git',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}