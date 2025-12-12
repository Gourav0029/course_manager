import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryChips extends StatefulWidget {
  final List<Category> categories;
  final String? selectedId;
  final void Function(String? id) onSelect;

  const CategoryChips({
    required this.categories,
    required this.selectedId,
    required this.onSelect,
    super.key,
  });

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
  }

  @override
  void didUpdateWidget(covariant CategoryChips oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedId != widget.selectedId) {
      _selectedId = widget.selectedId;
    }
  }

  void _handleSelect(String? id) {
    setState(() => _selectedId = id);
    widget.onSelect(id);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          ChoiceChip(
            label: const Text('All'),
            selected: _selectedId == null,
            onSelected: (sel) {
              if (sel) {
                _handleSelect(null);
              } else {
                _handleSelect(null);
              }
            },
          ),
          const SizedBox(width: 8),
          ...widget.categories.map((c) {
            final isSelected = _selectedId == c.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(c.name),
                selected: isSelected,
                onSelected: (sel) {
                  // toggle: if user alredy taps on selected, it  will change to unselected get to all again
                  if (sel) {
                    _handleSelect(isSelected ? null : c.id);
                  } else {
                    _handleSelect(isSelected ? null : c.id);
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
