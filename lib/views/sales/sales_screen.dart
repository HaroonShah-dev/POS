import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/products/widgets/product_search_bar.dart';

import 'widgets/current_sale.dart';
import 'widgets/sales_category_tabs.dart';
import 'widgets/sales_header.dart';
import 'widgets/sales_product_grid.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  String selectedCategory = 'All';
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SalesHeader(),

              const SizedBox(height: 24),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductSearchBar(
                            onChanged: (value) {
                              setState(() => searchText = value);
                            },
                          ),

                          const SizedBox(height: 16),

                          SalesCategoryTabs(
                            selectedCategory: selectedCategory,
                            onCategorySelected: (category) {
                              setState(() => selectedCategory = category);
                            },
                          ),

                          const SizedBox(height: 20),

                          Expanded(
                            child: SalesProductGrid(
                              searchText: searchText,
                              selectedCategory: selectedCategory,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Cart always stays side-by-side, fixed width,
                    // completely unaffected by grid column count.
                    const SizedBox(width: 360, child: CurrentSale()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
