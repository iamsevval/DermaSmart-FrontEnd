import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dermasmart/features/product/screens/product_catalog_screen.dart';

class ProductService {
  static Future<List<Product>> fetchProducts() async {
    final String apiUrl = 'http://10.0.2.2:5030/api/products';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Gelen ham veriyi konsola yazdıralım ki neye benzediğini kesin olarak görelim
        print("API'DEN GELEN HAM VERİ: ${response.body}");

        final dynamic decodedData = json.decode(response.body);
        List<dynamic> productList;

        // Veri yapısına göre doğru listeyi yakalayalım
        if (decodedData is List) {
          productList = decodedData; // Direkt liste geldiyse
        } else if (decodedData is Map<String, dynamic>) {
          // Obje içinde geldiyse (genelde 'data', 'items' veya '$values' anahtarında olur)
          productList = decodedData['data'] ?? decodedData['\$values'] ?? decodedData['items'] ?? decodedData['products'] ?? [];
        } else {
          productList = [];
        }

        return productList.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Sunucu hatası: ${response.statusCode}');
      }
    } catch (e) {
      print('==== API BAĞLANTI HATASI DETAYI ====');
      print(e.toString());
      throw Exception('API bağlantı hatası: $e');
    }
  }
}