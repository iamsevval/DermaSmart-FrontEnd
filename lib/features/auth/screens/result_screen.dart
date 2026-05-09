import 'package:flutter/material.dart';
import '../../../models/user_profile_model.dart';
import '../../home/screens/home_screen.dart';
import '../../../services/auth_service.dart';

class ResultScreen extends StatefulWidget {
  final UserProfileModel userProfile;
  const ResultScreen({super.key, required this.userProfile});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _saveSkinProfile();
  }

  Future<void> _saveSkinProfile() async {
    final profile = widget.userProfile;
    if (profile.token == null) return;

    setState(() => _isSaving = true);

    await AuthService.saveSkinProfile(
      token: profile.token!,
      skinType: profile.skinType ?? 'Bilinmiyor',
      concerns: profile.skinConcerns,
      ageRange: profile.ageRange ?? 'Bilinmiyor',
    );

    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    String skinTypeTitle = widget.userProfile.skinType ?? "Karma (Hesaplanan)";

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        title: const Text('Profil Analizi Sonucu'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.auto_awesome, size: 70, color: Colors.deepPurple),
            const SizedBox(height: 16),
            Text(
              widget.userProfile.name != null
                  ? "Harika, ${widget.userProfile.name}! 🎉"
                  : "Harika! Cilt Profilin Oluşturuldu 🎉",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Kayıt durumu
            if (_isSaving)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.deepPurple),
                    ),
                    SizedBox(width: 10),
                    Text('Profil kaydediliyor...',
                        style: TextStyle(color: Colors.deepPurple)),
                  ],
                ),
              ),

            // Cilt tipi kartı
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.05),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text("Cilt Tipiniz",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 8),
                  Text(
                    skinTypeTitle.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Cilt endişeleri
            if (widget.userProfile.skinConcerns.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Cilt Endişeleriniz",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        )),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.userProfile.skinConcerns
                          .map(
                            (c) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.deepPurple.shade200),
                              ),
                              child: Text(c,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),

            // Uygulamaya başla butonu
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving
                    ? null
                    : () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => HomeScreen(
                              userName: widget.userProfile.name,
                              email: widget.userProfile.email,
                            ),
                          ),
                          (route) => false,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  'Uygulamaya Başla →',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
