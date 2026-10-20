import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/reports/report_model.dart';

class ReportTopProducts extends StatelessWidget {
  final List<TopProduct> items;

  const ReportTopProducts({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final maxAmount = items.isEmpty
        ? 0.0
        : items.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        final fraction = maxAmount == 0 ? 0.0 : item.amount / maxAmount;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                child: Text(
                  '${i + 1}',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceSm + 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceSm),
                        Text(
                          'Rs. ${formatNumber(item.amount)}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${item.quantity} sold',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusFull,
                      ),
                      child: LinearProgressIndicator(
                        value: fraction,
                        minHeight: 6,
                        color: AppColors.primary,
                        backgroundColor: AppColors.surfaceMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
