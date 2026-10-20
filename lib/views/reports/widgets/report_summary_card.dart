import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/reports/report_model.dart';
import 'package:store_management_system/views/sales/saleoverview/sales_over_view.dart';

class ReportSummaryCard extends StatelessWidget {
  final String? title;
  final ReportSummary data;

  const ReportSummaryCard({super.key, required this.data, required this.title});

  @override
  Widget build(BuildContext context) {
    final changeColor = data.isPositive ? AppColors.success : AppColors.error;
    final changeBg = data.isPositive ? AppColors.successBg : AppColors.errorBg;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(data.icon, color: AppColors.primary, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: changeBg,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      data.isPositive
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 12,
                      color: changeColor,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      data.change,
                      style: AppTextStyles.statusBadge.copyWith(
                        color: changeColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            data.title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          Text(
            data.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          const SizedBox(height: AppDimensions.spaceXs),
          Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalesOverview()),
                  );
                },
                mouseCursor: MouseCursor.uncontrolled,
                focusColor: AppColors.primary,
                hoverColor: AppColors.primary,
                child: Text(
                  title!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.info),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
