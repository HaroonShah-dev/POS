import 'package:flutter/material.dart';
import 'package:store_management_system/models/sales_model.dart';
import 'package:store_management_system/views/reports/report_model.dart';

class ReportWindow {
  final DateTime start;
  final DateTime end;
  final DateTime prevStart;
  const ReportWindow(this.start, this.end, this.prevStart);
}

class ReportData {
  final List<ReportSummary> summaries;
  final List<ChartPoint> chart;
  final List<TopProduct> topProducts;
  final String chartTitle;

  const ReportData({
    required this.summaries,
    required this.chart,
    required this.topProducts,
    required this.chartTitle,
  });
}

enum _Bucket { hour, day, week, month }

class ReportCalculator {
  static const _months = [
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
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static ReportWindow window(ReportPeriod period, DateTimeRange? range) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (range != null) {
      final start = DateTime(
        range.start.year,
        range.start.month,
        range.start.day,
      );
      final end = DateTime(range.end.year, range.end.month, range.end.day + 1);
      return ReportWindow(start, end, start.subtract(end.difference(start)));
    }

    switch (period) {
      case ReportPeriod.daily:
        return ReportWindow(
          today,
          DateTime(today.year, today.month, today.day + 1),
          DateTime(today.year, today.month, today.day - 1),
        );
      case ReportPeriod.weekly:
        return ReportWindow(
          DateTime(today.year, today.month, today.day - 6),
          DateTime(today.year, today.month, today.day + 1),
          DateTime(today.year, today.month, today.day - 13),
        );
      case ReportPeriod.monthly:
        return ReportWindow(
          DateTime(now.year, now.month, 1),
          DateTime(now.year, now.month + 1, 1),
          DateTime(now.year, now.month - 1, 1),
        );
      case ReportPeriod.yearly:
        return ReportWindow(
          DateTime(now.year, 1, 1),
          DateTime(now.year + 1, 1, 1),
          DateTime(now.year - 1, 1, 1),
        );
    }
  }

  static ReportData build(
    List<SaleModel> allSales,
    ReportPeriod period,
    DateTimeRange? range,
  ) {
    final w = window(period, range);

    final current = allSales
        .where(
          (s) => !s.createdAt.isBefore(w.start) && s.createdAt.isBefore(w.end),
        )
        .toList();
    final previous = allSales
        .where(
          (s) =>
              !s.createdAt.isBefore(w.prevStart) &&
              s.createdAt.isBefore(w.start),
        )
        .toList();

    return ReportData(
      summaries: _summaries(current, previous),
      chart: _chart(current, w, period, range != null),
      topProducts: _topProducts(current),
      chartTitle: _chartTitle(_bucketFor(period, w, range != null)),
    );
  }

  static List<ReportSummary> _summaries(
    List<SaleModel> cur,
    List<SaleModel> prev,
  ) {
    final curTotal = _sumTotal(cur);
    final prevTotal = _sumTotal(prev);
    final curAvg = cur.isEmpty ? 0.0 : curTotal / cur.length;
    final prevAvg = prev.isEmpty ? 0.0 : prevTotal / prev.length;

    return [
      _summary(
        'Total Sales',
        'Rs. ${formatNumber(curTotal)}',
        Icons.payments_rounded,
        curTotal,
        prevTotal,
      ),
      _summary(
        'Total Orders',
        formatNumber(cur.length),
        Icons.receipt_long_rounded,
        cur.length.toDouble(),
        prev.length.toDouble(),
      ),
      _summary(
        'Avg. Order Value',
        'Rs. ${formatNumber(curAvg)}',
        Icons.shopping_bag_rounded,
        curAvg,
        prevAvg,
      ),
      _summary(
        'Items Sold',
        formatNumber(_itemsSold(cur)),
        Icons.inventory_2_rounded,
        _itemsSold(cur).toDouble(),
        _itemsSold(prev).toDouble(),
      ),
    ];
  }

  static ReportSummary _summary(
    String title,
    String value,
    IconData icon,
    double current,
    double previous,
  ) {
    String change;
    bool positive;

    if (previous == 0) {
      change = current == 0 ? '0%' : 'New';
      positive = true;
    } else {
      final pct = (current - previous) / previous * 100;
      positive = pct >= 0;
      change = '${positive ? '+' : ''}${pct.toStringAsFixed(1)}%';
    }

    return ReportSummary(
      title: title,
      value: value,
      change: change,
      isPositive: positive,
      icon: icon,
    );
  }

