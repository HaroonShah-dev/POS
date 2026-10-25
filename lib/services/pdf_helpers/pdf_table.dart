import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:store_management_system/models/sales_model.dart';

String _fmtDate(DateTime d) => d.toString().split(' ')[0];

pw.Widget pdfTable({required List<SaleModel> sales}) {
  // 1. Calculate totals once, outside the table.
  final grandTotal = sales.fold<double>(0, (sum, s) => sum + s.total);
  final totalUnits = sales.fold<int>(0, (sum, s) => sum + s.totalUnits);

  const headers = [
    'S.No',
    'Invoice No',
    'Date',
    'Products',
    'Units',
    'Items',
    'Total',
  ];

  // 2. Build rows: every cell is a String, and each row has 6 values.
  final rows = <List<String>>[
    for (var i = 0; i < sales.length; i++)
      [
        '${i + 1}',
        sales[i].invoiceNumber,
        _fmtDate(sales[i].createdAt),
        sales[i].itemCount.toString(),
        sales[i].totalUnits.toString(),
        sales[i].items
            .map((item) => '${item.productName} (x${item.quantity})')
            .join(', '),
        'Rs. ${sales[i].total.toStringAsFixed(2)}',
      ],
  ];

  // 3. The table.
  final table = pw.TableHelper.fromTextArray(
    headers: headers,
    data: rows,
    headerStyle: pw.TextStyle(
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    ),
    headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
    cellStyle: const pw.TextStyle(fontSize: 9),
    cellPadding: const pw.EdgeInsets.all(8),
    border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
    oddRowDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
    cellAlignments: {
      0: pw.Alignment.center, // S.No
      1: pw.Alignment.centerLeft, // Invoice No
      2: pw.Alignment.center, // Date
      3: pw.Alignment.center, // Products
      4: pw.Alignment.center, // Units
      5: pw.Alignment.centerRight, // Total (numbers read best right-aligned)
    },
  );

  // 4. Table + summary box underneath.
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    children: [
      table,
      pw.SizedBox(height: 10),
      pw.Container(
        padding: const pw.EdgeInsets.all(10),
        color: PdfColors.grey300,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Total: ${sales.length} sales, $totalUnits units',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'Rs. ${grandTotal.toStringAsFixed(2)}',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
