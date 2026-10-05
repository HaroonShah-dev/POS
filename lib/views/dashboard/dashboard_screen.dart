import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/views/auth/authViewModel/auth_view_model.dart';
import 'package:store_management_system/views/dashboard/dashboard_view_model.dart';
import 'package:store_management_system/views/dashboard/widgets/SideBar/dashboard_sidebar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthViewModel>(context, listen: false).listenToUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DashboardViewModel>();

    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            const DashboardSidebar(),

            Expanded(
              child: Container(
                color: AppColors.accent,
                child: viewModel.getSelectedScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
