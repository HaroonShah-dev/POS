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
          return const _TableLoadingState();
        }

        if (snapshot.hasError) {
          return _TableEmptyState(
            icon: Icons.error_outline_rounded,
            message: 'Error: ${snapshot.error}',
            isError: true,
          );
        }

        if (!snapshot.hasData) {
          return const _TableEmptyState(
            icon: Icons.inventory_2_outlined,
            message: 'No products found',
          );
        }

        final search = searchText.trim().toLowerCase();

        final documents = snapshot.data!.docs.where((document) {
          final product = ProductModel.fromFirestore(document);

          if (search.isEmpty) return true;

          return product.productName.toLowerCase().contains(search) ||
              product.category.toLowerCase().contains(search);
        }).toList();

        if (documents.isEmpty) {
          return const _TableEmptyState(
            icon: Icons.search_off_rounded,
            message: 'No products match your filters',
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  columnSpacing: 28,
                  horizontalMargin: 4,
                  dataRowMinHeight: 56,
                  dataRowMaxHeight: 60,
                  headingRowHeight: 48,
                  headingRowColor: WidgetStateProperty.all(
                    AppColors.background,
                  ),
                  headingTextStyle: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.3,
                  ),
                  dividerThickness: 1,
                  columns: const [
                    DataColumn(label: Text('Product')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Stock')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: documents.map((document) {
                    final product = ProductModel.fromFirestore(document);

                    return DataRow(
                      cells: [
                        DataCell(
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: Text(
                              product.productName,
                              style: AppTextStyles.h4,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            product.category,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            'Rs. ${product.price.toStringAsFixed(2)}',
                            style: AppTextStyles.h4.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            product.stock.toString(),
                            style: AppTextStyles.h4.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        DataCell(_StockStatus(stock: product.stock)),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ActionIcon(
                                icon: Icons.edit_outlined,
                                tooltip: 'Edit',
                                color: AppColors.primary,
                                onPressed: () {
                                  showAddProductDialog(
                                    context,
                                    product: product,
                                  );
                                },
                              ),
                              const SizedBox(width: 4),
                              _ActionIcon(
                                icon: Icons.delete_outline_rounded,
                                tooltip: 'Delete',
                                color: Colors.red.shade400,
                                onPressed: () async {
                                  final shouldDelete = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      title: const Text('Delete Product'),
                                      content: Text(
                                        'Are you sure you want to delete '
                                        '"${product.productName}"? This cannot be undone.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.red.shade500,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (shouldDelete == true) {
                                    // await viewModel.deleteProduct(product.id);
                                  }
                                },
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
      },
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onPressed;

  const _ActionIcon({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, size: 19, color: color),
          ),
        ),
      ),
    );
  }
}

/// Stock status badge
class _StockStatus extends StatelessWidget {
  final int stock;

  const _StockStatus({required this.stock});

  @override
  Widget build(BuildContext context) {
    late final String text;
    late final Color color;

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
        color: color.withOpacity(0.1), // was solid `color` — text was invisible
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color
              .shade800Safe(), // darker readable shade of the badge color
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Small helper since MaterialColor.shade800 only exists on MaterialColor,
/// not plain Color — this keeps the badge text readable for any base color.
extension on Color {
  Color shade800Safe() {
    if (this == Colors.red) return Colors.red.shade800;
    if (this == Colors.orange) return Colors.orange.shade800;
    if (this == Colors.green) return Colors.green.shade800;
    return this;
  }
}

class _TableLoadingState extends StatelessWidget {
  const _TableLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ),
    );
  }
}

class _TableEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final bool isError;

  const _TableEmptyState({
    required this.icon,
    required this.message,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 36,
              color: isError ? Colors.red.shade300 : Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isError ? Colors.red.shade400 : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
