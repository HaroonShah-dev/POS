import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/models/sales_model.dart';
import 'package:store_management_system/views/sales/saleoverview/widgets/sales_card.dart';
import 'package:store_management_system/views/sales/saleoverview/widgets/sales_state_message.dart';
import 'package:store_management_system/views/sales/saleoverview/widgets/search_invoice.dart';
import 'package:store_management_system/views/sales/sales_view_model.dart';

class SalesOverview extends StatefulWidget {
  const SalesOverview({super.key});

  @override
  State<SalesOverview> createState() => _SalesOverviewState();
}

class _SalesOverviewState extends State<SalesOverview> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SaleModel> _filterSales(List<SaleModel> sales) {
    final query = _searchText.trim().toLowerCase();
    if (query.isEmpty) return sales;

    return sales.where((sale) {
      final invoiceMatch = sale.invoiceNumber.toLowerCase().contains(query);
      return invoiceMatch;
    }).toList();
  }

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchInvoice(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchText = value),
            ),
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

                final allSales = snapshot.data ?? [];
                final sales = _filterSales(allSales);

                if (allSales.isEmpty) {
                  return SalesStateMessage(
                    icon: Icons.receipt_long_outlined,
                    message: 'No sales yet',
                    color: Colors.grey.shade400,
                  );
                }

                if (sales.isEmpty) {
                  return SalesStateMessage(
                    icon: Icons.search_off_rounded,
                    message: 'No matching invoices found',
                    color: Colors.grey.shade400,
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: sales.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    return SaleCard(sale: sales[index]);
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
