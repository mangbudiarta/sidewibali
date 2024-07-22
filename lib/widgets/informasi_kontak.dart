import 'package:flutter/material.dart';

class BarisInfoKontak extends StatelessWidget {
  final IconData icon;
  final String text;

  const BarisInfoKontak({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
