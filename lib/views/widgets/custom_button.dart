import 'package:flutter/material.dart';
import 'package:store_management_system/views/products/widgets/add_product.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: ElevatedButton.icon(
        onPressed: () {
          showAddProductDialog(context);
        },
        icon: const Icon(Icons.add, size: 20, color: Colors.white),
        label: const Text(
          'Add New',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
