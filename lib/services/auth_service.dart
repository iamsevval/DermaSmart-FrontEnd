import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:5030';

  // KAYIT OL
  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      print('Login response: ${response.statusCode} - ${response.body}');
      if (response.statusCode == 200) {
        return {'success': true, 'userId': data['userId']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Kayıt başarısız.'
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Sunucuya bağlanılamadı. Hata: $e'};
    }
  }

  // GİRİŞ YAP
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

      if (response.statusCode == 200) {
        return {
          'success': true,
          'token': data['token'],
          'userId': data['userId'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Giriş başarısız.'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Sunucuya bağlanılamadı. Backend çalışıyor mu?'
      };
    }
  }

  // CİLT PROFİLİ KAYDET
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
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'skinType': skinType,
          'concerns': concerns.join(', '),
          'ageRange': ageRange,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Profil kaydedilemedi.'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Sunucuya bağlanılamadı.'};
    }
  }
}
