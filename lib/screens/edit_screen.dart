import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/category.dart';
import '../models/course.dart';
import '../services/local_service.dart';
import '../controllers/course_controller.dart';

class AddEditScreen extends StatefulWidget {
  final List<Category> categories;
  final Course? existing;
  final LocalService local;

  const AddEditScreen({
    required this.categories,
    required this.local,
    this.existing,
    super.key,
  });

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleC;
  late TextEditingController _descC;
  late TextEditingController _lessonsC;
  String? _selectedCategoryId;
  bool _saving = false;

  late final CourseController _courseCtrl;

  @override
  void initState() {
    super.initState();
    _titleC = TextEditingController(text: widget.existing?.title ?? '');
    _descC = TextEditingController(text: widget.existing?.description ?? '');
    _lessonsC = TextEditingController(
      text: widget.existing?.lessons.toString() ?? '1',
    );
    _selectedCategoryId =
        widget.existing?.categoryId ??
        (widget.categories.isNotEmpty ? widget.categories.first.id : null);

    _courseCtrl = Get.find<CourseController>();
  }

  @override
  void dispose() {
    _titleC.dispose();
    _descC.dispose();
    _lessonsC.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    final title = _titleC.text.trim();
    final desc = _descC.text.trim();
    final lessons = int.tryParse(_lessonsC.text.trim()) ?? 1;
    final catId = _selectedCategoryId ?? '';

    if (widget.existing == null) {
      // Using controller addCourse which handles id and score
      await _courseCtrl.addCourse(
        title: title,
        description: desc,
        categoryId: catId,
        lessons: lessons,
      );
    } else {
      // mutating existing and updating via controller (recalculate score)
      final c = widget.existing!;
      c.title = title;
      c.description = desc;
      c.lessons = lessons;
      c.categoryId = catId;
      await _courseCtrl.updateCourse(c);
    }

    setState(() => _saving = false);

    Get.back(result: true);
  }

  @override
  Widget build(BuildContext context) {
    final cats = widget.categories;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Add Course' : 'Edit Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: cats.isEmpty
            ? Center(
                child: Text(
                  'No categories available. Pull to refresh and try again.',
                ),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _titleC,
                      decoration: InputDecoration(labelText: 'Title'),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _descC,
                      decoration: InputDecoration(labelText: 'Description'),
                      minLines: 2,
                      maxLines: 4,
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCategoryId,
                      decoration: InputDecoration(labelText: 'Category'),
                      items: cats
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.name),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedCategoryId = v),
                    ),
                    SizedBox(height: 12),
                    TextFormField(
                      controller: _lessonsC,
                      decoration: InputDecoration(
                        labelText: 'Number of lessons',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null || n < 1) return 'Enter >= 1';
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    _saving
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(onPressed: _save, child: Text('Save')),
                  ],
                ),
              ),
      ),
    );
  }
}
