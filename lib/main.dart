import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'services/api_service.dart';
import 'services/local_service.dart';
import 'controllers/category_controller.dart';
import 'controllers/course_controller.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing services
  final localService = LocalService();
  final apiService = ApiService(); 

  // Initializing controllers
  Get.put<CategoryController>(CategoryController(api: apiService, local: localService));
  Get.put<CourseController>(CourseController(local: localService));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeData _theme = ThemeData(
    primarySwatch: Colors.indigo,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Course Manager',
      debugShowCheckedModeBanner: false,
      theme: _theme,
      home: HomeScreen(),
    );
  }
}
