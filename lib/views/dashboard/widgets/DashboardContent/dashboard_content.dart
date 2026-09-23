import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/widgets/custom_button.dart';

import 'dashboard_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title
            const Text('Dashboard', style: AppTextStyles.h1),

            const SizedBox(height: 6),

            Text(
              'Overview of your store',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 28),
            CustomButton(),
            const SizedBox(height: 28),
            // Summary cards
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: const [
                DashboardCard(
                  title: "Today's Sales",
                  value: 'Rs. 25,500',
                  subtitle: 'Today',
                  icon: Icons.payments_outlined,
                  iconColor: AppColors.success,
                ),

                DashboardCard(
                  title: 'Total Orders',
                  value: '128',
                  subtitle: 'All orders',
                  icon: Icons.shopping_cart_outlined,
                  iconColor: AppColors.primary,
                ),

                DashboardCard(
                  title: 'Total Products',
                  value: '356',
                  subtitle: 'All products',
                  icon: Icons.inventory_2_outlined,
                  iconColor: AppColors.info,
                ),

                DashboardCard(
                  title: 'Low Stock',
                  value: '12',
                  subtitle: 'Need attention',
                  icon: Icons.warning_amber_outlined,
                  iconColor: AppColors.warning,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Sales overview heading
            const Text(
              'Sales Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Your sales performance over time',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 16),

            // Sales chart container
            Container(
              height: 280,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: Center(
                      child: Text(
                        'Sales chart will come here',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Bottom dashboard sections
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent sales
                Expanded(
                  child: _DashboardSection(
                    title: 'Recent Sales',
                    child: Center(
                      child: Text(
                        'Recent sales will come here',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Low stock
                Expanded(
                  child: _DashboardSection(
                    title: 'Low Stock Products',
                    child: Center(
                      child: Text(
                        'Low stock products will come here',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DashboardSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(child: child),
        ],
      ),
    );
  }
}
