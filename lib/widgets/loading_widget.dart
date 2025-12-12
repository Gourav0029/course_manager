import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? text;
  const LoadingWidget({this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          if (text != null) ...[SizedBox(height: 8), Text(text!)],
        ],
      ),
    );
  }
}
