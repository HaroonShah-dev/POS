import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/models/sales_model.dart';
import 'package:store_management_system/views/products/widgets/product_search_bar.dart';
import 'package:store_management_system/views/sales/saleoverview/widgets/sales_card.dart';
import 'package:store_management_system/views/sales/saleoverview/widgets/sales_state_message.dart';
import 'package:store_management_system/views/sales/sales_view_model.dart';

class SalesOverview extends StatelessWidget {
  const SalesOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final viewmodel = context.read<SalesViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sales Overview'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ProductSearchBar(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StreamBuilder<List<SaleModel>>(
              stream: viewmodel.listenSale(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SalesStateMessage(
                    icon: Icons.error_outline_rounded,
                    message: 'Something went wrong',
                    color: Colors.red.shade300,
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final sales = snapshot.data ?? [];

                if (sales.isEmpty) {
                  return SalesStateMessage(
                    icon: Icons.receipt_long_outlined,
                    message: 'No sales yet',
                    color: Colors.grey.shade400,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: sales.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final sale = sales[index];
                    return SaleCard(sale: sale);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
