import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/product/screens/product_catalog_screen.dart';

class CustomRoutineService {
  static Future<String> _getKey() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id') ?? 0;
    return 'custom_routine_products_$userId';
  }

  static Future<List<Product>> getRoutineProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getKey();
    final jsonList = prefs.getStringList(key) ?? [];
    return jsonList.map((jsonStr) => Product.fromJson(jsonDecode(jsonStr))).toList();
  }

  static Future<bool> addProduct(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getKey();
    final jsonList = prefs.getStringList(key) ?? [];
    
    if (jsonList.any((jsonStr) {
      final p = Product.fromJson(jsonDecode(jsonStr));
      return p.id == product.id;
    })) {
      return true;
    }

    final map = {
      'id': product.id,
      'name': product.name,
      'brand': product.brand,
      'imageUrl': product.imageUrl,
      'skinTypes': product.skinType,
      'price': product.price,
      'activeIngredients': product.ingredients.join(','),
      'usagePurpose': product.purpose,
    };
    
    jsonList.add(jsonEncode(map));
    return await prefs.setStringList(key, jsonList);
  }

  static Future<bool> removeProduct(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getKey();
    final jsonList = prefs.getStringList(key) ?? [];
    
    final newList = jsonList.where((jsonStr) {
      final p = Product.fromJson(jsonDecode(jsonStr));
      return p.id != productId;
    }).toList();
    
    return await prefs.setStringList(key, newList);
  }
  
  static Future<bool> isProductInRoutine(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getKey();
    final jsonList = prefs.getStringList(key) ?? [];
    return jsonList.any((jsonStr) {
      final p = Product.fromJson(jsonDecode(jsonStr));
      return p.id == productId;
    });
  }
}
