import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/reports/report_model.dart';

class ReportBarChart extends StatefulWidget {
  final List<ChartPoint> points;

  const ReportBarChart({super.key, required this.points});

  @override
  State<ReportBarChart> createState() => _ReportBarChartState();
}

class _ReportBarChartState extends State<ReportBarChart> {
  int? _hovered;

  @override
  Widget build(BuildContext context) {
    final points = widget.points;
    final maxValue = points.isEmpty
        ? 0.0
        : points.map((p) => p.value).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 260,
      child: LayoutBuilder(
        builder: (context, constraints) {
          const labelHeight = 26.0;
          const bubbleSpace = 30.0;
          final barArea = constraints.maxHeight - labelHeight - bubbleSpace;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(points.length, (i) {
              final p = points[i];
              final fraction = maxValue == 0 ? 0.0 : p.value / maxValue;
              final isHovered = _hovered == i;

              return Expanded(
                child: MouseRegion(
                  onEnter: (_) => setState(() => _hovered = i),
                  onExit: (_) => setState(() => _hovered = null),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // ---- value bubble (visible on hover) ----
                      SizedBox(
                        height: bubbleSpace,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 150),
                          opacity: isHovered ? 1 : 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusSm - 2,
                              ),
                            ),
                            child: Text(
                              'Rs. ${formatCompact(p.value)}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ---- bar: height tween (load / data change),
                      //      width + color animate on hover ----
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: fraction),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, _) {
                          return SizedBox(
                            height: (barArea * value)
                                .clamp(4.0, barArea)
                                .toDouble(),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              width: isHovered ? 30 : 26,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(AppDimensions.radiusSm),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: isHovered
                                      ? [
                                          AppColors.secondaryLight,
                                          AppColors.secondary,
                                        ]
                                      : [
                                          AppColors.primaryLight,
                                          AppColors.primary,
                                        ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // ---- x-axis label ----
                      SizedBox(
                        height: labelHeight,
                        child: Center(
                          child: Text(
                            p.label,
                            style: AppTextStyles.caption.copyWith(
                              fontSize: 11.5,
                              fontWeight: isHovered
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isHovered
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
