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
  required DateTimeRange range,
}) async {
  final doc = pw.Document();

  doc.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(10),

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
              rightText:
                  'Report Range: ${range.start.toString().split(' ')[0]} - ${range.end.toString().split(' ')[0]}',
            ),
            pw.Divider(color: PdfColors.black, thickness: 1),
          ],
        );
      },

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
          rightText: 'Report Range: daily, weekly, monthly, quarterly, yearly, custom range',
        ),

        pw.Divider(color: PdfColors.black, thickness: 1),
        pw.Text(
          'Report Summary',
          style: const pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),

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
  required DateTimeRange range,
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
            range: range,
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
  DateTimeRange<DateTime>? range,
  //required DateTimeRange range,
}) async {
  final bytes = await _makePdf(
    range: range!,
    sales: sales,
    managerName: managerName,
    storeAddress: storeAddress,
  );
  final dir = await getApplicationDocumentsDirectory();

  final file = File('${dir.path}/reports.pdf');
  await file.writeAsBytes(bytes);
  return file.path;
}
