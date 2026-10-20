import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/models/product_model.dart';
import 'package:store_management_system/models/sales_model.dart';
import 'package:store_management_system/services/invoice_services.dart';

class SalesViewModel extends ChangeNotifier {
  final List<ProductModel> currentSale = [];
  final Map<String, int> quantities = {};
  bool isProcessingSale = false;
  String? lastInvoiceNumber;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final InvoiceService invoiceService = InvoiceService();

  double get grandTotal {
    double total = 0;
    for (final product in currentSale) {
      total += product.price * (quantities[product.id] ?? 1);
    }
    return total;
  }

  void addProductToSale(ProductModel product) {
    final exists = currentSale.any((p) => p.id == product.id);

    if (exists) {
      quantities[product.id] = (quantities[product.id] ?? 1) + 1;
    } else {
      currentSale.add(product);
      quantities[product.id] = 1;
    }
    notifyListeners();
  }

  void removeFromSale(String productId) {
    currentSale.removeWhere((p) => p.id == productId);
    quantities.remove(productId);
    notifyListeners();
  }

  void clearSale() {
    currentSale.clear();
    quantities.clear();
    notifyListeners();
  }

  Stream<List<SaleModel>> listenSale() {
    final user = auth.currentUser;
    if (user == null) {
      return Stream.empty();
    }
    return firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Sales')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => SaleModel.fromFirestore(doc)).toList(),
        );
  }

  /// Sales between [start] (inclusive) and [end] (exclusive), newest first.
  Stream<List<SaleModel>> listenSalesBetween(DateTime start, DateTime end) {
    final user = auth.currentUser;
    if (user == null) return const Stream.empty();

    return firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Sales')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('createdAt', isLessThan: Timestamp.fromDate(end))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => SaleModel.fromFirestore(d)).toList(),
        );
  }

  Stream<List<SaleModel>> sales() {
    final user = auth.currentUser;
    if (user == null) return const Stream.empty();

    return firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Sales')
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => SaleModel.fromFirestore(d)).toList(),
        );
  }

  Future<bool> completeSale(BuildContext context) async {
    final user = auth.currentUser;
    if (user == null || currentSale.isEmpty) return false;

    isProcessingSale = true;
    notifyListeners();

    try {
      final invoiceNumber = await invoiceService.generateNextInvoiceNumber(
        user.uid,
      );
      final items = currentSale.map((product) {
        final qty = quantities[product.id] ?? 1;
        return {
          'productName': product.productName,
          'price': product.price,
          'quantity': qty,
        };
      }).toList();

      await firestore.collection('Users').doc(user.uid).collection('Sales').add(
        {
          'invoice_number': invoiceNumber,
          'items': items,
          'total': grandTotal,
          'createdAt': DateTime.timestamp(),
        },
      );

      for (final product in currentSale) {
        final qty = quantities[product.id] ?? 1;

        await firestore
            .collection('Users')
            .doc(user.uid)
            .collection('Product')
            .doc(product.documentId)
            .update({'stock': FieldValue.increment(-qty)});
      }
      lastInvoiceNumber = invoiceNumber;
      clearSale();
      return true;
    } catch (error) {
      debugPrint('Complete Sale Error: $error');
      debugPrint(
        'Products: ${currentSale.map((p) => '${p.id} - ${p.productName}').toList()}',
      );
      return false;
    } finally {
      isProcessingSale = false;
      notifyListeners();
    }
  }
}
