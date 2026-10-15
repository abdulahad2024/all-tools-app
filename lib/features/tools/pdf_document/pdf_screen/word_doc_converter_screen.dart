import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pdf_utils/pdf_models.dart';

final selectedDocNameProvider = StateProvider<String>((ref) => 'Sample_Document.docx');
final selectedDocFormatProvider = StateProvider<String>((ref) => 'PDF');

class WordDocConverterScreen extends ConsumerWidget {
  const WordDocConverterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docName = ref.watch(selectedDocNameProvider);
    final targetFormat = ref.watch(selectedDocFormatProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Word to PDF Converter')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          pdfHero('Word & Document Converter', 'Convert DOCX, DOC and TXT files to PDF format', Colors.indigo, Icons.published_with_changes),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.description, color: Colors.blue, size: 36),
              title: Text(docName, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('2.1 MB • Word Document'),
              trailing: ElevatedButton(
                child: const Text('Pick File'),
                onPressed: () {
                  ref.read(selectedDocNameProvider.notifier).state = 'Assignment_Proposal.docx';
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Convert To Format:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  DropdownButton<String>(
                    value: targetFormat,
                    items: ['PDF', 'DOCX', 'TXT'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                    onChanged: (val) {
                      if (val != null) ref.read(selectedDocFormatProvider.notifier).state = val;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.transform),
            label: Text('Convert $docName to $targetFormat', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Document converted to $targetFormat successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
