// import 'package:flutter/material.dart';

// class SaleItem {
//   final String name;
//   final String category;
//   final double price;
//   int quantity;

//   SaleItem({
//     required this.name,
//     required this.category,
//     required this.price,
//     this.quantity = 1,
//   });

//   double get total => price * quantity;
// }

// class SalesViewModel extends ChangeNotifier {
//   final List<SaleItem> cart = [];

//   // Add product to cart
//   void addToCart({
//     required String name,
//     required String category,
//     required double price,
//   }) {
//     // Check if product already exists
//     final index = cart.indexWhere((item) => item.name == name);

//     if (index != -1) {
//       // Product already exists → increase quantity
//       cart[index].quantity++;
//     } else {
//       // Product doesn't exist → add new item
//       cart.add(SaleItem(name: name, category: category, price: price));
//     }
//     print('press');

//     notifyListeners();
//   }

//   // Increase quantity
//   void increaseQuantity(int index) {
//     cart[index].quantity++;
//     notifyListeners();
//   }

//   // Decrease quantity
//   void decreaseQuantity(int index) {
//     if (cart[index].quantity > 1) {
//       cart[index].quantity--;
//     } else {
//       cart.removeAt(index);
//     }

//     notifyListeners();
//   }

//   // Remove complete product
//   void removeItem(int index) {
//     cart.removeAt(index);
//     notifyListeners();
//   }

//   // Clear complete sale
//   void clearCart() {
//     cart.clear();
//     notifyListeners();
//   }

//   // Calculate subtotal
//   double get subtotal {
//     double total = 0;

//     for (final item in cart) {
//       total += item.total;
//     }

//     return total;
//   }

//   // For now discount is 0
//   double get discount => 0;

//   // Final total
//   double get total {
//     return subtotal - discount;
//   }
// }
