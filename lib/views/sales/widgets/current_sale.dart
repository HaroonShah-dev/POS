import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';

class CurrentSale extends StatelessWidget {
  const CurrentSale({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Current Sale', style: AppTextStyles.h1),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Clear Sale',
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                _SaleItem(name: 'Milk', quantity: 2, price: 300),
                _SaleItem(name: 'Bread', quantity: 1, price: 100),
              ],
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                _SummaryRow(title: 'Subtotal', value: 'Rs. 700'),
                const SizedBox(height: 8),
                _SummaryRow(title: 'Discount', value: 'Rs. 0'),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                _SummaryRow(title: 'Total', value: 'Rs. 700', isTotal: true),
                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('COMPLETE SALE'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleItem extends StatelessWidget {
  final String name;
  final int quantity;
  final double price;

  const _SaleItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            '$quantity × Rs. ${price.toStringAsFixed(0)}',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
          const SizedBox(width: 12),
          Text(
            'Rs. ${(quantity * price).toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.title,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 17 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppColors.primary : null,
          ),
        ),
      ],
    );
  }
}
