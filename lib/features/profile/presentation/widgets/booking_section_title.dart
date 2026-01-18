import 'package:flutter/material.dart';

class BookingSectionTitle extends StatelessWidget {
  final String title;
  const BookingSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
