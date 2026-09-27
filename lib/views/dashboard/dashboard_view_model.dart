import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/views/dashboard/widgets/DashboardContent/dashboard_content.dart';
import 'package:store_management_system/views/products/product_screen.dart';
import 'package:store_management_system/views/sales/sales_screen.dart';

class DashboardViewModel extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  StreamSubscription<QuerySnapshot>? _todaySalesSub;
  StreamSubscription<QuerySnapshot>? totalProduct;
  StreamSubscription<QuerySnapshot>? _weeklySalesSub;
  StreamSubscription<QuerySnapshot>? _recentSalesSub;
  StreamSubscription<QuerySnapshot>? productDetail;

  List<Map<String, dynamic>> recentSales = [];
  List<double> weeklySalesTotals = List.filled(7, 0);
  List<String> weeklyLabels = List.filled(7, '');

  bool isLoadingWeeklySales = true;
  bool isLoadingRecentSales = true;
  bool isLoadingTodaySales = true;

  int selectedIndex = 0;
  int todaySalesCount = 0;
  int totalCountProduct = 0;
  double subTotalProduct = 0;
  double todaySalesTotal = 0;
  int pl = 0;
  double low = 0;

  void listenLowProduct() {
    if (productDetail != null) return;
    final user = auth.currentUser;
    if (user == null) return;
    productDetail = firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Product')
        .where('stock', isLessThanOrEqualTo: 10)
        .snapshots()
        .listen(
          (snapshot) {
            pl = snapshot.docs.length;
            low = snapshot.docs.fold<double>(
              0,
              (sum, doc) =>
                  sum + ((doc.data()['stock'] ?? 0) as num).toDouble(),
            );
            notifyListeners();
          },
          onDone: () {
            debugPrint('Error');
          },
          onError: (error) {
            debugPrint('low product Error: $error');
          },
        );
  }

  void listenToWeeklySales() {
    if (_weeklySalesSub != null) return;

    final user = auth.currentUser;
    if (user == null) return;

    isLoadingWeeklySales = true;
    notifyListeners();

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final rangeStart = todayStart.subtract(const Duration(days: 6));
    final rangeEnd = todayStart.add(const Duration(days: 1));

    _weeklySalesSub = firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Sales')
        .where('createdAt', isGreaterThanOrEqualTo: rangeStart)
        .where('createdAt', isLessThan: rangeEnd)
        .snapshots()
        .listen(
          (snapshot) {
            final totals = List<double>.filled(7, 0);

            for (final doc in snapshot.docs) {
              final data = doc.data();
              final createdAt = (data['createdAt'] as Timestamp).toDate();
              final dayIndex = DateTime(
                createdAt.year,
                createdAt.month,
                createdAt.day,
              ).difference(rangeStart).inDays;
              if (dayIndex >= 0 && dayIndex < 7) {
                totals[dayIndex] += ((data['total'] ?? 0) as num).toDouble();
              }
            }

            const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            weeklySalesTotals = totals;
            weeklyLabels = List.generate(7, (i) {
              final d = rangeStart.add(Duration(days: i));
              return dayNames[d.weekday - 1];
            });
            isLoadingWeeklySales = false;
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Weekly Sales Stream Error: $error');
            isLoadingWeeklySales = false;
            notifyListeners();
          },
        );
  }

  void listenToTotalProuct() {
    if (totalProduct != null) return;
    final user = auth.currentUser;
    if (user == null) return;
    totalProduct = firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Product')
        .snapshots()
        .listen(
          (snapshot) {
            totalCountProduct = snapshot.docs.length;
            subTotalProduct = snapshot.docs.fold<double>(
              0,
              (sum, doc) =>
                  sum + ((doc.data()['price'] ?? 0) as num).toDouble(),
            );
          },
          onError: (error) {
            debugPrint('Error come from $error');
          },
        );
  }

  void listenToTodaySales() {
    if (_todaySalesSub != null) return;

    final user = auth.currentUser;
    if (user == null) return;

    isLoadingTodaySales = true;
    notifyListeners();

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    _todaySalesSub = firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Sales')
        .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
        .where('createdAt', isLessThan: endOfDay)
        .snapshots()
        .listen(
          (snapshot) {
            todaySalesCount = snapshot.docs.length;
            todaySalesTotal = snapshot.docs.fold<double>(
              0,
              (sum, doc) =>
                  sum + ((doc.data()['total'] ?? 0) as num).toDouble(),
            );
            isLoadingTodaySales = false;
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Today Sales Stream Error: $error');
            isLoadingTodaySales = false;
            notifyListeners();
          },
        );
  }

  void listenToRecentSales({int limit = 6}) {
    debugPrint('listenToRecentSales called');
    if (_recentSalesSub != null) return;

    final user = auth.currentUser;
    if (user == null) return;

    isLoadingRecentSales = true;
    notifyListeners();

    _recentSalesSub = firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Sales')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .listen(
          (snapshot) {
            recentSales = snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'invoiceNumber': data['invoice_number'] ?? '',
                'total': ((data['total'] ?? 0) as num).toDouble(),
                'itemCount': (data['items'] as List?)?.length ?? 0,
                'createdAt': (data['createdAt'] as Timestamp).toDate(),
              };
            }).toList();
            isLoadingRecentSales = false;
            notifyListeners();
          },
          onError: (error) {
            debugPrint('Recent Sales Stream Error: $error');
            isLoadingRecentSales = false;
            notifyListeners();
          },
        );
  }

  @override
  void dispose() {
    _todaySalesSub?.cancel();
    _recentSalesSub?.cancel();
    _weeklySalesSub?.cancel();
    totalProduct?.cancel(); // 👈 add this
    productDetail?.cancel();
    super.dispose();
  }

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
