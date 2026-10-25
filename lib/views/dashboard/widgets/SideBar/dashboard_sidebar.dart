import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/auth/authViewModel/auth_view_model.dart';
import 'package:store_management_system/views/dashboard/dashboard_view_model.dart';

import 'sidebar_item.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return Container(
      width: 260,
      color: AppColors.primary,
      child: SafeArea(
        child: Column(
          children: [
            // ---------- Store / User info ----------
            Consumer<AuthViewModel>(
              builder: (context, authViewModel, child) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: AppColors.infoBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: const Icon(
                          Icons.store_rounded,
                          color: AppColors.secondaryDark,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authViewModel.userStoreName ?? 'Store Manager',
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: AppTextStyles.button,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              authViewModel.userFullName ?? 'User Name',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            Divider(height: 1, color: AppColors.primaryDark),

            // ---------- Menu ----------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SidebarSectionLabel('MAIN'),
                    SidebarItem(
                      icon: Icons.dashboard_outlined,
                      title: 'Dashboard',
                      isSelected: viewModel.selectedIndex == 0,
                      onTap: () => viewModel.changePage(0),
                    ),
                    SidebarItem(
                      icon: Icons.point_of_sale_outlined,
                      title: 'Sales',
                      isSelected: viewModel.selectedIndex == 3,
                      onTap: () => viewModel.changePage(3),
                    ),

                    const SizedBox(height: 12),
                    const _SidebarSectionLabel('CATALOG'),
                    SidebarItem(
                      icon: Icons.inventory_2_outlined,
                      title: 'Products',
                      isSelected: viewModel.selectedIndex == 1,
                      onTap: () => viewModel.changePage(1),
                    ),
                    SidebarItem(
                      icon: Icons.warehouse_outlined,
                      title: 'Inventory',
                      isSelected: viewModel.selectedIndex == 2,
                      onTap: () => viewModel.changePage(2),
                    ),
                    SidebarItem(
                      icon: Icons.local_shipping_outlined,
                      title: 'Suppliers',
                      isSelected: viewModel.selectedIndex == 5,
                      onTap: () => viewModel.changePage(5),
                    ),

                    const SizedBox(height: 12),
                    const _SidebarSectionLabel('BUSINESS'),
                    SidebarItem(
                      icon: Icons.people_outline,
                      title: 'Customers',
                      isSelected: viewModel.selectedIndex == 4,
                      onTap: () => viewModel.changePage(4),
                    ),
                    SidebarItem(
                      icon: Icons.bar_chart_outlined,
                      title: 'Reports',
                      isSelected: viewModel.selectedIndex == 6,
                      onTap: () => viewModel.changePage(6),
                    ),
                    SidebarItem(
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      isSelected: viewModel.selectedIndex == 7,
                      onTap: () => viewModel.changePage(7),
                    ),
                  ],
                ),
              ),
            ),

            // ---------- Logout ----------
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    // Logout later
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 19,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarSectionLabel extends StatelessWidget {
  final String label;

  const _SidebarSectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}
