import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a single line item within a completed sale.
class SaleItemModel {
  final String productName;
  final String invoiceNumber;
  final double price;
  final int quantity;

  const SaleItemModel({
    required this.productName,
    required this.invoiceNumber,
    required this.price,
    required this.quantity,
  });

  double get subtotal => price * quantity;

  factory SaleItemModel.fromMap(Map<String, dynamic> map) {
    return SaleItemModel(
      invoiceNumber: map['invoice_number'] as String? ?? '',
      productName: map['productName'] as String? ?? 'Unknown Product',
      price: ((map['price'] ?? 0) as num).toDouble(),
      quantity: ((map['quantity'] ?? 1) as num).toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'productName': productName, 'price': price, 'quantity': quantity};
  }
}

/// Represents a completed sale document from the `Sales` subcollection.
class SaleModel {
  final String id;
  final String invoiceNumber;
  final List<SaleItemModel> items;
  final double total;
  final DateTime createdAt;

  const SaleModel({
    required this.id,
    required this.invoiceNumber,
    required this.items,
    required this.total,
    required this.createdAt,
  });

  int get itemCount => items.length;

  int get totalUnits => items.fold<int>(0, (sum, item) => sum + item.quantity);

  factory SaleModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    final rawItems = data['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map((item) => SaleItemModel.fromMap(item))
        .toList();

    final createdAtRaw = data['createdAt'];
    final createdAt = createdAtRaw is Timestamp
        ? createdAtRaw.toDate()
        : DateTime.now(); // fallback if somehow missing/malformed

    return SaleModel(
      id: doc.id,
      invoiceNumber: data['invoice_number'] as String? ?? '',
      items: items,
      total: ((data['total'] ?? 0) as num).toDouble(),
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoice_number': invoiceNumber,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'createdAt': createdAt,
    };
  }
}
