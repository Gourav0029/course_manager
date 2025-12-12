import 'package:get/get.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../services/local_service.dart';

class CategoryController extends GetxController {
  final ApiService api;
  final LocalService local;

  CategoryController({required this.api, required this.local});

  var categories = <Category>[].obs;
  var loading = false.obs;
  var error = RxnString();

 
  Future<void> loadCategories() async {
    loading.value = true;
    error.value = null;
    try {
      final remote = await api.fetchCategories();
      categories.assignAll(remote);
      await local.cacheCategories(remote);
    } catch (e) {
      // fallback to cache
      final cached = await local.loadCachedCategories();
      if (cached.isNotEmpty) {
        categories.assignAll(cached);
        error.value = 'Using cached categories (offline).';
      } else {
        error.value = 'Failed to load categories.';
      }
    } finally {
      loading.value = false;
    }
  }

  Category? findById(String id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
