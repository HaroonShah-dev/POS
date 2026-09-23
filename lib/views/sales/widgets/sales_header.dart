import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';

class SalesHeader extends StatelessWidget {
  const SalesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sales', style: AppTextStyles.h1),
              const SizedBox(height: 4),
              Text(
                'Create and manage your sales',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        SizedBox(
          width: 130,
          height: 42,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('New Sale'),
          ),
        ),
      ],
    );
  }
}
