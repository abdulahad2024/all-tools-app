import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pdf_utils/pdf_models.dart';

final pdfFilesListProvider = StateProvider<List<String>>((ref) {
  return [
    'Document_Part1.pdf (2.4 MB)',
    'Document_Part2.pdf (1.8 MB)',
    'Certificate_Scan.pdf (850 KB)',
  ];
});

final splitPagesRangeProvider = StateProvider<String>((ref) => '1-3, 5');

class PdfMergeSplitScreen extends ConsumerWidget {
  final bool isMergeMode;
  const PdfMergeSplitScreen({super.key, this.isMergeMode = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pdfFiles = ref.watch(pdfFilesListProvider);
    final splitRange = ref.watch(splitPagesRangeProvider);

    final title = isMergeMode ? 'PDF Merger' : 'PDF Splitter';
    final color = isMergeMode ? Colors.deepOrange : Colors.teal;
    final icon = isMergeMode ? Icons.merge_type : Icons.call_split;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          pdfHero(title, isMergeMode ? 'Combine multiple PDF documents into a single file' : 'Split pages or extract page ranges from PDF', color, icon),
          const SizedBox(height: 16),
          if (!isMergeMode) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: splitRange,
                      decoration: const InputDecoration(
                        labelText: 'Page Ranges to Extract (e.g. 1-3, 5, 7-10)',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => ref.read(splitPagesRangeProvider.notifier).state = val,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PDF Files (${pdfFiles.length})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.blue),
                onPressed: () {
                  ref.read(pdfFilesListProvider.notifier).update((list) => [...list, 'New_Document_${list.length + 1}.pdf (1.2 MB)']);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...pdfFiles.asMap().entries.map((entry) {
            final idx = entry.key;
            final file = entry.value;
            return Card(
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                title: Text(file, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    ref.read(pdfFilesListProvider.notifier).update((list) => List.from(list)..removeAt(idx));
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: color,
              foregroundColor: Colors.white,
            ),
            icon: Icon(icon),
            label: Text(isMergeMode ? 'Merge All PDFs' : 'Split Selected Pages', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isMergeMode ? '${pdfFiles.length} PDFs merged successfully!' : 'PDF split successfully for range ($splitRange)!'),
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
