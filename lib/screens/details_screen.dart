import 'package:course_manager/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/course.dart';
import '../models/category.dart';
import '../services/local_service.dart';

class DetailsScreen extends StatelessWidget {
  final Course course;
  final Category category;
  final LocalService local;

  const DetailsScreen({
    required this.course,
    required this.category,
    required this.local,
    super.key,
  });

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete "${course.title}"?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await local.deleteCourse(course.id);
      Get.back(); // Go back after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Details'),
        actions: [
          //  EDIT BUTTON 
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final cats = await local.loadCachedCategories();
              final res = await Get.to(
                () => AddEditScreen(
                  categories: cats,
                  local: local,
                  existing: course,
                ),
              );
              if (res == true) Get.back();
            },
          ),

          //  DELETE BUTTON 
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _delete(context),
          ),
        ],
      ),

      
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(course.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(category.name)),
                const SizedBox(width: 8),
                Text('Lessons: ${course.lessons}'),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Score: ${course.score}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Description', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(course.description),
          ],
        ),
      ),
    );
  }
}
