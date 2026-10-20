import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/products/widgets/product_category.dart';
import 'package:store_management_system/views/products/widgets/product_filter.dart';
import 'package:store_management_system/views/products/widgets/product_search_bar.dart';
import 'package:store_management_system/views/products/widgets/product_table.dart';
import 'package:store_management_system/views/widgets/custom_button.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String selectedCategory = "All Category";
  String selectedFilter = 'All';
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Header ----------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Products',
                          style: AppTextStyles.h1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage your store products',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  CustomButton(),
                ],
              ),

              const SizedBox(height: 24),

              // ---------- Filters panel ----------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _panelDecoration(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 700;

                    final searchField = ProductSearchBar(
                      onChanged: (value) {
                        setState(() => searchText = value);
                      },
                    );

                    final categoryField = ProductCategory(
                      onCategorySelected: (category) {
                        setState(() => selectedCategory = category);
                      },
                    );

                    final filterField = ProductFilter(
                      onFilterSelected: (filter) {
                        setState(() => selectedFilter = filter);
                      },
                    );

                    if (isNarrow) {
                      // Stack vertically on narrow screens
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          searchField,
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: categoryField),
                              const SizedBox(width: 12),
                              Expanded(child: filterField),
                            ],
                          ),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(flex: 2, child: searchField),
                        const SizedBox(width: 12),
                        Expanded(child: categoryField),
                        const SizedBox(width: 12),
                        Expanded(child: filterField),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ---------- Product table panel ----------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _panelDecoration(),
                child: ProductTable(
                  selectedCategory: selectedCategory,
                  selectedFilter: selectedFilter,
                  searchText: searchText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

BoxDecoration _panelDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.03),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
