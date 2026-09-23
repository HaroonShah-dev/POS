import 'package:flutter/material.dart';
import 'package:store_management_system/views/dashboard/widgets/DashboardContent/dashboard_content.dart';
import 'package:store_management_system/views/products/product_screen.dart';
import 'package:store_management_system/views/sales/sales_screen.dart';

class DashboardViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  void changePage(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Widget getSelectedScreen() {
    switch (selectedIndex) {
      case 0:
        return const DashboardContent();

      case 1:
        return ProductScreen();

      case 2:
        return Text('Inventory');

      case 3:
        return SalesScreen();

      case 4:
        return Text('Customer');

      case 5:
        return Text('Supplier');

      case 6:
        return Text('Reports');

      case 7:
        return Text('Settings');

      default:
        return const DashboardContent();
    }
  }
}
