import 'package:flutter/material.dart';
import 'package:pg_bag_invoice/models/invoice_data.dart';
import 'package:pg_bag_invoice/utils/invoice_generator.dart';
import 'package:printing/printing.dart';

class InvoiceScreen extends StatelessWidget {
  final InvoiceData invoiceData;

  const InvoiceScreen({super.key, required this.invoiceData});

  @override
  Widget build(BuildContext context) {
    final fileName = '${invoiceData.customerName} quotation invoice';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
      ),
      body: PdfPreview(
        build: (format) => InvoiceGenerator.generate(invoiceData, format),
        pdfFileName: fileName,
      ),
    );
  }
}
