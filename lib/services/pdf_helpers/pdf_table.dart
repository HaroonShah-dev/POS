import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:store_management_system/models/sales_model.dart';

pw.Widget pdfTable({required List<SaleModel> sales}) {
  return pw.TableHelper.fromTextArray(
    headers: [
      'S.No',
      'Invoice No',
      'Date',
      'Payment Method',
      'Total',
      'ItemsCount',
    ],
    data: sales.asMap().entries.map((entry) {
      int index = entry.key; //its important to handle sale
      SaleModel sale = entry.value;

      return [
        (index + 1).toString(),

        sale.invoiceNumber,
        sale.createdAt,
        'Cash',
        'Rs. ${sale.total.toStringAsFixed(2)}',
        sale.totalUnits,
        sale.items.toList(),
      ];
    }).toList(),
    headerStyle: pw.TextStyle(
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    ),
    headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
    cellStyle: const pw.TextStyle(fontSize: 9),
    cellPadding: const pw.EdgeInsets.all(8),
    border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
  );
}
