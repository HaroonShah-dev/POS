import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/models/product_model.dart';
import 'package:store_management_system/views/products/product_view_model.dart';
import 'package:store_management_system/views/sales/sales_view_model.dart';
import 'package:store_management_system/views/sales/widgets/sales_product_card.dart';

class SalesProductGrid extends StatelessWidget {
  final String searchText;
  final String selectedCategory;

  const SalesProductGrid({
    super.key,
    required this.searchText,
    required this.selectedCategory,
  });

  int _columnsForWidth(double width) {
    if (width >= 500) return 3;
    if (width >= 350) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<ProductViewModel>();

    return StreamBuilder<QuerySnapshot>(
      stream: viewmodel.getFilteredProducts(
        selectedFilter: searchText,
        selectedCategory: selectedCategory,
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        final search = searchText.trim().toLowerCase();

        final allProducts = snapshot.data!.docs
            .map(
              (doc) => ProductModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList();

        final filteredProducts = search.isEmpty
            ? allProducts
            : allProducts.where((product) {
                final name = product.productName.toLowerCase();
                final category = product.category.toLowerCase();
                return name.contains(search) || category.contains(search);
              }).toList();

        if (filteredProducts.isEmpty) {
          return Center(child: Text('No products match "$searchText"'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 16.0;

            // 👇 explicit breakpoints instead of dividing by a max card width
            final columns = _columnsForWidth(constraints.maxWidth);

            final cardWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;
            final cardHeight = (cardWidth * 0.70).clamp(120.0, 170.0);
            final aspectRatio = cardWidth / cardHeight;

            return GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: aspectRatio,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                return SalesProductCard(
                  name: product.productName,
                  category: product.category,
                  price: product.price,
                  stock: product.stock,
                  onTap: () {
                    context.read<SalesViewModel>().addProductToSale(product);
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
