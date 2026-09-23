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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: AppColors.background),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Products', style: AppTextStyles.h1),
                    Text(
                      'Manage your store products  ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ProductSearchBar(
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ProductCategory(
                      onCategorySelected: (category) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ProductFilter(
                      onFilterSelected: (filter) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 160),
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
