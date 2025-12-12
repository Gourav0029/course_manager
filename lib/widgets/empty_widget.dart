import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const EmptyWidget({required this.title, required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.menu_book, size: 72, color: color.withOpacity(0.9)),
        SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        SizedBox(height: 8),
        Text(subtitle, textAlign: TextAlign.center),
      ]),
    );
  }
}
