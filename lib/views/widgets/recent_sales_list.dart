import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/core/utils/time_ago.dart';
import 'package:store_management_system/views/dashboard/dashboard_view_model.dart';

class RecentSalesList extends StatelessWidget {
  const RecentSalesList({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardViewModel>();

    if (dashboard.isLoadingRecentSales) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (dashboard.recentSales.isEmpty) {
      return Center(child: Text('No recent sales', style: AppTextStyles.label));
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: dashboard.recentSales.length,
      separatorBuilder: (_, _) =>
          Divider(height: 16, color: Colors.grey.shade100),
      itemBuilder: (context, index) {
        final sale = dashboard.recentSales[index];
        return _RecentSaleTile(
          invoiceNumber: sale['invoiceNumber'],
          total: sale['total'],
          itemCount: sale['itemCount'],
          createdAt: sale['createdAt'],
        );
      },
    );
  }
}

class _RecentSaleTile extends StatelessWidget {
  final String invoiceNumber;
  final double total;
  final int itemCount;
  final DateTime createdAt;

  const _RecentSaleTile({
    required this.invoiceNumber,
    required this.total,
    required this.itemCount,
    required this.createdAt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.green.withOpacity(0.1),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sale completed • $invoiceNumber',
                style: AppTextStyles.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '$itemCount item${itemCount == 1 ? '' : 's'} • Rs. ${total.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          timeAgo(createdAt),
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }
}
