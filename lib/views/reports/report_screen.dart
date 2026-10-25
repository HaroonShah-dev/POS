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

/// Max content width so the layout stays readable on very wide screens.
const double _kMaxContentWidth = 1400;

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
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text('$what export coming soon')),
            ],
          ),
          backgroundColor: AppColors.warning,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 600;
    final pad = isCompact ? AppDimensions.spaceMd : AppDimensions.spaceLg;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reports'),
        titleTextStyle: AppTextStyles.h4.copyWith(
          color: AppColors.textOnPrimary,
          letterSpacing: 0.3,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryLight,
                AppColors.primaryLight.withValues(alpha: 0.85),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(pad),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FadeSlide(
                      child: ReportHeader(
                        onExportPdf: () => _showSoon('PDF'),
                        onExportExcel: () => _showSoon('Excel'),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceLg),

                    // ---------- Filters ----------
                    _FadeSlide(
                      delay: 60,
                      child: _FilterBar(
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
                              _range = r; // custom range overrides preset
                              _loadStream();
                            }),
                          ),
                          DownloadReport(range: _range),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceLg),

                    // ---------- Live data ----------
                    StreamBuilder<List<SaleModel>>(
                      stream: _stream,
                      builder: (context, snapshot) {
                        Widget child;
                        if (snapshot.hasError) {
                          child = const _StateMessage(
                            key: ValueKey('error'),
                            icon: Icons.error_outline_rounded,
                            message: 'Something went wrong',
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          child = const _LoadingSkeleton(
                            key: ValueKey('loading'),
                          );
                        } else {
                          final data = ReportCalculator.build(
                            snapshot.data ?? [],
                            _period,
                            _range,
                          );
                          child = _ReportBody(
                            key: const ValueKey('data'),
                            data: data,
                          );
                        }
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: child,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Reusable UI pieces
// ===========================================================================

/// Soft fade + upward slide used for a subtle entrance animation.
class _FadeSlide extends StatelessWidget {
  final Widget child;
  final int delay; // ms
  const _FadeSlide({required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 14),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

/// Filter row wrapped in a subtle card so controls feel grouped.
class _FilterBar extends StatelessWidget {
  final List<Widget> children;
  const _FilterBar({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMd,
        vertical: AppDimensions.spaceSm + 4,
      ),
      decoration: _cardDecoration(),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: AppDimensions.spaceSm + 4,
        runSpacing: AppDimensions.spaceSm + 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.12)),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ],
);

/// Small section label with an accent bar.
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm + 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Centered icon + message used for error / empty states.
class _StateMessage extends StatelessWidget {
  final IconData icon;
  final String message;
  final double height;
  const _StateMessage({
    super.key,
    required this.icon,
    required this.message,
    this.height = 300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textSecondary.withValues(alpha: 0.08),
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceSm + 4),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pulsing placeholder block for the loading skeleton.
class _PulseBox extends StatefulWidget {
  final double height;
  const _PulseBox({required this.height});

  @override
  State<_PulseBox> createState() => _PulseBoxState();
}

class _PulseBoxState extends State<_PulseBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) => Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(
            alpha: 0.06 + 0.07 * _c.value,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

/// Skeleton shown while the stream is loading (replaces the lone spinner).
class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    const gap = AppDimensions.spaceMd;
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final cardWidth = w > 1000
            ? (w - gap * 3) / 4
            : w > 600
            ? (w - gap) / 2
            : w;
        return Column(
          children: [
            Wrap(
              spacing: gap,
              runSpacing: gap,
              children: List.generate(
                4,
                (_) => SizedBox(
                  width: cardWidth,
                  child: const _PulseBox(height: 110),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceLg),
            const _PulseBox(height: 300),
          ],
        );
      },
    );
  }
}

// ===========================================================================
// Report body
// ===========================================================================

class _ReportBody extends StatelessWidget {
  final ReportData data;
  const _ReportBody({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    const gap = AppDimensions.spaceMd;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- Summary cards ----------
        const _SectionLabel('OVERVIEW'),
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
              children: [
                for (var i = 0; i < data.summaries.length; i++)
                  _FadeSlide(
                    delay: i * 70,
                    child: SizedBox(
                      width: cardWidth,
                      child: ReportSummaryCard(
                        data: data.summaries[i],
                        title:
                            '${data.summaries[i].title}  (${data.summaries.length}) ',
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: AppDimensions.spaceLg + 4),

        // ---------- Chart + Top products ----------
        const _SectionLabel('ANALYTICS'),
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
                  ? const _StateMessage(
                      icon: Icons.inventory_2_outlined,
                      message: 'No sales in this period',
                      height: 180,
                    )
                  : ReportTopProducts(items: data.topProducts),
            );

            if (constraints.maxWidth < 900) {
              return Column(
                children: [
                  _FadeSlide(delay: 120, child: chartPanel),
                  const SizedBox(height: AppDimensions.spaceLg - 4),
                  _FadeSlide(delay: 180, child: productsPanel),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _FadeSlide(delay: 120, child: chartPanel),
                ),
                const SizedBox(width: AppDimensions.spaceLg - 4),
                Expanded(
                  flex: 2,
                  child: _FadeSlide(delay: 180, child: productsPanel),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppDimensions.spaceLg),
      ],
    );
  }
}
