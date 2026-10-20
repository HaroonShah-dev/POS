import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/services/pdf_services.dart';
import 'package:store_management_system/views/auth/authViewModel/auth_view_model.dart';
import 'package:store_management_system/views/sales/sales_view_model.dart';

class DownloadReport extends StatefulWidget {
  const DownloadReport({super.key});

  @override
  State<DownloadReport> createState() => _DownloadReportState();
}

class _DownloadReportState extends State<DownloadReport> {
  bool _isGenerating = false;

  Future<void> _generateReport({required bool preview}) async {
    if (_isGenerating) return;

    setState(() => _isGenerating = true);

    try {
      final authViewModel = context.read<AuthViewModel>();
      final salesViewModel = context.read<SalesViewModel>();

      final results = await Future.wait([
        salesViewModel.sales().first,
        authViewModel.getUserData(),
      ]);

      final sales = results[0] as dynamic;
      final userInfo = results[1] as Map<String, dynamic>;

      if (!mounted) return;

      final managerName = userInfo['fullName']?.toString() ?? 'Not available';
      final storeAddress = userInfo['storeName']?.toString() ?? 'Not available';

      if (preview) {
        previewPdf(
          context,
          sales: sales,
          managerName: managerName,
          storeAddress: storeAddress,
        );
      } else {
        final filePath = await savePdf(
          sales: sales,
          managerName: managerName,
          storeAddress: storeAddress,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report saved: $filePath'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to generate report: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  color: primaryColor,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sales Report',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Generate and export your report',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.65,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isGenerating
                  ? null
                  : () => _generateReport(preview: false),
              icon: _isGenerating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.download_rounded),
              label: Text(
                _isGenerating ? 'Generating Report...' : 'Download PDF',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                disabledBackgroundColor: primaryColor.withValues(alpha: 0.55),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _isGenerating
                  ? null
                  : () => _generateReport(preview: true),
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Preview Report'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
