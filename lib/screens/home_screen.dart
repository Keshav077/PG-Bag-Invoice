import 'package:flutter/material.dart';
import 'package:pg_bag_invoice/models/invoice_data.dart';
import 'package:pg_bag_invoice/screens/section_one_screen.dart';
import 'package:pg_bag_invoice/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PG Bag Invoice'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Create New Invoice',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SectionOneScreen(
                      invoiceData: InvoiceData(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
