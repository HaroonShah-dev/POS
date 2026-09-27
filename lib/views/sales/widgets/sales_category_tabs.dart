import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/products/product_view_model.dart';

class SalesCategoryTabs extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const SalesCategoryTabs({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  State<SalesCategoryTabs> createState() => _SalesCategoryTabsState();
}

class _SalesCategoryTabsState extends State<SalesCategoryTabs> {
  static const double _tabsHeight = 40;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProductViewModel>();

    return SizedBox(
      height: _tabsHeight, // 👈 fixed height, same whether loading or loaded
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: viewModel.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          if (snapshot.hasError) {
            return const Align(
              alignment: Alignment.centerLeft,
              child: Text('Error loading categories'),
            );
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

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = widget.selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (value) {
                      widget.onCategorySelected(category);
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
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
