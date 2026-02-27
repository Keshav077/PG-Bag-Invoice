import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pg_bag_invoice/models/invoice_data.dart';

class InvoiceGenerator {
  static Future<Uint8List> generate(InvoiceData invoiceData, PdfPageFormat format) async {
    try {
      final pdf = pw.Document();

      final fontData = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
      final ttf = pw.Font.ttf(fontData);

      pdf.addPage(
        pw.Page(
          pageFormat: format,
          margin: const pw.EdgeInsets.all(2 * PdfPageFormat.cm),
          theme: pw.ThemeData.withFont(base: ttf),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                pw.SizedBox(height: 30),
                _buildInvoiceDetails(invoiceData),
                pw.SizedBox(height: 30),
                _buildQuotationDetails(invoiceData),
                pw.Spacer(),
                _buildFooter(invoiceData),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      await _saveInvoiceLocally(invoiceData, bytes);
      return bytes;
    } catch (e, s) {
      debugPrint('Error generating PDF: $e');
      debugPrint('Stack trace: $s');
      rethrow;
    }
  }

  static Future<void> _saveInvoiceLocally(InvoiceData invoiceData, Uint8List bytes) async {
    try {
      final directory = await getApplicationDocumentsThemeDirectory();
      final folder = Directory('${directory.path}/invoices');
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      String customerName = invoiceData.customerName.isEmpty ? 'Customer' : invoiceData.customerName;
      String baseName = '$customerName quotation invoice';
      String fileName = '$baseName.pdf';
      File file = File('${folder.path}/$fileName');

      int counter = 1;
      while (await file.exists()) {
        fileName = '$baseName ($counter).pdf';
        file = File('${folder.path}/$fileName');
        counter++;
      }

      await file.writeAsBytes(bytes);
      debugPrint('Invoice saved to: ${file.path}');
    } catch (e) {
      debugPrint('Error saving invoice: $e');
    }
  }

  static Future<Directory> getApplicationDocumentsThemeDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  static pw.Widget _buildHeader() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text('Polynest PVT LTD', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.UrlLink(
          destination: 'https://goo.gl/maps/76xWBzumW7g7f2GaA?g_st=aw',
          child: pw.Text(
            'Phase5, IDA Jeedimetla, Plot No. 154, Rami Reddy Nagar, Hydewrabad 500055, Telangana',
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(color: PdfColors.blue, decoration: pw.TextDecoration.underline),
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text('polynesthyd@gmail.com | 7780781224'),
        pw.Divider(thickness: 2, height: 30),
      ],
    );
  }

  static pw.Widget _buildInvoiceDetails(InvoiceData invoiceData) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Quotation For:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(invoiceData.customerName.isEmpty ? 'Valued Customer' : invoiceData.customerName),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Quotation #: ${invoiceData.quotationNumber}'),
            pw.Text('Date: ${DateTime.now().toLocal().toString().split(' ')[0]}'),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildQuotationDetails(InvoiceData invoiceData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Dimensions', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 15),
        _buildSpecRow('Width:', '${invoiceData.width.toStringAsFixed(2)} inches'),
        _buildSpecRow('Length:', '${invoiceData.length.toStringAsFixed(2)} inches'),
        _buildSpecRow('Grams:', '${invoiceData.grams.toStringAsFixed(2)} g'),
        pw.Divider(height: 20),
        _buildSpecRow('Total Bag Weight:', '${invoiceData.totalBagWeight.round()} g', isBold: true),
      ],
    );
  }

  static pw.Widget _buildSpecRow(String label, String value, {bool isBold = false}) {
    final style = isBold ? pw.TextStyle(fontWeight: pw.FontWeight.bold) : const pw.TextStyle();
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: style),
          pw.Text(value, style: style),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(InvoiceData invoiceData) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Divider(height: 20),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text('Cost: ', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.Text('Rs ${invoiceData.finalBagCost.toStringAsFixed(2)} / Bag', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: PdfColors.green700)),
          ],
        ),
        pw.SizedBox(height: 50),
        pw.Center(
          child: pw.Text('Thank you for your business!', style: pw.TextStyle(fontStyle: pw.FontStyle.italic)),
        ),
      ],
    );
  }
}
