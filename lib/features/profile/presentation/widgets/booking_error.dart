import 'package:flutter/material.dart';

class BookingError extends StatelessWidget {
  final String message;
  const BookingError({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(message, style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}
