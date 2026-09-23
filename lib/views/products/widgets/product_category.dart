import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/products/product_view_model.dart';

class ProductCategory extends StatefulWidget {
  final Function(String) onCategorySelected;
  const ProductCategory({super.key, required this.onCategorySelected});

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  String selectedCategory = 'All Categories';

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProductViewModel>();

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        border: Border.all(color: AppColors.textPrimary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: viewModel.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading categories'));
          }

          final categories = <String>['All Categories'];

          if (snapshot.hasData) {
            for (final document in snapshot.data!.docs) {
              final categoryName = document.data()['categoryName'];

              if (categoryName != null && categoryName.toString().isNotEmpty) {
                categories.add(categoryName.toString());
              }
            }
          }

          if (!categories.contains(selectedCategory)) {
            selectedCategory = 'All Categories';
          }

          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedCategory = value;
                });
                widget.onCategorySelected(value);
              },
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Row(
                    children: [
                      const Icon(Icons.category_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text(category),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
