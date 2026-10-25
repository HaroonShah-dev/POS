import 'package:store_management_system/models/product_model.dart';
import 'package:thermal_printer_flutter/thermal_printer_flutter.dart';

class PrinterService {
  final ThermalPrinterFlutter _printer = ThermalPrinterFlutter();

  Future<List<Printer>> getUsbPrinters() async {
    return await _printer.getPrinters(printerType: PrinterType.usb);
  }

  Printer? pickThermal(List<Printer> devices) {
    const virtual = [
      'onenote',
      'pdf',
      'xps',
      'fax',
      'anydesk',
      'send to',
      'print to',
    ];
    const thermalHints = [
      'pos',
      'thermal',
      'receipt',
      'xprinter',
      'epson',
      'tm-',
      '80',
    ];

    final real = devices.where((d) {
      final n = (d.name).toLowerCase();
      return !virtual.any(n.contains);
    }).toList();

    for (final d in real) {
      final n = (d.name).toLowerCase();
      if (thermalHints.any(n.contains)) return d;
    }
    return real.isNotEmpty ? real.first : null;
  }

  Future<void> printSale({
    required Printer target,
    required String storeName,
    required String storePhone,
    required List<ProductModel> items,
    required Map<String, int> quantities,
    required double total,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    List<int> bytes = [];

    bytes += generator.text(
      storeName,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    if (storePhone.isNotEmpty) {
      bytes += generator.text(
        storePhone,
        styles: const PosStyles(align: PosAlign.center),
      );
    }

    bytes += generator.text(
      _formatDate(DateTime.now()),
      styles: const PosStyles(align: PosAlign.center),
    );

    bytes += generator.hr(ch: '-');

    for (final product in items) {
      final qty = quantities[product.id] ?? 1;

      bytes += generator.row([
        PosColumn(text: product.productName, width: 7),
        PosColumn(
          text: (product.price * qty).toStringAsFixed(0),
          width: 5,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);

      bytes += generator.text('$qty x Rs. ${product.price.toStringAsFixed(0)}');
    }

    bytes += generator.hr(ch: '-');

    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(bold: true, height: PosTextSize.size2),
      ),
      PosColumn(
        text: 'Rs. ${total.toStringAsFixed(0)}',
        width: 6,
        styles: const PosStyles(
          align: PosAlign.right,
          bold: true,
          height: PosTextSize.size2,
        ),
      ),
    ]);

    bytes += generator.feed(2);
    bytes += generator.cut();

    await _printer.printBytes(bytes: bytes, printer: target);
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} • '
        '${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')} $period';
  }
}
