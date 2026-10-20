import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';

class ReportDateRangeButton extends StatelessWidget {
  final DateTimeRange? range;
  final ValueChanged<DateTimeRange> onPicked;

  const ReportDateRangeButton({
    super.key,
    required this.range,
    required this.onPicked,
  });

  String _fmt(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final label = range == null
        ? 'Select date range'
        : '${_fmt(range!.start)}  →  ${_fmt(range!.end)}';

    return OutlinedButton.icon(
      onPressed: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: range,
        );
        if (picked != null) onPicked(picked);
      },
      icon: const Icon(
        Icons.calendar_month_rounded,
        size: 18,
        color: AppColors.primary,
      ),
      label: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, AppDimensions.buttonHeight),
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceLg - 4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }
}
