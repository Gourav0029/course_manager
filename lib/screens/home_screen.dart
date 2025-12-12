import 'package:course_manager/screens/edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/category_controller.dart';
import '../controllers/course_controller.dart';
import '../models/course.dart';
import '../screens/details_screen.dart';
import '../services/local_service.dart';
import '../widgets/category_chips.dart';
import '../widgets/loading_widget.dart';
import '../widgets/empty_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategoryId;
  String searchQuery = "";

  final _local = LocalService();

  late final CategoryController catCtrl;
  late final CourseController courseCtrl;

  @override
  void initState() {
    super.initState();

    catCtrl = Get.find<CategoryController>();
    courseCtrl = Get.find<CourseController>();

    catCtrl.loadCategories();
    courseCtrl.loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Manager'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await catCtrl.loadCategories();
              await courseCtrl.loadCourses();
              Get.snackbar(
                'Refreshed',
                'Categories and courses updated',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Loading cached categories before opening add page
          final categories = catCtrl.categories.toList();
          final result = await Get.to(
            () => AddEditScreen(categories: categories, local: _local),
          );

          if (result == true) {
            courseCtrl.loadCourses();
          }
        },
      ),

      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search by title or description",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value.trim().toLowerCase());
              },
            ),
          ),

          
          // Category Chips
          
          Obx(() {
            if (catCtrl.loading.value) {
              return const Padding(
                padding: EdgeInsets.all(8),
                child: LoadingWidget(text: "Loading categories..."),
              );
            }

            if (catCtrl.categories.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(12),
                child: Text("No categories available"),
              );
            }

            return CategoryChips(
              categories: catCtrl.categories.toList(),
              selectedId: selectedCategoryId,
              onSelect: (id) {
                setState(() {
                  selectedCategoryId = id;
                });
              },
            );
          }),

          const SizedBox(height: 8),

          
          // Courses List
         
          Expanded(
            child: Obx(() {
              if (courseCtrl.loading.value) {
                return const LoadingWidget(text: "Loading courses...");
              }

              if (courseCtrl.courses.isEmpty) {
                return const EmptyWidget(
                  title: "No courses yet",
                  subtitle: "Tap + to add a course",
                );
              }

              // Filter courses
              List<Course> filtered = courseCtrl.courses.toList();

              if (searchQuery.isNotEmpty) {
                filtered = filtered.where((c) {
                  return c.title.toLowerCase().contains(searchQuery) ||
                      c.description.toLowerCase().contains(searchQuery);
                }).toList();
              }

              if (selectedCategoryId != null) {
                filtered = filtered
                    .where((c) => c.categoryId == selectedCategoryId)
                    .toList();
              }

              // Sort by score
              filtered.sort((a, b) => b.score.compareTo(a.score));

              if (filtered.isEmpty) {
                return const EmptyWidget(
                  title: "No matching courses",
                  subtitle: "Try changing the search or category filter",
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await catCtrl.loadCategories();
                  await courseCtrl.loadCourses();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final course = filtered[index];
                    final category = catCtrl.findById(course.categoryId);

                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        onTap: () async {
                          final result = await Get.to(
                            () => DetailsScreen(
                              course: course,
                              category: category!,
                              local: _local,
                            ),
                          );
                          if (result == true) {
                            courseCtrl.loadCourses();
                          }
                        },
                        title: Text(
                          course.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Chip(label: Text(category?.name ?? "Unknown")),
                                const SizedBox(width: 10),
                                Text("Lessons: ${course.lessons}"),
                              ],
                            ),
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Score"),
                            Text(
                              "${course.score}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
