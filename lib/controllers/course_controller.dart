import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/course.dart';
import '../services/local_service.dart';

class CourseController extends GetxController {
  final LocalService local;
  final _uuid = Uuid();

  CourseController({required this.local});

  var courses = <Course>[].obs;
  var loading = false.obs;
  var error = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadCourses();
  }

  Future<void> loadCourses() async {
    loading.value = true;
    error.value = null;
    try {
      final list = await local.loadCourses();

      for (var c in list) {
        c.score = (c.title.length) * (c.lessons);
      }
      courses.assignAll(list);
    } catch (e) {
      error.value = 'Could not load courses';
    } finally {
      loading.value = false;
    }
  }

  Future<void> addCourse({
    required String title,
    required String description,
    required String categoryId,
    required int lessons,
  }) async {
    // computing score
    final score = title.length * lessons;

    // ensuring a unique id
    final id = _uuid.v4();

    final c = Course(
      id: id,
      title: title,
      description: description,
      categoryId: categoryId,
      lessons: lessons,
      score: score,
    );

    await local.saveCourse(c);

    courses.insert(0, c);
  }

  Future<void> updateCourse(Course course) async {
    course.score = course.title.length * course.lessons;

    await local.saveCourse(course);

    final idx = courses.indexWhere((c) => c.id == course.id);
    if (idx >= 0) {
      courses[idx] = course;

      courses.refresh();
    } else {
      courses.insert(0, course);
    }
  }

  Future<void> deleteCourse(String id) async {
    await local.deleteCourse(id);
    courses.removeWhere((c) => c.id == id);
  }

  Future<void> clearAll() async {
    await local.saveAllCourses([]);
    courses.clear();
  }
}
