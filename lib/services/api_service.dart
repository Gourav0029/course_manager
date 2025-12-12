import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../utils/constants.dart';

class ApiService {
  Future<List<Category>> fetchCategories() async {
    final uri = Uri.parse('$API_BASE/categories');
    final res = await http.get(uri).timeout(Duration(seconds: 8));
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data
          .map((e) => Category.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      throw Exception('Failed to load categories (${res.statusCode})');
    }
  }
}
