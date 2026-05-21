import 'dart:convert';
import 'package:http/http.dart' as http;

class TrackingService {
  static const String baseUrl = 'http://10.0.2.2:5030';

  // Rutin adımı tamamlandı olarak işaretle
  static Future<bool> completeStep({
    required String token,
    required int userId,
    required int stepId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tracking/complete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userId': userId,
          'stepId': stepId,
          'date': DateTime.now().toIso8601String(),
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Geçmiş takip verilerini al
  static Future<Map<String, dynamic>> getHistory({
    required String token,
    required int userId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tracking/$userId/history'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Backend tarihe göre gruplu liste döndürüyor
        // Biz sadece tamamlanan günlerin listesini çıkarıyoruz
        final completedDays = data.map((d) => d['date'].toString()).toList();

        // Streak hesapla
        final streak = _calculateStreak(completedDays);

        return {
          'completedDays': completedDays,
          'streak': streak,
        };
      }
      return {'completedDays': [], 'streak': 0};
    } catch (e) {
      // Backend bağlanamazsa mock data
      final today = DateTime.now();
      final mockDays = [
        today.subtract(const Duration(days: 1)).toIso8601String().split('T')[0],
        today.subtract(const Duration(days: 2)).toIso8601String().split('T')[0],
        today.subtract(const Duration(days: 3)).toIso8601String().split('T')[0],
      ];
      return {'completedDays': mockDays, 'streak': 3};
    }
  }

  // Streak hesaplama
  static int _calculateStreak(List<dynamic> completedDays) {
    if (completedDays.isEmpty) return 0;

    final dates = completedDays
        .map((d) {
          final parts = d.toString().split('-');
          return DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        })
        .toList()
      ..sort((a, b) => b.compareTo(a)); // en yeni önce

    int streak = 0;
    DateTime check = DateTime.now();

    for (final date in dates) {
      final diff = check.difference(date).inDays;
      if (diff <= 1) {
        streak++;
        check = date;
      } else {
        break;
      }
    }

    return streak;
  }
}