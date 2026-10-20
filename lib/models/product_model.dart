import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String documentId;
  final String id;
  final String productName;
  final String category;
  final double price;
  final int stock;

  ProductModel({
    required this.documentId,
    required this.id,
    required this.productName,
    required this.category,
    required this.price,
    required this.stock,
  });

  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return ProductModel(
      documentId: document.id,
      id: data['id'] is num ? (data['id'] as num).toString() : data['id'] ?? '',

      productName: data['productName'] ?? '',

      category: data['category'] ?? '',

      price: data['price'] is num
          ? (data['price'] as num).toDouble()
          : double.tryParse(data['price']?.toString() ?? '') ?? 0,

      stock: data['stock'] is num
          ? (data['stock'] as num).toInt()
          : int.tryParse(data['stock']?.toString() ?? '') ?? 0,
    );
  }
}
