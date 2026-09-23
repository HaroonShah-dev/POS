import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/models/product_model.dart';
import 'package:store_management_system/views/products/widgets/add_product.dart';

import '../product_view_model.dart';

class ProductTable extends StatelessWidget {
  final String selectedCategory;
  final String selectedFilter;
  final String searchText;

  const ProductTable({
    super.key,
    required this.selectedCategory,
    required this.selectedFilter,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ProductViewModel>();

    return StreamBuilder(
      stream: viewModel.getFilteredProducts(
        selectedCategory: selectedCategory,
        selectedFilter: selectedFilter,
      ),

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: Text('No products found', style: AppTextStyles.bodyLarge),
          );
        }

        final search = searchText.trim().toLowerCase();

        final documents = snapshot.data!.docs.where((document) {
          // Convert Firebase document to ProductModel
          final product = ProductModel.fromFirestore(document);

          if (search.isEmpty) {
            return true;
          }

          return product.productName.toLowerCase().contains(search) ||
              product.category.toLowerCase().contains(search);
        }).toList();

        if (documents.isEmpty) {
          return const Center(
            child: Text('No products found', style: AppTextStyles.bodyLarge),
          );
        }

        return Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primaryDark),
          ),

          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: DataTable(
              columns: const [
                DataColumn(label: Text('Product', style: AppTextStyles.price)),

                DataColumn(label: Text('Category', style: AppTextStyles.price)),

                DataColumn(label: Text('Price', style: AppTextStyles.price)),

                DataColumn(label: Text('Stock', style: AppTextStyles.price)),

                DataColumn(label: Text('Status', style: AppTextStyles.price)),

                DataColumn(label: Text('Actions', style: AppTextStyles.price)),
              ],

              rows: documents.map((document) {
                final product = ProductModel.fromFirestore(document);

                return DataRow(
                  cells: [
                    // Product
                    DataCell(
                      Text(product.productName, style: AppTextStyles.h4),
                    ),

                    // Category
                    DataCell(Text(product.category, style: AppTextStyles.h4)),

                    // Price
                    DataCell(
                      Text(
                        'Rs. ${product.price.toStringAsFixed(2)}',
                        style: AppTextStyles.h4,
                      ),
                    ),

                    // Stock
                    DataCell(
                      Text(product.stock.toString(), style: AppTextStyles.h4),
                    ),

                    // Status
                    DataCell(_StockStatus(stock: product.stock)),

                    // Actions
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Edit
                          IconButton(
                            tooltip: 'Edit',

                            onPressed: () {
                              showAddProductDialog(context, product: product);
                            },

                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: AppColors.primary,
                            ),
                          ),

                          // Delete
                          IconButton(
                            tooltip: 'Delete',

                            onPressed: () async {
                              final shouldDelete = await showDialog<bool>(
                                context: context,

                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Product'),

                                    content: Text(
                                      'Are you sure you want to delete '
                                      '"${product.productName}"?',
                                    ),

                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text('Cancel'),
                                      ),

                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (shouldDelete == true) {
                                // await viewModel.deleteProduct(product.id);
                              }
                            },

                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

/// Shows stock status
class _StockStatus extends StatelessWidget {
  final int stock;

  const _StockStatus({required this.stock});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    if (stock == 0) {
      text = 'Out of Stock';
      color = Colors.red;
    } else if (stock <= 10) {
      text = 'Low Stock';
      color = Colors.orange;
    } else {
      text = 'In Stock';
      color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
