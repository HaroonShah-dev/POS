import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget pdfInfo({required String leftText, required String rightText}) {
  return pw.Container(
    padding: const pw.EdgeInsets.all(12),
    color: PdfColors.grey300,
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(' $leftText', style: pw.TextStyle()),
        pw.Text(' $rightText', style: pw.TextStyle()),
      ],
    ),
  );
}
