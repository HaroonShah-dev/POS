import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/models/sales_model.dart';
import 'package:store_management_system/views/reports/report_model.dart';
import 'package:store_management_system/views/reports/widgets/download_report.dart';
import 'package:store_management_system/views/reports/widgets/report_bar_chart.dart';
import 'package:store_management_system/views/reports/widgets/report_calculator.dart';
import 'package:store_management_system/views/reports/widgets/report_date_range_button.dart';
import 'package:store_management_system/views/reports/widgets/report_header.dart';
import 'package:store_management_system/views/reports/widgets/report_panel.dart';
import 'package:store_management_system/views/reports/widgets/report_period_selector.dart';
import 'package:store_management_system/views/reports/widgets/report_summary_card.dart';
import 'package:store_management_system/views/reports/widgets/report_top_products.dart';
import 'package:store_management_system/views/sales/sales_view_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportPeriod _period = ReportPeriod.daily;
  DateTimeRange? _range;
  late Stream<List<SaleModel>> _stream;

  @override
  void initState() {
    super.initState();
    _loadStream();
  }

  void _loadStream() {
    final w = ReportCalculator.window(_period, _range);
    _stream = context.read<SalesViewModel>().listenSalesBetween(
      w.prevStart,
      w.end,
    );
  }

  void _showSoon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('$what export coming soon'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
        titleTextStyle: AppTextStyles.h4.copyWith(
          color: AppColors.textOnPrimary,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReportHeader(
              onExportPdf: () => _showSoon('PDF'),
              onExportExcel: () => _showSoon('Excel'),
            ),
            const SizedBox(height: AppDimensions.spaceLg),

            // ---------- Filters ----------
            Wrap(
              spacing: AppDimensions.spaceSm + 4,
              runSpacing: AppDimensions.spaceSm + 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ReportPeriodSelector(
                  selected: _period,
                  onChanged: (p) => setState(() {
                    _period = p;
                    _range = null; // preset overrides custom range
                    _loadStream();
                  }),
                ),
                ReportDateRangeButton(
                  range: _range,
                  onPicked: (r) => setState(() {
                    _range = r; // custom range overrides preset window
                    _loadStream();
                  }),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceLg),

            Align(
              alignment: AlignmentGeometry.topRight,
              child: DownloadReport(),
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            // ---------- Live data ----------
            StreamBuilder<List<SaleModel>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return SizedBox(
                    height: 300,
                    child: Center(
                      child: Text(
                        'Something went wrong',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                final data = ReportCalculator.build(
                  snapshot.data ?? [],
                  _period,
                  _range,
                );
                return _ReportBody(data: data);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  final ReportData data;
  const _ReportBody({required this.data});

  @override
  Widget build(BuildContext context) {
    const gap = AppDimensions.spaceMd;

    return Column(
      children: [
        // ---------- Summary cards ----------
        LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final cardWidth = w > 1000
                ? (w - gap * 3) / 4
                : w > 600
                ? (w - gap) / 2
                : w;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: data.summaries
                  .map(
                    (s) => SizedBox(
                      width: cardWidth,
                      child: ReportSummaryCard(
                        data: s,
                        title: 'Click Here To Downloads',
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: AppDimensions.spaceLg),

        // ---------- Chart + Top products ----------
        LayoutBuilder(
          builder: (context, constraints) {
            final chartPanel = ReportPanel(
              title: 'Sales Trend',
              subtitle: data.chartTitle,
              child: ReportBarChart(points: data.chart),
            );
            final productsPanel = ReportPanel(
              title: 'Top Products',
              subtitle: 'Best sellers this period',
              child: data.topProducts.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No sales in this period',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    )
                  : ReportTopProducts(items: data.topProducts),
            );

            if (constraints.maxWidth < 900) {
              return Column(
                children: [
                  chartPanel,
                  const SizedBox(height: AppDimensions.spaceLg - 4),
                  productsPanel,
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: chartPanel),
                const SizedBox(width: AppDimensions.spaceLg - 4),
                Expanded(flex: 2, child: productsPanel),
              ],
            );
          },
        ),
      ],
    );
  }
}
