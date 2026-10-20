import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:store_management_system/models/sales_model.dart';
import 'package:store_management_system/services/pdf_helpers/buildPdfHeader.dart'
    as pw;
import 'package:store_management_system/services/pdf_helpers/pdf_info.dart'
    as pw;
import 'package:store_management_system/services/pdf_helpers/pdf_table.dart'
    as pw
    show pdfTable;

Future<Uint8List> _makePdf({
  required List<SaleModel> sales,
  required String managerName,
  required String storeAddress,
}) async {
  final doc = pw.Document();

  doc.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(12),

      // Header har page par repeat hoga.
      header: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              child: pw.buildPdfHeader(
                reportTitle: 'Store Performance & Operations Report',
                generatedBy: 'Admin',
                manager: storeAddress,
                date: DateTime.now(),
              ),
            ),
            pw.pdfInfo(
              leftText: 'Selected Report Type That You Selected',
              rightText: 'Weekly',
            ),
            pw.Divider(color: PdfColors.black, thickness: 1),
          ],
        );
      },

      // Footer mein page number show hoga.
      footer: (context) {
        return pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 9),
          ),
        );
      },

      build: (context) => [
        pw.pdfInfo(
          leftText: 'Store Location: 12345 / Main Street Store Location',
          rightText:
              'Date Generated: ${DateTime.now().toString().split(' ')[0]}',
        ),

        pw.Divider(color: PdfColors.black, thickness: 1),

        pw.pdfInfo(
          leftText: 'Manager: $managerName',
          rightText: 'Reporting Period: Daily, Weekly, Monthly, Yearly',
        ),

        pw.Divider(color: PdfColors.black, thickness: 1),

        // pw.Text(
        //   'Report Summary: This report provides an overview of the store\'s performance and operations, including sales, inventory, and customer data.',
        //   style: const pw.TextStyle(fontSize: 12),
        // ),
        pw.SizedBox(height: 12),

        // Sales table
        pw.Center(child: pw.pdfTable(sales: sales)),
      ],
    ),
  );

  return doc.save();
}

void previewPdf(
  BuildContext context, {
  required List<SaleModel> sales,
  required String managerName,
  required String storeAddress,
}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: PdfPreview(
          build: (format) => _makePdf(
            sales: sales,
            managerName: managerName,
            storeAddress: storeAddress,
          ),
          canChangePageFormat: false,
          canChangeOrientation: false,
        ),
      ),
    ),
  );
}

Future<String> savePdf({
  required List<SaleModel> sales,
  required String managerName,
  required String storeAddress,
}) async {
  final bytes = await _makePdf(
    sales: sales,
    managerName: managerName,
    storeAddress: storeAddress,
  );
  final dir = await getApplicationDocumentsDirectory();

  final file = File('${dir.path}/reports.pdf');
  await file.writeAsBytes(bytes);
  return file.path;
}
