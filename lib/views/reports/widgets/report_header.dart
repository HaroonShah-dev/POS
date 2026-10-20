import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';

class ReportHeader extends StatelessWidget {
  final VoidCallback onExportPdf;
  final VoidCallback onExportExcel;

  const ReportHeader({
    super.key,
    required this.onExportPdf,
    required this.onExportExcel,
  });

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
    );

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: AppDimensions.spaceMd,
      spacing: AppDimensions.spaceMd,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Reports', style: AppTextStyles.h2),
            const SizedBox(height: AppDimensions.spaceXs),
            Text(
              'View and download your sales reports',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: onExportPdf,
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
              label: const Text('Export PDF'),
              style: OutlinedButton.styleFrom(
                // Theme sets width = infinity; override so it works inside Row/Wrap
                minimumSize: const Size(0, AppDimensions.buttonHeight),
                foregroundColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceLg,
                ),
                shape: shape,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSm + 4),
            ElevatedButton.icon(
              onPressed: onExportExcel,
              icon: const Icon(Icons.table_chart_rounded, size: 18),
              label: const Text('Export Excel'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, AppDimensions.buttonHeight),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceLg,
                ),
                shape: shape,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
