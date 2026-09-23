import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store_management_system/core/colors/app_colors.dart';
import 'package:store_management_system/models/product_model.dart';

class ProductViewModel extends ChangeNotifier {
  List<ProductModel> productData = [];

  TextEditingController productName = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController stock = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isloading = false;

  Future updateProduct({
    required String productId,
    required String productName,
    required String category,
    required double price,
    required int stock,
  }) async {
    try {
      final user = auth.currentUser;

      if (user == null) return;

      await firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Product')
          .doc(productId)
          .update({
            'productName': productName,
            'category': category,
            'price': price,
            'stock': stock,
            'updatedAt': DateTime.timestamp(),
          });
    } catch (error) {
      debugPrint('Update Product Error: $error');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getProduct() {
    final user = auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Product')
        .snapshots();
  }

  Future addProduct(BuildContext context) async {
    try {
      isloading = true;
      notifyListeners();
      final user = auth.currentUser;

      if (user == null) {
        return;
      }

      await firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Product')
          .doc()
          .set({
            'productName': productName.text.trim(),
            'category': category.text.trim(),
            'price': double.tryParse(price.text.trim()) ?? 0,
            'stock': int.tryParse(stock.text.trim()) ?? 0,
            'createdAt': DateTime.timestamp(),
            'updatedAt': DateTime.timestamp(),
          });
      final categoryQuery = await firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Categories')
          .where('categoryName', isEqualTo: category.text.trim())
          .limit(1)
          .get();
      if (categoryQuery.docs.isEmpty && category.text.trim().isNotEmpty) {
        await firestore
            .collection('Users')
            .doc(user.uid)
            .collection('Categories')
            .doc()
            .set({
              'categoryName': category.text.trim(),
              'createdAt': DateTime.timestamp(),
            });
      }

      isloading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added Successfully'),
          backgroundColor: AppColors.success,
        ),
      );
      productName.clear();
      price.clear();
      stock.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() {
    final user = auth.currentUser;
    debugPrint('Current User: ${user?.uid}');
    if (user == null) {
      return const Stream.empty();
    }

    return firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Categories')
        .orderBy('categoryName')
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFilteredProducts({
    required String selectedCategory,
    required String selectedFilter,
  }) {
    final user = auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    Query<Map<String, dynamic>> product = firestore
        .collection('Users')
        .doc(user.uid)
        .collection('Product');

    // Category filter
    if (selectedCategory != 'All Categories') {
      product = product.where('category', isEqualTo: selectedCategory);
    }

    // Stock filter
    if (selectedFilter == 'In Stock') {
      product = product.where('stock', isGreaterThan: 10);
    }

    if (selectedFilter == 'Low Stock') {
      product = product
          .where('stock', isGreaterThan: 0)
          .where('stock', isLessThanOrEqualTo: 10);
    }

    if (selectedFilter == 'Out of Stock') {
      product = product.where('stock', isEqualTo: 0);
    }

    // Real-time data
    return product.snapshots();
  }
}
