import 'package:cloud_firestore/cloud_firestore.dart';

class InvoiceService {
  final FirebaseFirestore _firestore;

  InvoiceService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const String _prefix = 'INV';
  static const int _padding = 6;

  DocumentReference<Map<String, dynamic>> _counterRef(String uid) {
    return _firestore
        .collection('Users')
        .doc(uid)
        .collection('Meta')
        .doc('invoiceCounter');
  }

  /// Atomically generates and returns the next invoice number.
  /// Guaranteed unique even under concurrent calls (multiple devices).
  Future<String> generateNextInvoiceNumber(String uid) async {
    final ref = _counterRef(uid);

    final nextNumber = await _firestore.runTransaction<int>((
      transaction,
    ) async {
      final snapshot = await transaction.get(ref);

      final current = snapshot.exists
          ? (snapshot.data()?['lastNumber'] as int? ?? 0)
          : 0;

      final next = current + 1;

      transaction.set(ref, {
        'lastNumber': next,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return next;
    });

    return _format(nextNumber);
  }

  String _format(int number) =>
      '$_prefix-${number.toString().padLeft(_padding, '0')}';

  /// Looks up a single sale by its invoice number — for dashboard search.
  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> findSaleByInvoiceNumber(
    String uid,
    String invoiceNumber,
  ) async {
    final query = await _firestore
        .collection('Users')
        .doc(uid)
        .collection('Sales')
        .where('invoiceNumber', isEqualTo: invoiceNumber)
        .limit(1)
        .get();

    return query.docs.isEmpty ? null : query.docs.first;
  }
}
