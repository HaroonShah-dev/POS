import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/dashboard/dashboard_view_model.dart';
import 'package:store_management_system/views/widgets/custom_button.dart';
import 'package:store_management_system/views/widgets/recent_sales_list.dart';
import 'package:store_management_system/views/widgets/sales_chart.dart';

import 'dashboard_card.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().listenToTodaySales();
      context.read<DashboardViewModel>().listenToRecentSales();
      context.read<DashboardViewModel>().listenToWeeklySales();
      context.read<DashboardViewModel>().listenToTotalProuct();
      context.read<DashboardViewModel>().listenLowProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sales = context.watch<DashboardViewModel>();

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- Header ----------
            // ---------- Header ----------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Dashboard',
                        style: AppTextStyles.h1,
                        softWrap: false, // 👈 force single line
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Here's what's happening in your store today",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                CustomButton(),
              ],
            ),
            const SizedBox(height: 32),

            // ---------- Summary cards ----------
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth > 900
                    ? (constraints.maxWidth - 48) / 4
                    : constraints.maxWidth > 600
                    ? (constraints.maxWidth - 16) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    SizedBox(
                      width: cardWidth,
                      child: DashboardCard(
                        title: "Today's Sales",
                        value: sales.isLoadingTodaySales
                            ? '—'
                            : 'Rs. ${sales.todaySalesTotal.toStringAsFixed(0)}',
                        subtitle: sales.isLoadingTodaySales
                            ? 'Loading…'
                            : '${sales.todaySalesCount} orders today',
                        icon: Icons.payments_rounded,
                        iconColor: AppColors.success,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: const DashboardCard(
                        title: 'Total Orders',
                        value: '128',
                        subtitle: 'All time',
                        icon: Icons.receipt_long_rounded,
                        iconColor: AppColors.primary,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: DashboardCard(
                        title: 'Total Products',
                        value: ' ${sales.totalCountProduct.toStringAsFixed(0)}',
                        subtitle: 'In catalog',
                        icon: Icons.inventory_2_rounded,
                        iconColor: AppColors.info,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: DashboardCard(
                        title: 'Low Stock',
                        value: ' ${sales.pl}',
                        subtitle: 'Needs attention',
                        icon: Icons.warning_rounded,
                        iconColor: AppColors.warning,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 36),

            // ---------- Sales overview ----------
            const _SectionHeading(
              title: 'Sales Overview',
              subtitle: 'Your revenue performance over time',
            ),
            const SizedBox(height: 16),

            Container(
              height: 300,
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: _panelDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Revenue Trend',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Last 7 days',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SalesChart()),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ---------- Bottom sections ----------
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 700;
                final recent = _DashboardSection(
                  title: 'Recent Sales',
                  actionLabel: 'View all',
                  onAction: () {},
                  child: const RecentSalesList(),
                );
                final lowStock = _DashboardSection(
                  title: 'Low Stock Products',
                  actionLabel: 'View all',
                  onAction: () {},
                  child: const _EmptyPanelState(
                    icon: Icons.inventory_outlined,
                    message: 'Low stock products will appear here',
                  ),
                );

                if (isNarrow) {
                  return Column(
                    children: [recent, const SizedBox(height: 20), lowStock],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: recent),
                    const SizedBox(width: 20),
                    Expanded(child: lowStock),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _panelDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );
}

class _SectionHeading extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeading({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _DashboardSection extends StatelessWidget {
  final String title;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _DashboardSection({
    required this.title,
    required this.child,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      padding: const EdgeInsets.all(20),
      decoration: _panelDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (actionLabel != null)
                InkWell(
                  onTap: onAction,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      actionLabel!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _EmptyPanelState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyPanelState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 32, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}
