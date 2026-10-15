import 'package:flutter/material.dart';
import '../pdf_utils/pdf_models.dart';

class PdfMetadataScreen extends StatelessWidget {
  const PdfMetadataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PDF Metadata & Page Counter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          pdfHero('PDF Inspector', 'Inspect file metadata, total pages, author and specs', Colors.blue, Icons.find_in_page),
          const SizedBox(height: 16),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.description, color: Colors.blue),
                  title: Text('File Name'),
                  subtitle: Text('Project_Report_Final.pdf', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.countertops, color: Colors.green),
                  title: Text('Total Pages'),
                  subtitle: Text('24 Pages', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.storage, color: Colors.orange),
                  title: Text('File Size'),
                  subtitle: Text('4.82 MB (4,821,048 Bytes)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.person, color: Colors.purple),
                  title: Text('Author'),
                  subtitle: Text('All Tools User', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.lock, color: Colors.red),
                  title: Text('Encrypted / Protected'),
                  subtitle: Text('No (Public Document)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
