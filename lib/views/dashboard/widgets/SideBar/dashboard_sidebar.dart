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
      width: 250,
      color: AppColors.textPrimary,
      child: Column(
        children: [
          // Store and User Information
          Consumer<AuthViewModel>(
            builder: (context, authViewModel, child) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.store,
                        color: AppColors.primaryDark,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authViewModel.userStoreName ?? 'Store Manager',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            authViewModel.userFullName ?? 'User Name',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(),

          const SizedBox(height: 10),

          // Menu
          SidebarItem(
            icon: Icons.dashboard_outlined,
            title: 'Dashboard',
            isSelected: viewModel.selectedIndex == 0,
            onTap: () {
              viewModel.changePage(0);
            },
          ),

          SidebarItem(
            icon: Icons.inventory_2_outlined,
            title: 'Products',
            isSelected: viewModel.selectedIndex == 1,
            onTap: () {
              viewModel.changePage(1);
            },
          ),

          SidebarItem(
            icon: Icons.warehouse_outlined,
            title: 'Inventory',
            isSelected: viewModel.selectedIndex == 2,
            onTap: () {
              viewModel.changePage(2);
            },
          ),

          SidebarItem(
            icon: Icons.point_of_sale_outlined,
            title: 'Sales',
            isSelected: viewModel.selectedIndex == 3,
            onTap: () {
              viewModel.changePage(3);
            },
          ),

          SidebarItem(
            icon: Icons.people_outline,
            title: 'Customers',
            isSelected: viewModel.selectedIndex == 4,
            onTap: () {
              viewModel.changePage(4);
            },
          ),

          SidebarItem(
            icon: Icons.local_shipping_outlined,
            title: 'Suppliers',
            isSelected: viewModel.selectedIndex == 5,
            onTap: () {
              viewModel.changePage(5);
            },
          ),

          SidebarItem(
            icon: Icons.bar_chart_outlined,
            title: 'Reports',
            isSelected: viewModel.selectedIndex == 6,
            onTap: () {
              viewModel.changePage(6);
            },
          ),

          SidebarItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            isSelected: viewModel.selectedIndex == 7,
            onTap: () {
              viewModel.changePage(7);
            },
          ),

          const Spacer(),

          const Divider(),

          SidebarItem(
            icon: Icons.logout,
            title: 'Logout',
            isSelected: false,
            onTap: () {
              // Logout later
            },
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
