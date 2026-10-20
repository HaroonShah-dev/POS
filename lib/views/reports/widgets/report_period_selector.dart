import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/reports/report_model.dart';

class ReportPeriodSelector extends StatelessWidget {
  final ReportPeriod selected;
  final ValueChanged<ReportPeriod> onChanged;

  const ReportPeriodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // 4 (padding) + 44 (item) + 4 (padding) = 52 = AppDimensions.buttonHeight,
    // so it lines up with the date button next to it.
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ReportPeriod.values.map((period) {
          final isSelected = period == selected;
          return InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            onTap: () => onChanged(period),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 44,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceLg - 4,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Text(
                period.label,
                style: AppTextStyles.label.copyWith(
                  fontSize: 13.5,
                  color: isSelected
                      ? AppColors.textOnPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
