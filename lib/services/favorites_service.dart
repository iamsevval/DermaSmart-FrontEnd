import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../features/product/screens/product_catalog_screen.dart'; // For Product model

class FavoritesService {
  // Not: Android emulator için http://10.0.2.2:5030, iOS için http://localhost:5030 kullanılıyor olabilir.
  // Varsayılan API baseUrl'i:
  static const String _baseUrl = 'http://10.0.2.2:5030/api/favorites';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<Product>> getFavorites() async {
    final token = await _getToken();
    if (token == null) throw Exception('Token bulunamadı.');

    final response = await http.get(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      if (decodedData['success'] == true) {
        final List<dynamic> productsData = decodedData['favorites'];
        return productsData.map((e) => Product.fromJson(e)).toList();
      }
    }
    throw Exception('Favoriler alınamadı. (Kod: ${response.statusCode})');
  }

  Future<bool> addFavorite(String productId) async {
    final token = await _getToken();
    if (token == null) return false;

    final response = await http.post(
      Uri.parse('$_baseUrl/$productId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> removeFavorite(String productId) async {
    final token = await _getToken();
    if (token == null) return false;

    final response = await http.delete(
      Uri.parse('$_baseUrl/$productId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
