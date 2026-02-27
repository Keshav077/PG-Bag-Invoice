import 'package:flutter/material.dart';
import 'package:pg_bag_invoice/models/invoice_data.dart';
import 'package:pg_bag_invoice/screens/section_two_screen.dart';
import 'package:pg_bag_invoice/screens/history_screen.dart';
import 'package:pg_bag_invoice/widgets/custom_button.dart';
import 'package:pg_bag_invoice/widgets/custom_text_field.dart';
import 'package:pg_bag_invoice/widgets/display_field.dart';

class SectionOneScreen extends StatefulWidget {
  final InvoiceData invoiceData;

  const SectionOneScreen({super.key, required this.invoiceData});

  @override
  State<SectionOneScreen> createState() => _SectionOneScreenState();
}

class _SectionOneScreenState extends State<SectionOneScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _customerNameController;
  late final TextEditingController _quotationNumberController;
  late final TextEditingController _gramsController;
  late final TextEditingController _widthController;
  late final TextEditingController _lengthController;
  late final TextEditingController _yarnController;

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController(text: widget.invoiceData.customerName);
    _quotationNumberController = TextEditingController(text: widget.invoiceData.quotationNumber);
    _gramsController = TextEditingController(text: widget.invoiceData.grams.toString());
    _widthController = TextEditingController(text: widget.invoiceData.width.toString());
    _lengthController = TextEditingController(text: widget.invoiceData.length.toString());
    _yarnController = TextEditingController(text: widget.invoiceData.yarn.toString());

    _gramsController.addListener(_updateCalculations);
    _widthController.addListener(_updateCalculations);
    _lengthController.addListener(_updateCalculations);
    _yarnController.addListener(_updateCalculations);
  }

  @override
  void dispose() {
    _gramsController.removeListener(_updateCalculations);
    _widthController.removeListener(_updateCalculations);
    _lengthController.removeListener(_updateCalculations);
    _yarnController.removeListener(_updateCalculations);
    _customerNameController.dispose();
    _quotationNumberController.dispose();
    _gramsController.dispose();
    _widthController.dispose();
    _lengthController.dispose();
    _yarnController.dispose();
    super.dispose();
  }

  void _updateCalculations() {
    setState(() {
      widget.invoiceData.grams = double.tryParse(_gramsController.text) ?? 0;
      widget.invoiceData.width = double.tryParse(_widthController.text) ?? 0;
      widget.invoiceData.length = double.tryParse(_lengthController.text) ?? 0;
      widget.invoiceData.yarn = double.tryParse(_yarnController.text) ?? 1;
    });
  }

  void _clear() {
    setState(() {
      _customerNameController.clear();
      _quotationNumberController.clear();
      _gramsController.text = '0';
      _widthController.text = '0';
      _lengthController.text = '0';
      _yarnController.text = '1';
      _updateCalculations();
    });
  }

  void _next() {
    if (_formKey.currentState!.validate()) {
      widget.invoiceData.customerName = _customerNameController.text;
      widget.invoiceData.quotationNumber = _quotationNumberController.text;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SectionTwoScreen(invoiceData: widget.invoiceData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polynest Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clear,
            tooltip: 'Clear All Fields',
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Polynest Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_chart),
              title: const Text('Generate Invoice'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                _clear();
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Generated Invoices'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
            ),
          ],
        ),
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
                    TextFormField(
                      controller: _customerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Customer Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter customer name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _quotationNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Quotation Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quotation number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _gramsController,
                      labelText: 'Grams',
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _widthController,
                      labelText: 'Width (inches)',
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _lengthController,
                      labelText: 'Length (inches)',
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: _yarnController,
                      labelText: 'Yarn (g)',
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    DisplayField(label: 'Total Bag Weight', value: widget.invoiceData.totalBagWeight, unit: 'g'),
                  ],
                ),
              ),
              CustomButton(text: 'Next', onPressed: _next),
            ],
          ),
        ),
      ),
    );
  }
}
