import 'package:flutter/material.dart';
import 'package:store_management_system/views/products/widgets/add_product.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({super.key});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 700),
      child: SizedBox(
        width: 190,
        child: ElevatedButton.icon(
          onPressed: () {
            showAddProductDialog(context);
          },
          icon: const Icon(Icons.add, size: 20, color: Colors.white),
          label: const Text(
            "Add New",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context)
                .primaryColor, // Pulls your main app color
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                12,
              ), // Sleek modern rounded corners
            ),
            elevation: 2, // Subtle professional depth shadow
          ),
        ),
      ),
    );
  }
}
