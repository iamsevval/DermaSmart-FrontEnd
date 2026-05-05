import 'package:flutter/material.dart';
import '../../../models/user_profile_model.dart';
import '../../home/screens/home_screen.dart';

class ResultScreen extends StatelessWidget {
  final UserProfileModel userProfile;

  const ResultScreen({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    String skinTypeTitle = userProfile.skinType ?? "Karma (Hesaplanan)";

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
            const Icon(Icons.auto_awesome, size: 70, color: Colors.deepPurple),
            const SizedBox(height: 16),
            const Text(
              "Harika! Cilt Profilin Oluşturuldu",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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
                      spreadRadius: 5)
                ],
              ),
              child: Column(
                children: [
                  const Text("Sizin Cilt Tipiniz",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(
                    skinTypeTitle.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Uygulamaya Başla",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
