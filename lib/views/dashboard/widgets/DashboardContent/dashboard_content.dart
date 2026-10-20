import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/dashboard/dashboard_view_model.dart';
import 'package:store_management_system/views/products/widgets/product_search_bar.dart';
import 'package:store_management_system/views/sales/saleoverview/sales_over_view.dart';
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
  bool _showDetails = false; // controls the Recent Sales + Low Stock panel

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
      color: AppColors.infoBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Here's what's happening in your store today",
                        style: AppTextStyles.caption,
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Expanded(child: ProductSearchBar()),
                SizedBox(width: 16),
                CustomButton(),
              ],
            ),
            const SizedBox(height: 32),

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
                        iconColor: AppColors.primary,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: const DashboardCard(
                        title: 'Total Orders',
                        value: '0',
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
                        iconColor: AppColors.primary,
                      ),
                    ),
                    SizedBox(
                      width: cardWidth,
                      child: DashboardCard(
                        title: 'Low Stock',
                        value: ' ${sales.pl}',
                        subtitle: 'Needs attention',
                        icon: Icons.warning_rounded,
                        iconColor: AppColors.primary,
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
                          color: AppColors.primary.withValues(alpha: 0.08),
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

            const SizedBox(height: 36),
            _ToggleDetailsButton(
              isOpen: _showDetails,
              onPressed: () => setState(() => _showDetails = !_showDetails),
            ),
            const SizedBox(height: 16),
            // ---------- Expandable details panel ----------
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.04),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: _showDetails
                    ? Padding(
                        key: const ValueKey('details-open'),
                        padding: const EdgeInsets.only(top: 24),
                        child: _SalesStockPanel(
                          lowStockCount: '${sales.pl}',
                          onClose: () => setState(() => _showDetails = false),
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('details-closed')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// Toggle button
// =====================================================================
class _ToggleDetailsButton extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onPressed;

  const _ToggleDetailsButton({required this.isOpen, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isOpen
            ? AppColors.primary.withValues(alpha: 0.10)
            : AppColors.primary,
        foregroundColor: isOpen ? AppColors.primary : Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: AnimatedRotation(
        turns: isOpen ? 0.5 : 0,
        duration: const Duration(milliseconds: 250),
        child: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      ),
      label: Text(
        isOpen ? 'Hide Sales' : 'View Sales',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

// =====================================================================
// Modern container: Recent Sales + Low Stock
// =====================================================================
class _SalesStockPanel extends StatelessWidget {
  final String lowStockCount;
  final VoidCallback onClose;

  const _SalesStockPanel({required this.lowStockCount, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Header ----
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 16, 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.insights_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sales & Stock Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Latest transactions and items that need restocking',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  tooltip: 'Close',
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.border),

          // ---- Body ----
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 760;

              final recent = _DetailSection(
                icon: Icons.receipt_long_rounded,
                accent: AppColors.primary,
                title: 'Recent Sales',
                actionLabel: 'View all',
                onAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SalesOverview()),
                  );
                },
                child: const RecentSalesList(),
              );

              final lowStock = _DetailSection(
                icon: Icons.warning_amber_rounded,
                accent: Colors.orange.shade700,
                title: 'Low Stock Products',
                badge: lowStockCount,
                actionLabel: 'View all',
                onAction: () {},
                child: const _EmptyPanelState(
                  icon: Icons.inventory_outlined,
                  message: 'Low stock products will appear here',
                ),
              );

              if (isNarrow) {
                return Column(
                  children: [
                    recent,
                    Divider(height: 1, color: AppColors.border),
                    lowStock,
                  ],
                );
              }

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: recent),
                    VerticalDivider(width: 1, color: AppColors.border),
                    Expanded(child: lowStock),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String title;
  final String? badge;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget child;

  const _DetailSection({
    required this.icon,
    required this.accent,
    required this.title,
    required this.child,
    this.badge,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: accent),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge!.trim(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              if (actionLabel != null)
                InkWell(
                  onTap: onAction,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          actionLabel!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(height: 260, child: child),
        ],
      ),
    );
  }
}

// =====================================================================
// Shared helpers
// =====================================================================
BoxDecoration _panelDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.03),
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
