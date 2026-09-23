import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/models/product_model.dart';
import 'package:store_management_system/views/products/product_view_model.dart';
import 'package:store_management_system/views/sales/widgets/sales_product_card.dart';

class SalesProductGrid extends StatelessWidget {
  final String searchText;
  final String selectedCategory;

  const SalesProductGrid({
    super.key,
    required this.searchText,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<ProductViewModel>();

    return StreamBuilder<QuerySnapshot>(
      stream: viewmodel.getProduct(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        final allProducts = snapshot.data!.docs
            .map(
              (doc) => ProductModel.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList();

        return GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisExtent: 150,
            crossAxisSpacing: 19,
            mainAxisSpacing: 19,
          ),
          itemCount: allProducts.length,
          itemBuilder: (context, index) {
            final product = allProducts[index];

            return SalesProductCard(
              name: product.productName,
              category: product.category,
              price: product.price,
              stock: product.stock,
              onTap: () {
                context.read<ProductViewModel>().getProduct();
              },
            );
          },
        );
      },
    );
  }
}
