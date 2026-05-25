import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // ← OLMASI LAZIM

class AuthService {
  // NOT: Emulator kullanıyorsan 10.0.2.2, fiziksel cihaz ise kendi IP adresini yazmalısın.
  static const String baseUrl = 'http://10.0.2.2:5030';

  // 1. KAYIT OL (FullName eklendi)
  static Future<Map<String, dynamic>> register({
    required String fullName, // İsim alanı eklendi
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': fullName, // Backend'de yeni eklediğimiz alan
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      print('Register Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
        return {
          'success': true,
          'userId': data['userId'],
          'fullName': data['fullName'] // Backend'den dönen ismi yakalıyoruz
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Kayıt başarısız.'
        };
      }
    } catch (e) {
      print('Register Error: $e');
      return {'success': false, 'message': 'Sunucuya bağlanılamadı: $e'};
    }
  }

  // 2. GİRİŞ YAP (FullName ve SkinType eklendi)
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      print('Login Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
        return {
          'success': true,
          'token': data['token'],
          'userId': data['userId'],
          // Backend'den gelen tüm ihtimalleri kontrol ediyoruz
          'name': data['fullName'] ?? data['name'] ?? 'Kullanıcı',
          'skinType': data['skinType'], // Eğer varsa cilt tipini de alıyoruz
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Giriş başarısız.'
        };
      }
    } catch (e) {
      print('Login Error: $e');
      return {
        'success': false,
        'message': 'Sunucuya bağlanılamadı. Backend çalışıyor mu?'
      };
    }
  }

  // 3. CİLT PROFİLİ KAYDET (Quiz sonuçlarını gönderir)
  static Future<Map<String, dynamic>> saveSkinProfile({
    required String token,
    required String skinType,
    required List<String> concerns,
    required String ageRange,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/skinprofile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Güvenlik için token şart
        },
        body: jsonEncode({
          'skinType': skinType.toLowerCase(), // Backend küçük harf bekliyor
          'concerns': concerns, // Backend liste bekliyor
          'ageRange': ageRange,
        }),
      );

      print('Save Profile Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Profil kaydedilemedi.'
        };
      }
    } catch (e) {
      print('Save Profile Error: $e');
      return {'success': false, 'message': 'Sunucuya bağlanılamadı.'};
    }
  }

  // 4. İSİM KAYDET
  static Future<void> saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
  }

  // 5. KAYITLI İSMİ OKU
  static Future<String?> getSavedName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  // 6. TOKEN KAYDET
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // 7. ÇIKIŞ YAP (Tüm verileri temizle)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_name');
  }
}
