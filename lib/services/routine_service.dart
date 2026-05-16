import 'dart:convert';
import 'package:http/http.dart' as http;

class RoutineService {
  static const String baseUrl = 'http://10.0.2.2:5030';

  // Sabah rutini al
  static Future<Map<String, dynamic>> getMorningRoutine({
    required String skinType,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/products/morning-routine'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'skinType': skinType,
          'products': [],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'routine': data['routine']};
      } else {
        return {'success': false, 'routine': []};
      }
    } catch (e) {
      return {'success': false, 'routine': []};
    }
  }

  // Akşam rutini al
  static Future<Map<String, dynamic>> getEveningRoutine({
    required String skinType,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/products/evening-routine'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'skinType': skinType,
          'products': [],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'routine': data['routine']};
      } else {
        return {'success': false, 'routine': []};
      }
    } catch (e) {
      return {'success': false, 'routine': []};
    }
  }

  // Çakışma kontrolü
  static Future<Map<String, dynamic>> checkConflicts({
    required List<String> ingredients,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/products/check-conflicts'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'ingredients': ingredients}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'hasConflict': data['hasConflict'],
          'conflicts': data['conflicts'],
        };
      } else {
        return {'success': false, 'hasConflict': false, 'conflicts': []};
      }
    } catch (e) {
      return {'success': false, 'hasConflict': false, 'conflicts': []};
    }
  }
}