  static double _sumTotal(List<SaleModel> sales) =>
      sales.fold(0.0, (sum, s) => sum + s.total);

  static int _itemsSold(List<SaleModel> sales) => sales.fold(
    0,
    (sum, s) => sum + s.items.fold(0, (a, i) => a + i.quantity),
  );

  static _Bucket _bucketFor(ReportPeriod p, ReportWindow w, bool custom) {
    if (!custom) {
      switch (p) {
        case ReportPeriod.daily:
          return _Bucket.hour;
        case ReportPeriod.weekly:
          return _Bucket.day;
        case ReportPeriod.monthly:
          return _Bucket.week;
        case ReportPeriod.yearly:
          return _Bucket.month;
      }
    }
    final days = _daysBetween(w.start, w.end);
    if (days <= 1) return _Bucket.hour;
    if (days <= 31) return _Bucket.day;
    return _Bucket.month;
  }

  static String _chartTitle(_Bucket b) {
    switch (b) {
      case _Bucket.hour:
        return 'Sales by hour';
      case _Bucket.day:
        return 'Sales by day';
      case _Bucket.week:
        return 'Sales by week';
      case _Bucket.month:
        return 'Sales by month';
    }
  }

  static int _daysBetween(DateTime a, DateTime b) =>
      (b.difference(a).inHours / 24).round();

  static List<ChartPoint> _chart(
    List<SaleModel> sales,
    ReportWindow w,
    ReportPeriod period,
    bool custom,
  ) {
    final bucket = _bucketFor(period, w, custom);

    late int count;
    late int Function(DateTime) indexOf;
    late String Function(int) labelOf;

    switch (bucket) {
      case _Bucket.hour:
        count = 12;
        indexOf = (d) => d.hour ~/ 2;
        labelOf = (i) => _hourLabel(i * 2);
        break;

      case _Bucket.day:
        count = _daysBetween(w.start, w.end);
        indexOf = (d) =>
            _daysBetween(w.start, DateTime(d.year, d.month, d.day));
        labelOf = (i) {
          final day = DateTime(w.start.year, w.start.month, w.start.day + i);
          return count <= 7
              ? _weekdays[day.weekday - 1]
              : '${day.day}/${day.month}';
        };
        break;

      case _Bucket.week:
        final lastDay = DateTime(w.start.year, w.start.month + 1, 0).day;
        count = ((lastDay - 1) ~/ 7) + 1;
        indexOf = (d) => (d.day - 1) ~/ 7;
        labelOf = (i) => 'W${i + 1}';
        break;

      case _Bucket.month:
        final last = w.end.subtract(const Duration(milliseconds: 1));
        count =
            (last.year - w.start.year) * 12 + last.month - w.start.month + 1;
        indexOf = (d) => (d.year - w.start.year) * 12 + d.month - w.start.month;
        labelOf = (i) {
          final m = DateTime(w.start.year, w.start.month + i, 1);
          return _months[m.month - 1];
        };
        break;
    }

    final totals = List<double>.filled(count, 0);
    for (final s in sales) {
      final i = indexOf(s.createdAt);
      if (i >= 0 && i < count) totals[i] += s.total;
    }

    return List.generate(count, (i) => ChartPoint(labelOf(i), totals[i]));
  }

  static String _hourLabel(int hour) {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    return '$h ${hour >= 12 ? 'PM' : 'AM'}';
  }

  static List<TopProduct> _topProducts(List<SaleModel> sales) {
    final qty = <String, int>{};
    final amount = <String, double>{};

    for (final sale in sales) {
      for (final item in sale.items) {
        qty[item.productName] = (qty[item.productName] ?? 0) + item.quantity;
        amount[item.productName] =
            (amount[item.productName] ?? 0) + item.subtotal;
      }
    }

    final sorted = amount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted
        .take(5)
        .map((e) => TopProduct(e.key, qty[e.key] ?? 0, e.value))
        .toList();
  }
}
