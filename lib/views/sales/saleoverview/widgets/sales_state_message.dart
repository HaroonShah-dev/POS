import 'package:flutter/material.dart';

class SalesStateMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color color;

  const SalesStateMessage({
    super.key,
    required this.icon,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: color),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
