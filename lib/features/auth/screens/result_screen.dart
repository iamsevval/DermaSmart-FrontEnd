import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  List<String> _conflicts = [];

  @override
  void initState() {
    super.initState();
    _saveSkinProfile();
    _checkConflicts();
  }

  Future<void> _checkConflicts() async {
    final ingredients = widget.userProfile.activeIngredients;
    if (ingredients == null || ingredients.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5030/api/products/check-conflicts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ingredients': ingredients}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['hasConflict'] == true && mounted) {
          setState(() {
            _conflicts = List<String>.from(data['conflicts']);
          });
        }
      }
    } catch (e) {
      // Backend bağlantı hatası — sessizce geç
    }
  }

  Future<void> _saveSkinProfile() async {
    final profile = widget.userProfile;
    if (profile.token == null) return;

    setState(() => _isSaving = true);

    // Cilt tipini hesapla ve profile ata (Böylece null kalmaz)
    final computedSkinType = profile.calculateSkinType();
    profile.skinType = computedSkinType;

    String formattedAge = profile.ageRange ?? "18-24";
    // formattedAge.replaceAll(' ', '') yapmıyoruz çünkü "45 ve üzeri" boşluk içeriyor.

    final result = await AuthService.saveSkinProfile(
      token: profile.token!,
      skinType: computedSkinType,
      concerns: profile.skinConcerns,
      ageRange: formattedAge,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      if (result['success'] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Profil kaydedilemedi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String skinTypeTitle = widget.userProfile.skinType ?? widget.userProfile.calculateSkinType();

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

            // ⚠️ ÇAKIŞMA UYARISI
            if (_conflicts.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning_amber_rounded,
                            color: Colors.orange.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'İçerik Çakışması Tespit Edildi!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ..._conflicts.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Icon(Icons.block,
                                  size: 14, color: Colors.orange.shade600),
                              const SizedBox(width: 6),
                              Text(
                                c,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 6),
                    Text(
                      'Bu içerikleri aynı anda kullanmaktan kaçının.',
                      style: TextStyle(
                          fontSize: 12, color: Colors.orange.shade600),
                    ),
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
                              token: widget.userProfile.token,
                              skinType: widget.userProfile.skinType,
                              skinConcerns: widget.userProfile.skinConcerns,
                              userId: widget.userProfile.userId,
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
