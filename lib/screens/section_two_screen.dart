import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pg_bag_invoice/models/invoice_data.dart';
import 'package:pg_bag_invoice/screens/invoice_screen.dart';
import 'package:pg_bag_invoice/utils/invoice_generator.dart';
import 'package:pg_bag_invoice/widgets/custom_button.dart';
import 'package:pg_bag_invoice/widgets/custom_text_field.dart';
import 'package:pg_bag_invoice/widgets/display_field.dart';

class SectionTwoScreen extends StatefulWidget {
  final InvoiceData invoiceData;

  const SectionTwoScreen({super.key, required this.invoiceData});

  @override
  State<SectionTwoScreen> createState() => _SectionTwoScreenState();
}

class _SectionTwoScreenState extends State<SectionTwoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fabricRateController;
  late final TextEditingController _cuttingChargesController;
  late final TextEditingController _stitchingChargesController;
  late final TextEditingController _miscController;
  late final TextEditingController _printingController;
  late final TextEditingController _lynerController;
  late final TextEditingController _gazzetteController;
  late final TextEditingController _transportController;
  late final TextEditingController _marginPercentageController;

  @override
  void initState() {
    super.initState();
    _fabricRateController =
        TextEditingController(text: widget.invoiceData.fabricRate.toString());
    _cuttingChargesController = TextEditingController(
        text: widget.invoiceData.cuttingCharges.toString());
    _stitchingChargesController = TextEditingController(
        text: widget.invoiceData.stitchingCharges.toString());
    _miscController = TextEditingController(text: widget.invoiceData.misc.toString());
    _printingController =
        TextEditingController(text: widget.invoiceData.printing.toString());
    _lynerController = TextEditingController(text: widget.invoiceData.lyner.toString());
    _gazzetteController =
        TextEditingController(text: widget.invoiceData.gazzette.toString());
    _transportController =
        TextEditingController(text: widget.invoiceData.transport.toString());
    _marginPercentageController = TextEditingController(
        text: widget.invoiceData.marginPercentage.toString());

    _fabricRateController.addListener(_updateCalculations);
    _cuttingChargesController.addListener(_updateCalculations);
    _stitchingChargesController.addListener(_updateCalculations);
    _miscController.addListener(_updateCalculations);
    _printingController.addListener(_updateCalculations);
    _lynerController.addListener(_updateCalculations);
    _gazzetteController.addListener(_updateCalculations);
    _transportController.addListener(_updateCalculations);
    _marginPercentageController.addListener(_updateCalculations);
  }

  @override
  void dispose() {
    _fabricRateController.removeListener(_updateCalculations);
    _cuttingChargesController.removeListener(_updateCalculations);
    _stitchingChargesController.removeListener(_updateCalculations);
    _miscController.removeListener(_updateCalculations);
    _printingController.removeListener(_updateCalculations);
    _lynerController.removeListener(_updateCalculations);
    _gazzetteController.removeListener(_updateCalculations);
    _transportController.removeListener(_updateCalculations);
    _marginPercentageController.removeListener(_updateCalculations);

    _fabricRateController.dispose();
    _cuttingChargesController.dispose();
    _stitchingChargesController.dispose();
    _miscController.dispose();
    _printingController.dispose();
    _lynerController.dispose();
    _gazzetteController.dispose();
    _transportController.dispose();
    _marginPercentageController.dispose();
    super.dispose();
  }

  void _updateCalculations() {
    setState(() {
      widget.invoiceData.fabricRate = double.tryParse(_fabricRateController.text) ?? 0;
      widget.invoiceData.cuttingCharges =
          double.tryParse(_cuttingChargesController.text) ?? 0.2;
      widget.invoiceData.stitchingCharges =
          double.tryParse(_stitchingChargesController.text) ?? 0.2;
      widget.invoiceData.misc = double.tryParse(_miscController.text) ?? 0.2;
      widget.invoiceData.printing = double.tryParse(_printingController.text) ?? 0.75;
      widget.invoiceData.lyner = double.tryParse(_lynerController.text) ?? 0;
      widget.invoiceData.gazzette = double.tryParse(_gazzetteController.text) ?? 0.3;
      widget.invoiceData.transport = double.tryParse(_transportController.text) ?? 0.1;
      widget.invoiceData.marginPercentage =
          double.tryParse(_marginPercentageController.text) ?? 0;
    });
  }

  void _clear() {
    setState(() {
      _fabricRateController.text = '0';
      _cuttingChargesController.text = '0.2';
      _stitchingChargesController.text = '0.2';
      _miscController.text = '0.2';
      _printingController.text = '0.75';
      _lynerController.text = '0';
      _gazzetteController.text = '0.3';
      _transportController.text = '0.1';
      _marginPercentageController.text = '0';
      _updateCalculations();
    });
  }

  Future<void> _generateInvoice() async {
    if (_formKey.currentState!.validate()) {
      // 1. Generate the PDF bytes once
      final pdfBytes = await InvoiceGenerator.generate(widget.invoiceData, PdfPageFormat.a4);
      
      // 2. Save it to internal storage once
      await InvoiceGenerator.saveInvoice(widget.invoiceData, pdfBytes);

      // 3. Navigate to preview screen
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InvoiceScreen(invoiceData: widget.invoiceData),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cost'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clear,
            tooltip: 'Clear All Fields',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    CustomTextField(
                      controller: _fabricRateController,
                      labelText: 'Fabric Rate',
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _cuttingChargesController,
                            labelText: 'Cutting Charges',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomTextField(
                            controller: _stitchingChargesController,
                            labelText: 'Stitching Charges',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _printingController,
                            labelText: 'Printing',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomTextField(
                            controller: _lynerController,
                            labelText: 'Lyner',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _gazzetteController,
                            labelText: 'Gazzette',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomTextField(
                            controller: _transportController,
                            labelText: 'Transport',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _miscController,
                      labelText: 'Misc',
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _marginPercentageController,
                      labelText: 'Margin %',
                    ),
                  ],
                ),
              ),
              const Divider(),
              DisplayField(
                label: 'Final Bag Cost',
                value: widget.invoiceData.finalBagCost,
                unit: 'Rs',
              ),
              const SizedBox(height: 8),
              CustomButton(text: 'Generate Invoice', onPressed: _generateInvoice),
            ],
          ),
        ),
      ),
    );
  }
}
