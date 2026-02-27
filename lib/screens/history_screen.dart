import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<File> _invoices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    setState(() => _isLoading = true);
    try {
      final directory = await getApplicationDocumentsDirectory();
      final folder = Directory('${directory.path}/invoices');
      if (await folder.exists()) {
        final List<FileSystemEntity> entities = await folder.list().toList();
        final List<File> files = entities.whereType<File>().toList();
        
        // Sort by creation date (last modified as proxy) descending
        files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));
        
        setState(() {
          _invoices = files;
        });
      }
    } catch (e) {
      debugPrint('Error loading invoices: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generated Invoices'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _invoices.isEmpty
              ? const Center(child: Text('No invoices found'))
              : ListView.builder(
                  itemCount: _invoices.length,
                  itemBuilder: (context, index) {
                    final file = _invoices[index];
                    final fileName = file.path.split('/').last;
                    return ListTile(
                      leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: Text(fileName),
                      subtitle: Text(file.lastModifiedSync().toString().split('.')[0]),
                      onTap: () => _viewInvoice(file),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () => Share.shareXFiles([XFile(file.path)]),
                          ),
                          IconButton(
                            icon: const Icon(Icons.print),
                            onPressed: () async {
                              final bytes = await file.readAsBytes();
                              await Printing.layoutPdf(onLayout: (_) => bytes);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  void _viewInvoice(File file) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(file.path.split('/').last)),
          body: PdfPreview(
            build: (format) => file.readAsBytes(),
            allowSharing: true,
            allowPrinting: true,
          ),
        ),
      ),
    );
  }
}
