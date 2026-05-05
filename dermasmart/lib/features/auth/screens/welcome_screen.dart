import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _btnController;
  late Animation<double> _btnScale;

  final List<_OnboardPage> _pages = [
    _OnboardPage(
      emoji: '🔍',
      title: 'Cildini Tanı',
      description:
          'Yapay zeka destekli analizimiz ile cilt tipini öğren. Kişiselleştirilmiş sorularla sana özel profil oluştur.',
      color: const Color(0xFF6B5EA8),
      lightColor: const Color(0xFFEDE9F8),
    ),
    _OnboardPage(
      emoji: '✨',
      title: 'Rutinini Oluştur',
      description:
          'Cilt tipine ve endişelerine göre sabah & akşam bakım rutinini adım adım planla. İçerik çakışmalarını önle.',
      color: const Color(0xFF4CAF82),
      lightColor: const Color(0xFFE8F5F0),
    ),
    _OnboardPage(
      emoji: '📈',
      title: 'İlerlemeni Takip Et',
      description:
          'Haftalık fotoğraf karşılaştırması ve rutin uyum takibi ile cildinizin değişimini gözlemle.',
      color: const Color(0xFFE8A598),
      lightColor: const Color(0xFFFDF0ED),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _btnScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _btnController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _btnController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPageData = _pages[_currentPage];

    return Scaffold(
      backgroundColor: currentPageData.lightColor,
      body: SafeArea(
        child: Column(
          children: [
            // Atla butonu
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sayfa göstergesi
                  Row(
                    children: List.generate(_pages.length, (i) =>
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: i == _currentPage ? 24 : 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? currentPageData.color
                              : currentPageData.color.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _goToLogin,
                    child: Text(
                      'Atla',
                      style: TextStyle(
                        color: currentPageData.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Sayfa içeriği
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _OnboardingPageWidget(page: page);
                },
              ),
            ),

            // Alt buton alanı
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Column(
                children: [
                  // Devam et butonu
                  GestureDetector(
                    onTapDown: (_) => _btnController.forward(),
                    onTapUp: (_) {
                      _btnController.reverse();
                      _nextPage();
                    },
                    onTapCancel: () => _btnController.reverse(),
                    child: ScaleTransition(
                      scale: _btnScale,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: currentPageData.color,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: currentPageData.color.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _currentPage < _pages.length - 1
                                ? 'Devam Et'
                                : 'Başlayalım!',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Giriş yap linki
                  GestureDetector(
                    onTap: _goToLogin,
                    child: RichText(
                      text: TextSpan(
                        text: 'Zaten hesabın var mı? ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Giriş Yap',
                            style: TextStyle(
                              color: currentPageData.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageWidget extends StatefulWidget {
  final _OnboardPage page;
  const _OnboardingPageWidget({required this.page});

  @override
  State<_OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
}

class _OnboardingPageWidgetState extends State<_OnboardingPageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0.1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji kartı
              Container(
                width: 140, height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: widget.page.color.withOpacity(0.2),
                      blurRadius: 40,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.page.emoji,
                    style: const TextStyle(fontSize: 64),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              Text(
                widget.page.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                widget.page.description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardPage {
  final String emoji;
  final String title;
  final String description;
  final Color color;
  final Color lightColor;

  const _OnboardPage({
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
    required this.lightColor,
  });
}