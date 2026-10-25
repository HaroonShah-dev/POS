import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/services/pdf_services.dart';
import 'package:store_management_system/views/auth/authViewModel/auth_view_model.dart';
import 'package:store_management_system/views/sales/sales_view_model.dart';

class DownloadReport extends StatefulWidget {
  final DateTimeRange? range;
  const DownloadReport({super.key, required this.range});

  @override
  State<DownloadReport> createState() => _DownloadReportState();
}

class _DownloadReportState extends State<DownloadReport> {
  bool _isGenerating = false;

  bool _isPreviewing = false;
  void _toast(String message, {required Color color, required IconData icon}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }

  Future<void> _generateReport({required bool preview}) async {
    if (_isGenerating) return;
    setState(() {
      _isGenerating = true;
      _isPreviewing = preview;
    });

    try {
      final authViewModel = context.read<AuthViewModel>();
      final salesViewModel = context.read<SalesViewModel>();

      final now = DateTime.now();
      final range = widget.range ?? DateTimeRange(start: now, end: now);

      final start = DateTime(
        range.start.year,
        range.start.month,
        range.start.day,
      );

      final end = DateTime(range.end.year, range.end.month, range.end.day + 1);

      final salesFuture = salesViewModel.listenSalesBetween(start, end).first;
      final userFuture = authViewModel.getUserData();

      final sales = await salesFuture;
      final userInfo = await userFuture;

      if (!mounted) return;

      if (sales.isEmpty) {
        _toast(
          'No sales found for the selected dates',
          color: AppColors.warning,
          icon: Icons.info_outline_rounded,
        );
        return;
      }

      final managerName = userInfo['fullName']?.toString() ?? 'Not available';
      final storeAddress = userInfo['storeName']?.toString() ?? 'Not available';

      if (preview) {
        previewPdf(
          context,
          sales: sales,
          managerName: managerName,
          storeAddress: storeAddress,
          range: range,
        );
      } else {
        final filePath = await savePdf(
          sales: sales,
          managerName: managerName,
          storeAddress: storeAddress,
          range: widget.range,
        );

        if (!mounted) return;

        _toast(
          'Report saved: $filePath',
          color: AppColors.success,
          icon: Icons.check_circle_outline_rounded,
        );
      }
    } catch (error) {
      if (!mounted) return;
      _toast(
        'Unable to generate report: $error',
        color: Theme.of(context).colorScheme.error,
        icon: Icons.error_outline_rounded,
      );
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final onPrimary = theme.colorScheme.onPrimary;

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );
    const padding = EdgeInsets.symmetric(horizontal: 18, vertical: 14);
    const minSize = Size(0, 46);

    final downloading = _isGenerating && !_isPreviewing;
    final previewing = _isGenerating && _isPreviewing;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // ---------- Preview ----------
        Tooltip(
          message: 'Open a preview of the report',
          child: OutlinedButton.icon(
            onPressed: _isGenerating
                ? null
                : () => _generateReport(preview: true),
            icon: _ButtonIcon(
              loading: previewing,
              icon: Icons.visibility_outlined,
              color: primary,
            ),
            label: Text(previewing ? 'Preparing...' : 'Preview'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primary,
              minimumSize: minSize,
              padding: padding,
              shape: shape,
              side: BorderSide(
                color: _isGenerating
                    ? primary.withValues(alpha: 0.2)
                    : primary.withValues(alpha: 0.5),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),

        // ---------- Download ----------
        Tooltip(
          message: 'Save the report as a PDF',
          child: FilledButton.icon(
            onPressed: _isGenerating
                ? null
                : () => _generateReport(preview: false),
            icon: _ButtonIcon(
              loading: downloading,
              icon: Icons.download_rounded,
              color: onPrimary,
            ),
            label: Text(downloading ? 'Generating...' : 'Download PDF'),
            style: FilledButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: onPrimary,
              disabledBackgroundColor: primary.withValues(alpha: 0.45),
              disabledForegroundColor: onPrimary.withValues(alpha: 0.9),
              minimumSize: minSize,
              padding: padding,
              shape: shape,
              elevation: 0,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Icon that cross-fades into a small spinner while loading.
class _ButtonIcon extends StatelessWidget {
  final bool loading;
  final IconData icon;
  final Color color;
  const _ButtonIcon({
    required this.loading,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: loading
            ? Padding(
                key: const ValueKey('spinner'),
                padding: const EdgeInsets.all(2),
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: color,
                ),
              )
            : Icon(icon, key: const ValueKey('icon'), size: 20),
      ),
    );
  }
}
