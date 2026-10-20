import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/dashboard/dashboard_view_model.dart';

class SalesChart extends StatelessWidget {
  const SalesChart({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboard = context.watch<DashboardViewModel>();

    if (dashboard.isLoadingWeeklySales) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    final totals = dashboard.weeklySalesTotals;
    final labels = dashboard.weeklyLabels;
    final maxValue = totals.isEmpty
        ? 0.0
        : totals.reduce((a, b) => a > b ? a : b);

    if (maxValue <= 0) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.show_chart_rounded,
              size: 32,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
            Text(
              'No sales in the last 7 days',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _LineChartPainter(
                  values: totals,
                  maxValue: maxValue,
                  lineColor: AppColors.primary,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(labels.length, (i) {
            final isToday = i == labels.length - 1;
            return Expanded(
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  color: isToday ? AppColors.textPrimary : Colors.grey.shade500,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  final double maxValue;
  final Color lineColor;

  _LineChartPainter({
    required this.values,
    required this.maxValue,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 46.0; // room for y-axis labels
    const topPadding = 16.0;
    const bottomPadding = 4.0;

    final chartWidth = size.width - leftPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    // ---- Y-axis grid lines + labels ----
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;

    final labelStyle = TextStyle(
      fontSize: 10,
      color: Colors.grey.shade500,
      fontWeight: FontWeight.w500,
    );

    const gridLines = 4;
    for (int i = 0; i <= gridLines; i++) {
      final y = topPadding + chartHeight * (i / gridLines);
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), gridPaint);

      final labelValue = maxValue * (1 - i / gridLines);
      final tp = TextPainter(
        text: TextSpan(text: _formatCompact(labelValue), style: labelStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    if (values.length < 2) return;

    // ---- Build point coordinates ----
    final stepX = chartWidth / (values.length - 1);
    final points = List.generate(values.length, (i) {
      final x = leftPadding + stepX * i;
      final fraction = maxValue == 0 ? 0.0 : values[i] / maxValue;
      final y = topPadding + chartHeight * (1 - fraction);
      return Offset(x, y);
    });

    // ---- Smooth line path (catmull-rom-ish via cubic bezier) ----
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    // ---- Gradient fill under the line ----
    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, topPadding + chartHeight)
      ..lineTo(points.first.dx, topPadding + chartHeight)
      ..close();

    final fillPaint = Paint()
      ..shader =
          LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              lineColor.withValues(alpha: 0.22),
              lineColor.withValues(alpha: 0.0),
            ],
          ).createShader(
            Rect.fromLTWH(leftPadding, topPadding, chartWidth, chartHeight),
          );

    canvas.drawPath(fillPath, fillPaint);

    // ---- The line itself ----
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(linePath, linePaint);

    // ---- Data point dots ----
    for (int i = 0; i < points.length; i++) {
      final isLast = i == points.length - 1;
      final point = points[i];

      if (isLast) {
        // Highlighted "today" point: white ring + filled center + value bubble
        canvas.drawCircle(
          point,
          7,
          Paint()..color = lineColor.withValues(alpha: 0.18),
        );
        canvas.drawCircle(point, 4.5, Paint()..color = Colors.white);
        canvas.drawCircle(
          point,
          4.5,
          Paint()
            ..color = lineColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5,
        );

        final bubbleText = 'Rs. ${_formatCompact(values[i])}';
        final tp = TextPainter(
          text: TextSpan(
            text: bubbleText,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final bubbleWidth = tp.width + 16;
        final bubbleHeight = tp.height + 8;
        var bubbleX = point.dx - bubbleWidth / 2;
        bubbleX = bubbleX.clamp(leftPadding, size.width - bubbleWidth);
        final bubbleY = point.dy - bubbleHeight - 14;

        final bubbleRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(bubbleX, bubbleY, bubbleWidth, bubbleHeight),
          const Radius.circular(6),
        );
        canvas.drawRRect(bubbleRect, Paint()..color = lineColor);
        tp.paint(canvas, Offset(bubbleX + 8, bubbleY + 4));
      } else {
        canvas.drawCircle(point, 3, Paint()..color = Colors.white);
        canvas.drawCircle(
          point,
          3,
          Paint()
            ..color = lineColor.withValues(alpha: 0.5)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  String _formatCompact(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(value >= 10000 ? 0 : 1)}k';
    }
    return value.toStringAsFixed(0);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.maxValue != maxValue;
  }
}
