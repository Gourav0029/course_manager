import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/course.dart';
import '../utils/constants.dart';

class LocalService {
  Future<void> cacheCategories(List<Category> cats) async {
    final sp = await SharedPreferences.getInstance();
    final raw = jsonEncode(cats.map((c) => c.toMap()).toList());
    await sp.setString(CACHED_CATEGORIES_KEY, raw);
  }

  Future<List<Category>> loadCachedCategories() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(CACHED_CATEGORIES_KEY);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List parsed = jsonDecode(raw);
      return parsed.map((e) => Category.fromMap(Map<String, dynamic>.from(e))).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Course>> loadCourses() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(SAVED_COURSES_KEY);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List parsed = jsonDecode(raw);
      return parsed.map((e) => Course.fromMap(Map<String, dynamic>.from(e))).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveAllCourses(List<Course> list) async {
    final sp = await SharedPreferences.getInstance();
    final raw = jsonEncode(list.map((c) => c.toMap()).toList());
    await sp.setString(SAVED_COURSES_KEY, raw);
  }

  
  Future<void> saveCourse(Course c) async {
    final all = await loadCourses();
    final idx = all.indexWhere((e) => e.id == c.id);
    if (idx >= 0) {
      all[idx] = c;
    } else {
      all.add(c);
    }
    await saveAllCourses(all);
  }

  Future<void> deleteCourse(String id) async {
    final all = await loadCourses();
    all.removeWhere((e) => e.id == id);
    await saveAllCourses(all);
  }
}
